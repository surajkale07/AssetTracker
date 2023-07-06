
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/page-1/home.dart';
import 'package:myapp/page-1/loginpage.dart';



class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  User? user;

  @override
  void initState(){
    startTimer();
    super.initState();
    user=FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff1c1b1f),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Image.asset(
            "assets/page-1/images/opener-loading.gif",
            height:400.0,
            width: 400.0,
          ),
         Text("ASSET TRACKER",
          style: TextStyle( color: Colors.blueAccent, fontSize: 40, fontWeight: FontWeight.bold)
         ),
        ]
        ),
        // child:


      ),
      )
    );
  }

  startTimer() {
    var duration= Duration(seconds: 5);
    return Timer(duration, route);
  }

  route(){
    if (user != null){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Home()
      ));
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MyLogin()
      ));
    }

  }
}
