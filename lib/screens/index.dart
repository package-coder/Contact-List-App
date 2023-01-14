

import 'package:contact_list_app/models/contact_model.dart';
import 'package:contact_list_app/screens/add_contact_screen.dart';
import 'package:contact_list_app/screens/home_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ScreenModule extends Module {
  @override
  List<Bind> get binds => [
    AsyncBind((i) => Contact.getAll()),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute('/', child: (context, args) => const HomeScreen()),
    ChildRoute('/add-contact-screen', child: (context, args) => const AddContactScreen())
  ];
}