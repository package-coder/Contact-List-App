

import 'package:contact_list_app/models/contact_model.dart';
import 'package:contact_list_app/screens/add_contact_screen.dart';
import 'package:contact_list_app/screens/blacklist_screen.dart';
import 'package:contact_list_app/screens/contactlist_screen.dart';
import 'package:contact_list_app/screens/home_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ScreenModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
    ChildRoute('/', child: (context, args) => const HomeScreen(), children: [
      ChildRoute('/contact-list-screen', child: (context, args) => const ContactListScreen()),
      ChildRoute('/block-list-screen', child: (context, args) => const BlockListScreen()),
    ]),
    ChildRoute('/add-contact-screen', child: (context, args) => const AddContactScreen())
  ];
}