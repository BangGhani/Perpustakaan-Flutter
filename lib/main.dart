import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://gffxadxottaobdhggcqv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdmZnhhZHhvdHRhb2JkaGdnY3F2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE3MjY1NzUsImV4cCI6MjA0NzMwMjU3NX0.yb58Cr9Evwbc53KJyoSJ_LsbadvD1y0_pDK3e0wFvuM',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Digital Library',
      home: const BookListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}


