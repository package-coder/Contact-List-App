

import 'dart:io';
import 'dart:async';
import 'package:contact_list_app/models/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ArchiveListScreen extends StatefulWidget {
  const ArchiveListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ArchiveListScreenState();
}


class _ArchiveListScreenState extends State<ArchiveListScreen> with TickerProviderStateMixin {
  List<Contact> _contactList = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _refetchList();
  }


  void _refetchList () {
    setState(() { _loading = true; });
    Contact.filterAllArchived()
        .then((value) => setState(() { _contactList = value; }))
        .onError((error, stackTrace) => print('$error $stackTrace'))
        .whenComplete(() => setState(() { _loading = false; }));
  }


  void _handleActionClick(int? id, Contact contact) {
    Contact.findIdAndUpdate(id, { 'isArchived': contact.isArchived ? 0 : 1 })
        .then((value) => {
      Contact.filterAllArchived()
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
          child:  _loading
              ? const Center(child: CircularProgressIndicator())
              : _contactList.isEmpty ? const Center(child: Text('No contacts'))
              : Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _contactList.length,
              itemBuilder: (context, index) {
                var contact = _contactList[index];
                return Card(
                  child: ListTile(
                    onTap: () {
                      Modular.to.pushNamed('/contact-item-screen/${contact.id}')
                          .then((value) => {
                        if(value == true)
                          _refetchList()
                      })
                          .onError((error, stackTrace) => { print('$error, $stackTrace') });
                    },
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
                          _handleActionClick(contact.id, contact);
                        },
                        iconSize: 22,
                        tooltip: 'Archive',
                        icon: Icon(
                          contact.isArchived
                              ? Icons.archive
                              : Icons.archive_outlined,
                          color: Colors.grey,
                        )
                    ),
                  ),
                );
              },
            ),
          )
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