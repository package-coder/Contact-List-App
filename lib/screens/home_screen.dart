

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Contact List App'),
        ),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
            itemCount: 50,
            itemBuilder:  (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(5),
                  onTap: () {},
                  leading:  IconButton(
                    onPressed: null,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    icon: Icon(Icons.person),
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.star_border),
                  ),
                  title: Text('Item $index'),
                ),
              );
            }
        ),
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        child: TabBar(
          indicatorWeight: 4,
          labelColor: Theme.of(context).primaryColor,
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 30),
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
              icon: Icon(Icons.brightness_5_sharp),
              iconMargin: EdgeInsets.only(bottom: 2),
            ),
          ],
        ),
      )
    );
  }
}