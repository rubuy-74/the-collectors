abstract class DatabaseModel {

  factory DatabaseModel.geTable() => throw UnimplementedError();
  factory DatabaseModel.getParameters() => throw UnimplementedError();
  List<String> getValues();

}

class User implements DatabaseModel {
  final String name;
  final String mobileNumber;

  const User({
    required this.name,
    required this.mobileNumber
  });

  @override
  List<String> getValues() {
    return [name,mobileNumber];
  }

  static String getTable() => "user";
  static List<String> getParameters() => ["name","mobileNumber"];
}