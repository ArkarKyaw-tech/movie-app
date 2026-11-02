import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/controllers/actor_controller.dart';
import 'package:movie_app/controllers/movie_controller.dart';
import 'package:movie_app/controllers/tv_controller.dart';
import 'package:movie_app/services/tmdb_api_service.dart';
import 'package:movie_app/views/home_page.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (_) => TmdbApiService(),
          dispose: (_, service) => service.dispose(),
        ),
        ChangeNotifierProvider(
          create: (context) => MovieProvider(context.read<TmdbApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => TvProvider(context.read<TmdbApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ActorProvider(context.read<TmdbApiService>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0E1018),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9B6DFF),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}
