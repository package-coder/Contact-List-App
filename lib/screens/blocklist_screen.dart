

import 'dart:io';
import 'dart:async';
import 'package:contact_list_app/models/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class BlockListScreen extends StatefulWidget {
  const BlockListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _BlockListScreenState();
}


class _BlockListScreenState extends State<BlockListScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  List<Contact> _contactList = [];
  bool _loading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _refetchList();
  }


  void _refetchList () {
    setState(() { _loading = true; });
    Contact.filterAllBlocked()
        .then((value) => setState(() { _contactList = value; }))
        .onError((error, stackTrace) => print('$error $stackTrace'))
        .whenComplete(() => setState(() { _loading = false; }));
  }


  void _handleActionClick(int? id, Contact contact) {
    Contact.findIdAndUpdate(id, { 'isBlocked': contact.isBlocked ? 0 : 1 })
        .then((value) => {
      Contact.filterAllBlocked()
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
                      _handleActionClick(contact.id, contact);
                    },
                    iconSize: 22,
                    tooltip: 'Block',
                    icon: Icon(
                      contact.isBlocked
                          ? Icons.lock
                          : Icons.lock_open_outlined,
                      color: Colors.grey,
                    )
                ),
              );
            },
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