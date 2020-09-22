import 'package:firebase_auth/firebase_auth.dart' as _auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutix/locale/my_localization.dart';
import 'package:flutix/locale/my_localization_delegate.dart';
import 'package:flutix/models/user.dart';
import 'package:flutix/provider_localization.dart';
import 'package:flutix/provider_user.dart';
import 'package:flutix/services/auth_services.dart';
import 'package:flutix/ui/pages/home.dart';
import 'package:flutix/ui/pages/profile.dart';
import 'package:flutix/ui/pages/topup.dart';
import 'package:flutix/ui/pages/wallet.dart';
import 'package:flutix/ui/widgets/preference_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'ui/pages/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  final MyLocalizationDelegate _myLocalizationDelegate = MyLocalizationDelegate(Locale('en', 'US'));
  
  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProviderLocalization()),
        ChangeNotifierProvider(create: (context) => ProviderUser()),
        Provider<_auth.FirebaseAuth>(create: (_) => _auth.FirebaseAuth.instance)
      ],
      child: Consumer<ProviderLocalization>(
        builder: (context, localization, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              _myLocalizationDelegate,
            ],
            supportedLocales: [
              const Locale('en', 'US'),
              const Locale('id', 'ID'),
            ],
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
            ),
            home: LandingPage(), // use stateless widget make hot reload refresh the home screen
            routes: <String, WidgetBuilder> {
              '/splash': (BuildContext context) => SplashScreen(),
              '/movie': (BuildContext context) => HomeScreen(tabIndex: 0),
              '/favorite': (BuildContext context) => HomeScreen(tabIndex: 1),
              '/ticket': (BuildContext context) => HomeScreen(tabIndex: 3),
              '/account': (BuildContext context) => HomeScreen(tabIndex: 4),
              '/wallet': (BuildContext context) => WalletScreen(),
              '/top-up': (BuildContext context) => TopUpScreen(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == '/profile') {
                final User user = settings.arguments;
                return MaterialPageRoute(
                  builder: (context) {
                    return ProfileScreen(user);
                  },
                );
              }
              return null;
            }
          );
        }
      ),
    );
    
    /*
    return ChangeNotifierProvider(
      create: (context) => ProviderLocalization(),
      child: Consumer<ProviderLocalization>(
        builder: (context, localization, child) {
          return ChangeNotifierProvider(
            create: (context) => ProviderUser(),
            child: Consumer<ProviderUser>(
              builder: (context, user, child) {
                return Provider<FirebaseAuth>(
                  create: (_) => FirebaseAuth.instance,
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    localizationsDelegates: [
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                      _myLocalizationDelegate,
                    ],
                    supportedLocales: [
                      const Locale('en', 'US'),
                      const Locale('id', 'ID'),
                    ],
                    home: LandingPage(),
                  )
                );
              }
            )
          );
          
        },
      ),
    );
    */
    
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.wait([SharedPreferencesBuilder.getData('language', 'en'), SharedPreferencesBuilder.getData('countryCode', 'US')]).then((value) {
      String lang = value[0] ?? 'en';
      String code = value[1] ?? 'US';
      MyLocalization.load(Locale(lang, code));
    });
    final firebaseAuth = Provider.of<_auth.FirebaseAuth>(context);
    return StreamBuilder<_auth.User>(
      stream: firebaseAuth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          _auth.User user = snapshot.data;
          if (user == null) {
            return SplashScreen();
          }
          return HomeScreen();
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/logo.png"))
                ),
              ),
            )
          );
        }
      },
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppWrapperState();
  }
}

class _AppWrapperState extends State<MyApp> {
  bool initApp = false;
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    if (!initApp) {
      Future.wait([SharedPreferencesBuilder.getData('language', 'en'), SharedPreferencesBuilder.getData('countryCode', 'US')]).then((value) {
        String lang = value[0] ?? 'en';
        String code = value[1] ?? 'US';
        MyLocalization.load(Locale(lang, code));
      });
      AuthServices.isUserLoggedIn()
        .then((result) {
          new Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              initApp = true;
              isLoggedIn = result;
            });
          });
        });
    }

    return initApp 
      ? (isLoggedIn ? HomeScreen() : SplashScreen())
      : _buildStartUpView(); 
  }

  Widget _buildStartUpView() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/logo.png"))
          ),
        ),
      )
    );
  }
  
}
