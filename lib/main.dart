import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:saah/providers/recycling_idea_provider.dart';
import 'package:saah/providers/user_provider.dart';
import 'package:saah/screens/adm/adm_home_screen.dart';
import 'package:saah/screens/auth/auth_screen.dart';
import 'package:saah/screens/edit_product_screen.dart';
import 'package:saah/screens/auth/forget_password_screen.dart';
import 'package:saah/screens/notification_screen.dart';
import 'package:saah/screens/profile_screen.dart';
import 'package:saah/screens/tab_screen.dart';
import 'package:saah/utils/routes.dart';
import 'providers/product_provider.dart';
import 'screens/recycling_idea_screen.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  Map<int, Color> color = {
    50: const Color.fromRGBO(3, 192, 60, .1),
    100: const Color.fromRGBO(3, 192, 60, .2),
    200: const Color.fromRGBO(3, 192, 60, .3),
    300: const Color.fromRGBO(3, 192, 60, .4),
    400: const Color.fromRGBO(3, 192, 60, .5),
    500: const Color.fromRGBO(3, 192, 60, .6),
    600: const Color.fromRGBO(3, 192, 60, .7),
    700: const Color.fromRGBO(3, 192, 60, .8),
    800: const Color.fromRGBO(3, 192, 60, .9),
    900: const Color.fromRGBO(3, 192, 60, 1),
  };
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RecyclingIdeaProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: MaterialColor(0xFF95c5ab, color),
          inputDecorationTheme:
              const InputDecorationTheme(border: OutlineInputBorder()),
        ),
        initialRoute: Routes.authScreen,
        // initialRoute: Routes.authScreen,
        routes: {
          Routes.authScreen: (context) => const AuthScreen(),
          Routes.tabScreen: (context) => const TabScreen(),
          Routes.admHomeScreen: (context) => const AdmHomeScreen(),
          Routes.profileScreen: (context) => const ProfileScreen(),
          Routes.editProductScreen: (context) => EditProductScreen(),
          Routes.forgetPasswordScreen: (context) =>
              const ForgetPasswordScreen(),
          Routes.notificationScreen: (context) => const NotificationScreen(),
          Routes.recyclingIdeaScreen: (context) => const RecyclingIdeaScreen(),
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const AuthScreen(),
          );
        },
      ),
    );
  }
}
