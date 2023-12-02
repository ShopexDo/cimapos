import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart'; // Importa el paquete url_launcher
import 'package:cimapos/util/images.dart';
import 'package:cimapos/view/base/custom_app_bar.dart';
import 'package:cimapos/view/base/custom_category_button.dart';
import 'package:cimapos/view/base/custom_drawer.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width * 0.12;
    return Scaffold(
      appBar: CustomAppBar(isBackButtonExist: true),
      endDrawer: CustomDrawer(),
      body: ListView(
        children: [
          CustomCategoryButton(
            buttonText: 'privacy_policy'.tr,
            icon: Images.look,
            isSelected: false,
            isDrawer: false,
            padding: _width,
            onTap: () => launch('https://pos.cimapos.com.do/politica-de-privacidad'),
          ),
          CustomCategoryButton(
            buttonText: 'terms_and_conditions'.tr,
            icon: Images.brand,
            isSelected: false,
            padding: _width,
            isDrawer: false,
            onTap: () => launch('https://pos.cimapos.com.do/terminos-condiciones'),
          ),
        ],
      ),
    );
  }
}
