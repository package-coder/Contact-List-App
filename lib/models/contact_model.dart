

import 'package:contact_list_app/config/DBHelper.dart';
import 'package:image_picker/image_picker.dart';

class Contact {
  final int? id;
  final String name;
  final String mobileNumber;
  final bool isFavorite;
  final bool isBlocked;
  final bool isArchived;
  final String imagePath;


  Contact({
    this.id,
    required this.imagePath,
    required this.name,
    required this.mobileNumber,
    this.isFavorite = false,
    this.isBlocked = false,
    this.isArchived = false,
  });

  static Future<List<Contact>> getContactList() async {
    var database = await DBHelper.instance.database;
    var contacts = await database.query(
        'contacts',
        where: 'isBlocked = ? AND isArchived = ?',
        whereArgs: [0, 0],
        orderBy: 'name, isFavorite'
    );

    List<Contact> contactList = contacts.isNotEmpty
        ? contacts.map((e) => Contact.fromMap(e)).toList()
        : [];

    List<Contact> favorites = contactList.where((element) => element.isFavorite).toList();
    contactList = contactList.where((element) => !element.isFavorite).toList();

    favorites.addAll(contactList);
    return favorites;
  }

  static Future<Contact?> getContactById(int id) async {
    var database = await DBHelper.instance.database;
    var contacts = await database.query(
        'contacts',
        where: 'id = ?',
        whereArgs: [id],
        orderBy: 'name'
    );

    Contact? contact = contacts.isNotEmpty
        ? Contact.fromMap(contacts.first)
        : null;

    return contact;
  }

  static Future<List<Contact>> filterAllBlocked() async {
    var database = await DBHelper.instance.database;
    var contacts = await database.query(
        'contacts',
        where: 'isBlocked = ? AND isArchived = ?',
        whereArgs: [1, 0],
        orderBy: 'name'
    );

    List<Contact> contactList = contacts.isNotEmpty
        ? contacts.reversed
        .map((e) => Contact.fromMap(e))
        .toList()
        : [];

    return contactList;
  }

  static Future<List<Contact>> filterAllArchived() async {
    var database = await DBHelper.instance.database;
    var contacts = await database.query(
        'contacts',
        where: 'isArchived = ?',
        whereArgs: [1]
    );

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
        whereArgs: ['$query%', '$query%'],
        orderBy: 'name'
    );

    List<Contact> contactList = contacts.isNotEmpty
        ? contacts.map((e) => Contact.fromMap(e))
        .toList()
        : [];
    return contactList;
  }

  static Future<List<Contact>> findByName(String query) async {
    var database = await DBHelper.instance.database;
    var contacts = await database.query(
        'contacts',
        where: 'name = ?',
        whereArgs: [query]
    );

    List<Contact> contactList = contacts.isNotEmpty
        ? contacts.map((e) => Contact.fromMap(e))
        .toList()
        : [];
    return contactList;
  }

  static Future<List<Contact>> findByNumber(String query) async {
    var database = await DBHelper.instance.database;
    var contacts = await database.query(
        'contacts',
        where: 'mobileNumber = ?',
        whereArgs: [query]
    );

    List<Contact> contactList = contacts.isNotEmpty
        ? contacts.map((e) => Contact.fromMap(e))
        .toList()
        : [];
    return contactList;
  }

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
      'isBlocked': isBlocked ? 1 : 0,
      'isArchived': isArchived ? 1 : 0
    };
  }

  factory Contact.fromMap(Map<String, dynamic> json) => Contact(
    id: json['id'],
    name: json['name'],
    imagePath: json['imagePath'],
    mobileNumber: json['mobileNumber'],
    isFavorite: json['isFavorite'] == 1,
    isBlocked: json['isBlocked'] == 1,
      isArchived: json['isArchived'] == 1,
  );

  @override
  String toString() {
    return 'Contact{'
        'id: $id, '
        'image: $imagePath, '
        'name: $name, '
        'mobileNumber: $mobileNumber, '
        'isFavorite: $isFavorite, '
        'isBlocked: $isBlocked, '
        'isArchived: $isArchived'
        '}';
  }
}
