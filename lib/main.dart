
import 'package:myapp/page-1/details.dart';
import 'package:myapp/page-1/history.dart';
import 'package:myapp/page-1/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/page-1/add.dart';
import 'package:myapp/page-1/loginpage.dart';
import 'package:myapp/page-1/profile.dart';
import 'package:myapp/page-1/registerpage.dart';
import 'package:myapp/page-1/search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/page-1/splashscreen.dart';


void main()async{
	WidgetsFlutterBinding.ensureInitialized();
	await Firebase.initializeApp();

	runApp(MaterialApp(
		debugShowCheckedModeBanner: false,
		routes: {
			"/":(context) => Splash(),
			"/login":(context) => MyLogin(),
			"/register":(context) => MyRegister(),
			"/home":(context) => Home(),
			"/search":(context) => Search(),
			"/history":(context) => History(),
			"/profile":(context) => Profile(),
			"/add": (context) => Add(),
			"/details": (context) => Details(),
		},
	));
}

