import 'package:usettle/models/item.dart';
import 'package:usettle/models/profile.dart';

class Participant {
  const Participant({
    required this.id,
    required this.person,
    required this.items,
  });

  final int id;
  final Profile person;
  final List<Item> items;
}
