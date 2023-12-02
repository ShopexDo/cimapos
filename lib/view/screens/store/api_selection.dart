import 'package:flutter/material.dart';
import 'package:cimapos/util/app_constants.dart';
import 'package:cimapos/view/screens/dashboard/nav_bar_screen.dart';
import 'package:get/get.dart';
import 'package:cimapos/controller/splash_controller.dart';
import 'dart:async';

class ApiSelectionScreen extends StatelessWidget {
  final List<dynamic> apis;

  ApiSelectionScreen({Key key, @required this.apis}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Sucursal'),
        backgroundColor: Color(0xFF286FC6),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: apis.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: Icon(Icons.store),
              title: Text(apis[index]['description']),
              subtitle: Text(apis[index]['api']),
              onTap: () {
                _updateApiSelection(apis[index]['api'], context);
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _updateApiSelection(String selectedApi, BuildContext context) async {
    // Lógica para guardar la API seleccionada para el usuario actual.
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString('keyBaseUrl', selectedApi);
    // AppConstants.updateBaseUrl(selectedApi);
    AppConstants.updateBaseUrl(selectedApi);

    Get.find<SplashController>().getConfigData(selectedApi).then((value) {
      Timer(Duration(seconds: 1), () async {
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => NavBarScreen()));
        Get.to(() => NavBarScreen());
      });
    });
    
    
    // Redirige a la pantalla principal de la aplicación, o cualquier pantalla que desees mostrar después de la selección.
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => YourMainScreen()), // Reemplaza YourMainScreen con el nombre de tu pantalla principal.
    // );
  }
}
