import 'package:flutter/material.dart';
import 'package:nasa_api_app/presentation/asteroid_list_screen.dart';
import 'package:nasa_api_app/providers/asteroid_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AsteroidProvider()),
      ],
      child: MaterialApp(
        title: 'Nasa Data App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AsteroidListScreen(title: 'Asteroid List'),
      ),
    );
  }
}
