import 'dart:convert';
import 'package:http/http.dart' as http;

class MbwayApi {
  final String mbwayKey;
  late String requestId = "";

  MbwayApi({
    required this.mbwayKey,
  });

  Future<Map<String, dynamic>> createMbWayPayment({
    required String phoneNumber,
    required double amount,
    required String orderId,
  }) async {
    final uri = Uri.parse('https://api.ifthenpay.com/spg/payment/mbway');
    final body = {
      'mbWayKey': mbwayKey,
      'orderId': orderId,
      'amount': amount.toStringAsFixed(2),
      'mobileNumber': phoneNumber,
      'description': 'Payment for Order $orderId',
    };

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      requestId = responseData['RequestId'];
      return responseData;
    } else {
      throw Exception('MB WAY payment failed: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> checkPaymentStatus() async {
    final Uri uri = Uri.parse("https://api.ifthenpay.com/spg/payment/mbway/status?mbWayKey=$mbwayKey&requestId=$requestId");

    final response = await http.get(
      uri,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData;
    } else {
      throw Exception('Failed to fetch payment status: ${response.body}');
    }
  }
}
