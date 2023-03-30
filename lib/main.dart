import 'package:ctjan/screens/bottom_bar.dart';
import 'package:ctjan/screens/search_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ctjan/Helper/token_strings.dart';
import 'package:ctjan/providers/user_provider.dart';
import 'package:ctjan/responsive/mobile_screen_layout.dart';
import 'package:ctjan/responsive/responsive_layout_screen.dart';
import 'package:ctjan/responsive/web_screen_layout.dart';
import 'package:ctjan/screens/login_screen.dart';
import 'package:ctjan/screens/send_otp.dart';
import 'package:ctjan/screens/splash_screen.dart';
import 'package:ctjan/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyACISFhU-IlwcyiHkpcz5BMgkOJy-a-flk",
        authDomain: "instagram-clone-5c122.firebaseapp.com",
        projectId: "instagram-clone-5c122",
        storageBucket: "instagram-clone-5c122.appspot.com",
        messagingSenderId: "392098016095",
        appId: "1:392098016095:web:0294782b5fce1d451f24ea",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    try {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserProvider(),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ctjan',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: mobileBackgroundColor,
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }
              return
                // SearchScreen();
                //BottomBar();
                SplashScreen();
              //   userId != null || userId != ''?
              //    const BottomBar()
              // : const SignInScreen();
              //LoginScreen();
            },
          ),
        ),
      );
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
