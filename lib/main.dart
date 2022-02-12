import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:powerofcompounding/model/compound_interest_provider.dart';
import 'package:powerofcompounding/model/home_provider.dart';
import 'package:powerofcompounding/screen/home.dart';
import 'package:powerofcompounding/screen/splash.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => CompoundInterestProvider()),
      ChangeNotifierProvider(create: (_) => SimpleInterestProvider()),
      ChangeNotifierProvider(create: (_) => HomeProvider()),
      ChangeNotifierProvider(create: (_) => CIANDSIProvider()),
      ChangeNotifierProvider(create: (_) => EMIProvider()),
    ], child: const TheTruthOfCompounding()),
  );
}

class TheTruthOfCompounding extends StatelessWidget {
  const TheTruthOfCompounding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Truth of Compounding',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: WidgetsBinding.instance!.window.platformBrightness,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        Home.routeName: (context) => const Home(),
      },
    );
  }
}
