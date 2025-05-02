import 'package:usettle/api/dio_client.dart';

import '../model/database_model.dart';

class SingleStoreApi<T extends DatabaseModel> {
  final String Function() getTableNameFunction;
  final String Function() getParametersFunction;
  final DioClient dioClient;

  const SingleStoreApi({
    required this.dioClient,
    required this.getParametersFunction,
    required this.getTableNameFunction,
  });

  Future<List<T>> getAll() async {
    String table = getTableNameFunction();
    Map<String,dynamic> response = await dioClient.getAll(table);
    return [];
  }
}