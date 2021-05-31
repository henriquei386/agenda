import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

final String? contactTable = 'contactTable';
final String? idColumn = 'idColumn';
final String? nameColumn = 'nameColumn';
final String? emailColumn = 'emailColumn';
final String? phoneColumn = 'phoneColumn';
final String? imageColumn = 'imageColumn';

class ContactHelper {
  static final ContactHelper? _instance = ContactHelper.internal();
  // Construtor internal(), só pode ser chamado dentro da classe;
  ContactHelper.internal();

  factory ContactHelper() => _instance!;

  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initDb();
      return _db!;
    }
  }

  Future<Database> initDb() async {
    final String? databasesPath = await getDatabasesPath();
    final String? path = join(databasesPath!, 'contacts.db');

    return await openDatabase(path!, version: 1,
        onCreate: (Database db, int newVersion) async {
      await db.execute(
        'CREATE TABLE $contactTable (' +
            '$idColumn INTEGER PRIMARY KEY, ' +
            '$nameColumn TEXT, ' +
            '$emailColumn TEXT, ' +
            '$phoneColumn TEXT, ' +
            '$imageColumn TEXT)',
      );
    });
  }
}

class Contact {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;

  Contact();

  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    image = map[imageColumn];
  }

  Map toMap() {
    Map<String, dynamic>? map = {
      nameColumn!: name,
      emailColumn!: email,
      phoneColumn!: phone,
      imageColumn!: image
    };

    if (map[idColumn!] != null) {
      map[idColumn!] = id;
    }

    return map;
  }

  @override
  String toString() {
    return 'Contact (id: $id, name: $name, email: $email, phone: $phone, image: $image)';
  }
}
