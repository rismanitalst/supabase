import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = 'https://papparmdxhqsixlnchne.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBhcHBhcm1keGhxc2l4bG5jaG5lIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU5Nzk4NDAsImV4cCI6MjA4MTU1NTg0MH0.c1R03rwru29bEbdFv0r4eNQv18vxlLnJ3IEzIyKI4aY';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: Text('Hello Supabase')),
      ),
    );
  }
}
