import 'package:ctjan/screens/bottom_bar.dart';
import 'package:ctjan/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:ctjan/Helper/token_strings.dart';
import 'package:ctjan/responsive/mobile_screen_layout.dart';
import 'package:ctjan/screens/send_otp.dart';
import 'package:ctjan/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }


  String? userId;
  String? groupId;
  getUserData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(TokenString.userid);
    if(userId == null || userId == "") {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignInScreen()));
      });
    }else{
      if(groupId == "0"){
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) =>  SearchScreen()));
        });
      }else{
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) =>  BottomBar()));
        });
      }
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width/2,
          height: MediaQuery.of(context).size.height/2,
          child: Image.asset('assets/appicon.png'),
        ),
      ),
    );
  }
}
