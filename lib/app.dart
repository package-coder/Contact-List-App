
import 'package:contact_list_app/screens/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
    ModuleRoute('/', module: ScreenModule())
  ];
}


class AppWidget extends StatelessWidget {

  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Contact List App',
      theme: ThemeData(
        hoverColor: Colors.grey.shade100,
        buttonTheme: ButtonThemeData(
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
              const BorderSide(width: 0, style: BorderStyle.none)
          ),

        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  width: 1,
                  style: BorderStyle.solid,
                  color: Colors.grey.shade300
              )
          ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
            hintStyle: TextStyle(
                fontSize: Theme.of(context).textTheme.button?.fontSize,
                fontWeight: FontWeight.w500,
                color: Colors.black
            )
        ),
      ),
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
    );
  }
}