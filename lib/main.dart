import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/consts/theme_data.dart';
import 'package:mobile_app/firebase_options.dart';
import 'package:mobile_app/inner_screens/category_screen.dart';
import 'package:mobile_app/inner_screens/feed_screen.dart';
import 'package:mobile_app/inner_screens/on_sale_screen.dart';
import 'package:mobile_app/inner_screens/product_details_screen.dart';
import 'package:mobile_app/provider/dark_theme_provider.dart';
import 'package:mobile_app/providers/cart_prodivder.dart';
import 'package:mobile_app/providers/products_provider.dart';
import 'package:mobile_app/providers/viewed_provider.dart';
import 'package:mobile_app/providers/wishlist_provider.dart';
import 'package:mobile_app/screens/auth/forgot_passwprd.dart';
import 'package:mobile_app/screens/auth/login.dart';
import 'package:mobile_app/screens/auth/register.dart';
import 'package:mobile_app/screens/bottom_bar.dart';
import 'package:mobile_app/screens/orders/order_screen.dart';
import 'package:mobile_app/screens/viewed/viewed_screen.dart';
import 'package:mobile_app/screens/wishlist/wishlist_screen.dart';
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
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            const MaterialApp(
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
                create: (_) => ProductsProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => CartProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => WishlistProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => ViewedProductProvider(),
              ),
            ],
            child: Consumer<DarkThemeProvider>(
                builder: (context, themeProvider, child) {
              return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Flutter Demo',
                  theme: Styles.themeData(themeProvider.getDarkTheme, context),
                  home: const BottomBarScreen(),
                  routes: {
                    OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
                    FeedScreen.routeName: (ctx) => const FeedScreen(),
                    ProductDetails.routeName: (ctx) => const ProductDetails(),
                    WishlistScreen.routeName: (ctx) => const WishlistScreen(),
                    OrderScreen.routeName: (ctx) => const OrderScreen(),
                    ViewedScreen.routeName: (ctx) => const ViewedScreen(),
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
