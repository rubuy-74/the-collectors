import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:usettle/models/item.dart';
import 'package:usettle/models/receipt.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  ScannerState createState() => ScannerState();
}

class ScannerState extends State<Scanner> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  final gemini = Gemini.instance;
  String _geminiResponse = '';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(_cameras![0], ResolutionPreset.high);

      await _cameraController!.initialize();

      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  Future<void> _takePictureAndAnalyze() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      print('Error: Camera is not initialized');
      return;
    }

    setState(() {
      _isProcessing = true;
      _geminiResponse = '';
    });

    try {
      final XFile imageFile = await _cameraController!.takePicture();
      final Uint8List imageBytes = await imageFile.readAsBytes();

      const String prompt = '''
      Analyze the following receipt.
      Identify each purchased item, its price, and its quantity.
      Return the result ONLY as a JSON string representing a list of objects.
      Each object in the list must have the following keys:
      - "product": string (the name of the item)
      - "price": float or string (the price of the single item or total for the line item)
      - "quantity": integer (the number of units purchased)

      If the quantity is not explicitly mentioned for an item, assume it is 1.
      Omit the "IVA" tag.
      Focus on the line items detailing purchases. Ignore totals, taxes, store information unless they look like items.
      Ensure the ENTIRE output is valid JSON and nothing else.  Do NOT include any explanatory text, markdown formatting, or anything else before or after the JSON list.  Do not include any trailing commas.
      ''';

      gemini
          .textAndImage(text: prompt, images: [imageBytes])
          .then((output) {
            String? rawResponse = output?.content?.parts?.last.text;

            if (rawResponse != null) {
              rawResponse = rawResponse.trim();
              if (rawResponse.startsWith('```json')) {
                rawResponse = rawResponse.substring(7);
              }
              if (rawResponse.endsWith('```')) {
                rawResponse = rawResponse.substring(0, rawResponse.length - 3);
              }
              if (rawResponse.startsWith('`')) {
                rawResponse = rawResponse.substring(1);
              }
              if (rawResponse.endsWith('`')) {
                rawResponse = rawResponse.substring(0, rawResponse.length - 1);
              }

              try {
                final jsonResponse = jsonDecode(rawResponse);
                final formattedJson = JsonEncoder.withIndent(
                  '  ',
                ).convert(jsonResponse);

                setState(() {
                  _geminiResponse = formattedJson;

                  final items =
                      (jsonResponse as List).expand((item) {
                        final name = item['product'] as String;
                        final price =
                            double.tryParse(item['price'].toString()) ?? 0.0;
                        final quantity =
                            double.tryParse(item['quantity'].toString()) ?? 1.0;
                        return List.generate(
                          quantity.toInt(),
                          (_) =>
                              Item(id: 0, name: name, price: price / quantity),
                        );
                      }).toList();

                  // Assign unique IDs to each item
                  for (int i = 0; i < items.length; i++) {
                    items[i] = Item(
                      id: i,
                      name: items[i].name,
                      price: items[i].price,
                    );
                  }

                  final receipt = Receipt(
                    total: items.fold(0.0, (sum, item) => sum + item.price),
                    date: DateTime.now(),
                    items: items,
                  );

                  Navigator.pushNamed(context, '/contacts', arguments: receipt);
                });
              } catch (e) {
                print('Error decoding JSON after cleaning: $e');
                setState(() {
                  _geminiResponse =
                      'Error: Could not parse Gemini response as JSON after cleaning. Raw response: $rawResponse. Error: $e';
                });
              }
            } else {
              setState(() {
                _geminiResponse = 'Error: Gemini returned a null response.';
              });
            }
          })
          .catchError((e) {
            print('Error calling Gemini: $e');
            setState(() {
              _geminiResponse = 'Error calling Gemini: $e';
            });
          })
          .whenComplete(() {
            setState(() {
              _isProcessing = false;
            });
          });
    } catch (e) {
      print('Error taking picture or processing: $e');
      setState(() {
        _isProcessing = false;
        _geminiResponse = 'Error taking picture or processing: $e';
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isCameraInitialized
              ? Stack(
                children: [
                  Positioned.fill(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _cameraController!.value.previewSize!.height,
                        height: _cameraController!.value.previewSize!.width,
                        child: CameraPreview(_cameraController!),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 15,
                    child: SafeArea(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed:
                              () => Navigator.popAndPushNamed(context, '/home'),
                          icon: PhosphorIcon(
                            color: Colors.black,
                            PhosphorIcons.arrowLeft(PhosphorIconsStyle.regular),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 15,
                    child: SafeArea(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: PhosphorIcon(
                            color: Colors.black,
                            PhosphorIcons.arrowLeft(PhosphorIconsStyle.regular),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    left: 0,
                    right: 0,
                    child: Center(
                      child:
                          _isProcessing
                              ? CircularProgressIndicator()
                              : Container(
                                decoration: BoxDecoration(
                                  color: Colors.green[800],
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(12),
                                child: IconButton(
                                  onPressed: _takePictureAndAnalyze,
                                  icon: PhosphorIcon(
                                    color: Colors.white,
                                    PhosphorIcons.scan(
                                      PhosphorIconsStyle.regular,
                                    ),
                                    size: 35,
                                  ),
                                ),
                              ),
                    ),
                  ),
                  /*
                  if (_geminiResponse.isNotEmpty)
                    Positioned(
                      bottom: 120,
                      left: 20,
                      right: 20,
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.5,
                        ),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(191),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            _geminiResponse,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    */
                ],
              )
              : Center(child: CircularProgressIndicator()),
    );
  }
}
