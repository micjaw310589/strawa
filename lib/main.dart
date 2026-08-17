import 'package:flutter/material.dart';
import 'package:strawa/presentation/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://bcgwzrbupsbgfuritzzv.supabase.co',
    publishableKey: 'sb_publishable_-GsVxW_V01_VnAcjSsRaSQ_kJkkEJ4-',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Products',
      home: HomeScreen(),
    );
  }
}