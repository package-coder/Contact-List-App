

import 'dart:io';
import 'dart:async';
import 'package:contact_list_app/models/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ContactListScreenState();
}


class _ContactListScreenState extends State<ContactListScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> tabs = ['contacts', 'blocklist', 'archivelist'];
  List<Contact> _contactList = [];
  bool _loading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _refetchList();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _refetchList () {
    setState(() { _loading = true; });
    Contact.getContactList()
        .then((value) => setState(() { _contactList = value; }))
        .onError((error, stackTrace) => print('$error $stackTrace'))
        .whenComplete(() => setState(() { _loading = false; }));
  }

  void _handleSearch(String value) {
    setState(() { _loading = true; });

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      if(value == ''){
        _refetchList();
        return;
      }
      Contact.findByNameOrNumber(value)
          .then((value) => setState(() { _contactList = value; }))
          .onError((error, stackTrace) => print('$error $stackTrace'))
          .whenComplete(() => setState(() { _loading = false; }));
    });
  }

  void _handleAddToFavorite(int? id, Contact contact) {
    Contact.findIdAndUpdate(id, { 'isFavorite': contact.isFavorite ? 0 : 1 })
        .then((value) => {
      Contact.getContactList()
          .then((value) =>
          setState(() { _contactList = value; })
      ).onError((error, stackTrace) => print('$error $stackTrace'))
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Scrollbar(
        thumbVisibility: true,
        child:Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: TextFormField(
                validator: (value) {
                  if (!(value == null || value.isEmpty)) {
                    return null;
                  }
                  return 'This field is required';
                },
                onChanged: _handleSearch,
                keyboardType: TextInputType.name,
                decoration:  InputDecoration(
                    hintText: 'Search by name or phone number',
                    hintStyle: TextStyle(
                        fontSize: Theme.of(context).textTheme.button?.fontSize,
                        color: Colors.grey.shade400
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(24)),
                        borderSide: BorderSide(
                            width: 1,
                            style: BorderStyle.solid,
                            color: Colors.grey.shade300
                        )
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            style: BorderStyle.solid,
                            color: Colors.grey.shade300
                        )
                    )
                ),
              ),
            ),
            Expanded(
                child:  _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _contactList.isEmpty ? const Center(child: Text('No contacts'))
                    : ListView.builder(
                  itemCount: _contactList.length,
                  itemBuilder: (context, index) {
                    var contact = _contactList[index];
                    return ListTile(
                      onTap: () {},
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                      leading: contact.imagePath != ''
                          ? Container(
                        height: 50.0,
                        width: 50.0,
                        clipBehavior: Clip.hardEdge,
                        decoration:  const BoxDecoration(
                            shape: BoxShape.circle
                        ),
                        child: Image.file(
                          File(contact.imagePath),
                          fit: BoxFit.cover,
                        ),
                      )
                          : CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 25.0,
                        child: Text(contact.name[0].toUpperCase()),
                      ),
                      title: Text(contact.name),
                      subtitle: Text(contact.mobileNumber),
                      trailing: IconButton(
                          onPressed: () {
                            _handleAddToFavorite(contact.id, contact);
                          },
                          iconSize: 22,
                          tooltip: 'Mark as favorite',
                          icon: Icon(
                            contact.isFavorite
                                ? Icons.star
                                : Icons.star_border_outlined,
                            color: Colors.grey,
                          )
                      ),
                    );
                  },
                )
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Modular.to.pushNamed('/add-contact-screen')
          .then((value) => {
            if(value == true)
              _refetchList()
          })
          .onError((error, stackTrace) => { print('$error, $stackTrace') })
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}