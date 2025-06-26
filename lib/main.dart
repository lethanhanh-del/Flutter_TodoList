import 'package:bai_ktr_lethanhanh/Provider/provider.dart';
import 'package:bai_ktr_lethanhanh/Screen/home.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'Notification_soucre/NotificationServiceManager.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await [
    Permission.notification,
    Permission.scheduleExactAlarm,
  ].request();

  await NotificationServiceManager().init();

  runApp(
    ChangeNotifierProvider(
        create: (_)=> provider()..loadToDoList(),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const home(),
    );
  }
}