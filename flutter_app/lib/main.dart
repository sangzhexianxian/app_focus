import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/splash_screen.dart';
import 'providers/goal_provider.dart';
import 'providers/user_provider.dart';
import 'providers/points_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Hive
  await Hive.initFlutter();
  await Hive.openBox('goals');
  await Hive.openBox('user');
  await Hive.openBox('points');

  // 初始化 Supabase
  await Supabase.initialize(
    url: 'https://klywwizwconvwjifzrcw.supabase.co',
    anonKey: 'sb_publishable_65tNpTMzDgY8PFEQxIS-Eg_0tXESrkV',
  );

  // 设置系统样式
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GoalProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PointsProvider()),
      ],
      child: MaterialApp(
        title: 'FOCUS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF667eea),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'CustomFont',
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
