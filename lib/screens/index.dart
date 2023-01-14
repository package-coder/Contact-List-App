

import 'package:contact_list_app/screens/home_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ScreenModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
    ChildRoute('/', child: (context, args) => const HomeScreen())
  ];
}