import 'package:flutter/material.dart';

import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'package:get_storage/get_storage.dart';

import 'package:smart_chat_bot/views/chat_view.dart';



void main() async {

// مطمئن شدن از این که بایندیگ‌های فلاتر لود شده‌اند

  WidgetsFlutterBinding.ensureInitialized();



// راه‌اندازی حافظه محلی روی دستگاه

  await GetStorage.init();



  runApp(

    GetMaterialApp(

      debugShowCheckedModeBanner: false,

      textDirection: TextDirection.rtl, // راست‌چین برای زبان فارسی

      home: ChatView(),

    ),

  );

}

