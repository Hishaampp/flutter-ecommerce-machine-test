

import 'package:codeedex_flutter_test/modules/auth/auth_controller.dart';
import 'package:codeedex_flutter_test/modules/auth/login_screen.dart';
import 'package:codeedex_flutter_test/modules/home/home_controller.dart';
import 'package:codeedex_flutter_test/modules/home/home_screen.dart';
import 'package:codeedex_flutter_test/modules/products/product_controller.dart';
import 'package:codeedex_flutter_test/modules/products/product_screen.dart';
import 'package:codeedex_flutter_test/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Shop App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
        ),
        GetPage(
          name: '/home',
          page: () => const HomeScreen(),
          binding: BindingsBuilder(() {
            Get.put(HomeController());
          }),
        ),
        GetPage(
          name: '/products',
          page: () => const ProductsScreen(),
          binding: BindingsBuilder(() {
            Get.put(ProductsController());
          }),
        ),
      ],
    );
  }
}