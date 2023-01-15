

import 'dart:io';
import 'dart:async';
import 'package:contact_list_app/models/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _refetch = false;
  final List<String> tabs = [
    '/contact-list-screen',
    '/block-list-screen',
    '/archive-list-screen'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    Modular.to.navigate(tabs[0]);
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Contact List App'),
        ),
      ),
      body: const RouterOutlet(),
      bottomNavigationBar: BottomAppBar(
        child: TabBar(
          onTap: (int tab) {
            Modular.to.navigate(tabs[tab]);
          },
          labelColor: Theme.of(context).primaryColor,
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.groups),
              iconMargin: EdgeInsets.only(bottom: 2),
              child: Text('Contacts'),
            ),
            Tab(
              icon: Icon(Icons.lock_person),
              iconMargin: EdgeInsets.only(bottom: 2),
              child: Text('Blocklist'),
            ),
            Tab(
              icon: Icon(Icons.archive),
              iconMargin: EdgeInsets.only(bottom: 2),
              child: Text('Archives'),
            ),
          ],
        ),
      )
    );
  }
}