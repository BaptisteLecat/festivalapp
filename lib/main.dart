import 'dart:io';

import 'package:festivalapp/services/stripe/stripe_services.dart';
import 'package:flutter/material.dart';
import 'package:festivalapp/views/splash_screen_wrapper.dart';
import 'package:festivalapp/common/theme.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

///Development
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = StripeServices.publishKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.lecat';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  runApp(MyApp());

  ///dev
  HttpOverrides.global = MyHttpOverrides();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: UniqueKey(),
      title: 'FestivApp',
      home: const SplashScreenWrapper(),
      debugShowCheckedModeBanner: false,
      theme: basicTheme(),
    );
  }
}
