import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class DioClient {
  DioClient() {
    dio = Dio();
  }

  late final Dio dio;
  final String databaseUrl = dotenv.env['DATABASE_URL'] ?? "database_key";
  final String databaseUser = dotenv.env['DATABASE_USER'] ?? "database_user";
  final String databaseDatabase = dotenv.env['DATABASE_DATABASE'] ?? "database_database";
  final String databasePassword = dotenv.env['DATABASE_PASSWORD'] ?? "database_password";

  Options get options => Options( headers: {
        'Authorization':'Basic ${base64Encode(utf8.encode('$databaseUser:$databasePassword'))}',
        'Content-Type':'application/json',
      }
  );

  Future<void> getAll(String table) async {
    String query = 'SELECT * FROM $table';
    Response response = await sendRequest(query,[],'query/rows');
    // TODO: return entityList
    //List<dynamic> entries = response.data!['result'][0]['rows'];
    print(response.data);
  }

  Future<void> get(String table, int id) async {
    // TODO: this may be dangerous
    String query = "SELECT * FROM $table WHERE ID=(?)";
    Response response = await sendRequest(query, [id.toString()],'query/rows');
    print(response.data);
  }

  Future<void> delete(String table, int id) async {
    // TODO: this may be dangerous
    String query = "DELETE * FROM $table WHERE ID=(?)";
    Response response = await sendRequest(query, [id.toString()],'exec');
    print(response.data);
  }

  Future<void> insert(String table, List<String> params,List<String> args) async {
    // TODO: this may be dangerous
    String questionMarkListParams = "(${params.map((e)=> "?").join(",")})";
    String questionMarkList = "(${args.map((e)=> "?").join(",")})";
    String query = "INSERT INTO $table VALUES $questionMarkList";
    Response response = await sendRequest(query, args,'exec');
    print(response.data);
  }

  Future<void> update(String table, List<String> attrs, List<String> values, int id) async {
    StringBuffer queryQuestionMarks = StringBuffer();
    List<String> args = [];
    for(int i = 0; i < attrs.length; i++) {
      queryQuestionMarks.write("?=?");
      args.add(attrs[i]);
      args.add(values[i]);
    }
    args.add(id.toString());

    String query = "UPDATE $table SET $queryQuestionMarks WHERE ID=?" ;
    Response response = await sendRequest(query, args,'exec');
    print(response.data);
  }

  Future<Response> sendRequest(String query, List<String> args, String urlOption) async {
    final Map<String,dynamic> data = {
      'sql' : query,
      'database': databaseDatabase
    };

    if(args.isNotEmpty) {
      data['args'] = args;
    }

    Response response = await dio.post<Map<String,dynamic>>(
      '$databaseUrl/api/v2/$urlOption',
      data:data,
      options: options
    );
    return response;
  }

}
