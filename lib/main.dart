import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/consts/theme_data.dart';
import 'package:mobile_app/fetch_screen.dart';
import 'package:mobile_app/firebase_options.dart';
import 'package:mobile_app/inner_screens/category_screen.dart';
import 'package:mobile_app/inner_screens/feed_screen.dart';
import 'package:mobile_app/inner_screens/feed_us_screen.dart';
import 'package:mobile_app/inner_screens/foodBowl_details_screen.dart';
import 'package:mobile_app/providers/dark_theme_provider.dart';
import 'package:mobile_app/providers/cart_prodivder.dart';
import 'package:mobile_app/providers/foodBowl_provider.dart';
import 'package:mobile_app/providers/orders_provider.dart';
import 'package:mobile_app/providers/transaction_provider.dart';
import 'package:mobile_app/screens/auth/forgot_passwprd.dart';
import 'package:mobile_app/screens/auth/login.dart';
import 'package:mobile_app/screens/auth/register.dart';
import 'package:mobile_app/screens/orders/order_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    // TODO: implement initState
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _firebaseInitialization =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Text('An Error Occured'),
                ),
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) {
                return themeChangeProvider;
              }),
              ChangeNotifierProvider(
                create: (_) => FoodBowlProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => CartProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => OrdersProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => TransactionProvider(),
              ),
            ],
            child: Consumer<DarkThemeProvider>(
                builder: (context, themeProvider, child) {
              return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Flutter Demo',
                  theme: Styles.themeData(themeProvider.getDarkTheme, context),
                  home: const FetchScreen(),
                  // home: const LoginScreen(),
                  routes: {
                    FeedUsScreen.routeName: (ctx) => const FeedUsScreen(),
                    FeedScreen.routeName: (ctx) => const FeedScreen(),
                    FoodBowlDetail.routeName: (ctx) => const FoodBowlDetail(),
                    OrderScreen.routeName: (ctx) => const OrderScreen(),
                    CategoryScreen.routeName: (ctx) => const CategoryScreen(),
                    LoginScreen.routeName: (ctx) => const LoginScreen(),
                    RegisterScreen.routeName: (ctx) => const RegisterScreen(),
                    ForgotPasswordScreen.routeName: (ctx) =>
                        const ForgotPasswordScreen(),
                  });
            }),
          );
        });
  }
}
