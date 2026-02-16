import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:snip/home_page.dart';
import 'package:snip/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// un string aleatorio: wAJJjjF0PL5shqw2

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
  /*
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  if (supabaseUrl.isEmpty) {
    throw AssertionError('Falta la URL de Supabase');
  }
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
*/
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final SupabaseClient client = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: client.auth.currentSession != null ? HomePage() : LoginPage(),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.dark,
    );
  }
}
