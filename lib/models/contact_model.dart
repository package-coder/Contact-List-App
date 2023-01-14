

import 'package:contact_list_app/config/DBHelper.dart';
import 'package:image_picker/image_picker.dart';

class Contact {
  final int? id;
  final String name;
  final String mobileNumber;
  final bool isFavorite;
  final bool isBlacklist;
  final String imagePath;


  Contact({
    this.id,
    required this.imagePath,
    required this.name,
    required this.mobileNumber,
    this.isFavorite = false,
    this.isBlacklist = false
  });

  static Future<List<Contact>> getAll() async {
    var database = await DBHelper.instance.database;
    var contacts = await database.query('contacts', orderBy: 'isFavorite' );

    List<Contact> contactList = contacts.isNotEmpty
        ? contacts.reversed
                .map((e) => Contact.fromMap(e))
                .toList()
        : [];

    return contactList;
  }

  static Future<int> findIdAndUpdate(int? id, Map<String, dynamic> json) async {
    var database = await DBHelper.instance.database;
    return await database.update(
        'contacts',
        json,
        where: 'id = ?',
        whereArgs: [id]
    );
  }

  static Future<List<Contact>> findByNameOrNumber(String query) async {
    var database = await DBHelper.instance.database;
    var contacts = await database.query(
        'contacts',
        where: 'name LIKE ? OR mobileNumber LIKE ?',
        whereArgs: ['$query%', '$query%']
    );

    List<Contact> contactList = contacts.isNotEmpty
        ? contacts.map((e) => Contact.fromMap(e))
        .toList()
        : [];
    return contactList;
  }

  // static Future<List<Contact>> contains(Map<String, dynamic> json) async {
  //   var database = await DBHelper.instance.database;
  //   var contacts = await database.query(
  //       'contacts',
  //       where: 'name LIKE ?% AND mobileNumber LIKE ?%',
  //       whereArgs: [query, query]
  //   );
  //
  //   List<Contact> contactList = contacts.isNotEmpty
  //       ? contacts.map((e) => Contact.fromMap(e))
  //       .toList()
  //       : [];
  //   return contactList;
  // }

  static Future<int> save(Contact contact) async {
    if(contact.id != null) {
      return Future.value(contact.id);
    }

    var database = await DBHelper.instance.database;
    return await database.insert('contacts', contact.toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'name': name,
      'mobileNumber': mobileNumber,
      'isFavorite': isFavorite ? 1 : 0,
      'isBlacklist': isBlacklist ? 1 : 0,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> json) => Contact(
    id: json['id'],
    name: json['name'],
    imagePath: json['imagePath'],
    mobileNumber: json['mobileNumber'],
    isFavorite: json['isFavorite'] == 1,
    isBlacklist: json['isBlacklist'] == 1,
  );

  @override
  String toString() {
    return 'Contact{'
        'id: $id, '
        'image: $imagePath, '
        'name: $name, '
        'mobileNumber: $mobileNumber, '
        'isFavorite: $isFavorite, '
        'isBlacklist: $isBlacklist'
        '}';
  }
}
