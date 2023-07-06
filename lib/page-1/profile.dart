import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/page-1/loginpage.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';





final FirebaseAuth _auth  = FirebaseAuth.instance;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  User? user = FirebaseAuth.instance.currentUser;

  String? name;
  String? valueText;
  Timestamp timestamp = Timestamp.now();
  late DateTime dateTime;
  late String issuedate;
  String? codeDialog;
  final TextEditingController empid= TextEditingController();
  final TextEditingController _complaint = TextEditingController();
  final TextEditingController _email =TextEditingController();

  Future<void> getuser() async {
    final _auth = FirebaseAuth.instance;
    dynamic user;
    String userEmail;
    // String userPhoneNumber;
    user = _auth.currentUser;
    userEmail = user.email;
    final CollectionReference collectionReference = FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot = await collectionReference.where('email', isEqualTo: userEmail).get();
    List<DocumentSnapshot> documents = querySnapshot.docs;
    for (int i = 0; i < documents.length; i++) {
      setState(() {
        name = documents[i].get('full_name'); // Assign the name to the variable
      });
    }print(userEmail);
    print(name);
  }

  @override
  void initState() {
    super.initState();
    getuser();
  }

  Future<void> _registerInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text( 'Complaint Box' ),
            content: Container(
                height: 100,
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          valueText = value;
                        });
                      },
                      controller: empid,
                      decoration:
                      const InputDecoration(hintText: "Enter Emp Id"),
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          valueText = value;
                        });
                      },
                      controller: _complaint,
                      decoration:
                      const InputDecoration(hintText: "Enter your complaint"),
                    ),
                  ],
                )
            ),


            actions: <Widget>[
              MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: const Text('Submit'),
                onPressed: () {
                  setState(() async {
                    codeDialog = valueText;

                    dateTime= DateTime.now();
                    issuedate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);


                    Map<String,dynamic> data={
                      "empid" : empid.text, "Complaint" :_complaint.text,
                      "issue_date" : issuedate
                    };
                    FirebaseFirestore.instance.collection("Complaints").add(data);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Complaint Register"),
                    ));
                  });
                },
              ),
            ],
          );
        });
  }




  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              // profileGnL (65:1580)
              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 253.13*fem, 0*fem),
              child: Text(
                'Profile',
                style: SafeGoogleFont (
                  'Anek Bangla',
                  fontSize: 20*ffem,
                  fontWeight: FontWeight.w700,
                  height: 1.865*ffem/fem,
                  color: Color(0xffffffff),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
      width: double.infinity,
      child: Container(
        // androidlarge8Fgt (65:1563)
        padding: EdgeInsets.only(top: 20),
        width: double.infinity,
        decoration: BoxDecoration (
          color: Color(0xff1c1b1f),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              // autogroupsrtjS2c (Do2tg4LqAvG2FU9dQjsrTJ)
              padding: EdgeInsets.fromLTRB(9*fem, 12*fem, 17.13*fem, 212*fem),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // ellipse209o9z (65:1649)
                    margin: EdgeInsets.fromLTRB(110*fem, 0*fem, 123.88*fem, 2*fem),
                    width: double.infinity,
                    height: 100*fem,
                    decoration: BoxDecoration (
                      borderRadius: BorderRadius.circular(50*fem),
                      image: DecorationImage (
                        fit: BoxFit.cover,
                        image: AssetImage (
                          'assets/page-1/images/ellipse-209-bg.png',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // autogroupelhvthE (Do2stFKq6XtZvQFBfUeLhv)
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 150.88*fem, 15*fem),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // settingscNL (65:1564)
                          margin: EdgeInsets.fromLTRB(0*fem, 14*fem, 68*fem, 0*fem),
                          child: Text(
                            'Settings',
                            style: SafeGoogleFont (
                              'Anek Bangla',
                              fontSize: 20*ffem,
                              fontWeight: FontWeight.w600,
                              height: 1.865*ffem/fem,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ),
                        Text(
                          name.toString(),
                          style: SafeGoogleFont (
                            'Anek Bangla',
                            fontSize: 20*ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.865*ffem/fem,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // autogroupygrue48 (Do2szVeRNx2mRN99uHYGrU)
                    margin: EdgeInsets.fromLTRB(6*fem, 0*fem, 201.88*fem, 9*fem),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // vectormPe (65:1667)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 11*fem, 1*fem),
                          width: 15*fem,
                          height: 15*fem,
                          child: Image.asset(
                            'assets/page-1/images/vector-Bfn.png',
                            width: 15*fem,
                            height: 15*fem,
                          ),
                        ),
                        InkWell(
                          onTap: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Forget Password'),
                            content: const Text('Enter the valid registered email address'),
                            actions: <Widget>[
                              TextFormField(
                                controller: _email,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "Email",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                validator: (value){
                                  if(value!.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value!)){
                                    return "Enter correct email Address";
                                  }else {
                                    return null;
                                  }
                                },
                              ),
                              TextButton(
                                onPressed: () {
                                  final check = _auth
                                      .sendPasswordResetEmail(
                                      email: _email.text);
                                  if(check != null) {
                                    Navigator.of(context).pushReplacementNamed("/profile");
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          "Check your Email inbox"),
                                    ));
                                  }
                                  else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          "Enter Email address"),
                                    ));
                                  }
                                },
                                child: const Text('Send'),
                              ),
                            ],
                          ),
                        ),
                            child: Text(
                              // resetpassword59S (65:1651)
                              'Reset Password',
                              style: SafeGoogleFont (
                                'Anek Bangla',
                                fontSize: 15*ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.865*ffem/fem,
                                color: Color(0xffffffff),
                              ),
                        )

                        ),
                      ],
                    ),
                  ),
                  Container(
                    // autogroupqcfsCE4 (Do2t5zVG7EdpacXgqCQcfS)
                    margin: EdgeInsets.fromLTRB(7*fem, 0*fem, 182.88*fem, 77*fem),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // mdipaperalertiTJ (65:1668)
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 10*fem, 1*fem),
                          width: 15*fem,
                          height: 15*fem,
                          child: Image.asset(
                            'assets/page-1/images/mdi-paper-alert.png',
                            width: 15*fem,
                            height: 15*fem,
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            _registerInputDialog(context);
                          },
                        child: Text(
                          // registercomplaintbX6 (65:1652)
                          'Register Complaint',
                          style: SafeGoogleFont (
                            'Anek Bangla',
                            fontSize: 15*ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.865*ffem/fem,
                            color: Color(0xffffffff),
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // group13JwJ (65:1655)
                    margin: EdgeInsets.fromLTRB(100*fem, 0*fem, 111.88*fem, 0*fem),
                    width: double.infinity,
                    height: 33*fem,
                    decoration: BoxDecoration (
                      borderRadius: BorderRadius.circular(50*fem),
                    ),
                    child: Container(
                      // extendedEKA (65:1656)
                      padding: EdgeInsets.fromLTRB(17*fem, 8.5*fem, 22*fem, 8.5*fem),
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration (
                        color: Color(0xff690005),
                        borderRadius: BorderRadius.circular(50*fem),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x33000000),
                            offset: Offset(0*fem, 2*fem),
                            blurRadius: 2*fem,
                          ),
                          BoxShadow(
                            color: Color(0x1e000000),
                            offset: Offset(0*fem, 1*fem),
                            blurRadius: 5*fem,
                          ),
                          BoxShadow(
                            color: Color(0x23000000),
                            offset: Offset(0*fem, 4*fem),
                            blurRadius: 2.5*fem,
                          ),
                        ],
                      ),
                      child: Container(
                        // buttonEiU (I65:1656;242:7198)
                        width: double.infinity,
                        height: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                              Container(
                              // autogroupj31zyAG (Do2u2YkgyobxD2gtWbJ31z)
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 10*fem, 0*fem),
                              width: 17*fem,
                              height: 15*fem,
                              child: Image.asset(
                                'assets/page-1/images/auto-group-j31z.png',
                                width: 17*fem,
                                height: 15*fem,
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => MyLogin()
                                ));
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Logged Out Successfully"),
                                ));
                              },
                            child: Text(
                              // labelT5S (I65:1656;242:7201)
                              'LOGOUT',
                              style: SafeGoogleFont (
                                'Anek Bangla',
                                fontSize: 14*ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.1428571429*ffem/fem,
                                letterSpacing: 1.25*fem,
                                color: Color(0xffffb4ab),
                              ),
                            )
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
          ),
      // floatingActionButton:FloatingActionButton( //Floating action button on Scaffold
      //   onPressed: (){
      //     //code to execute on button press
      //     Navigator.of(context).pushReplacementNamed("/add");
      //   },
      //
      //   child: Icon(Icons.add), //icon inside button
      // ),

      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      //floating action button position to center

      bottomNavigationBar: BottomAppBar( //bottom navigation bar on scaffold
        color: Color(0xff48454e),
        shape: CircularNotchedRectangle(), //shape of notch
        notchMargin: 5, //notche margin between floating button and bottom appbar
        child: Row( //children inside bottom appbar
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(icon: Icon(Icons.home, color:  Colors.white,), onPressed: () {
              Navigator.of(context).pushReplacementNamed("/home");
            },),
            // IconButton(icon: Icon(Icons.search, color: Colors.white,), onPressed: () {
            //   Navigator.of(context).pushReplacementNamed("/search");
            // },),
            IconButton(icon: Icon(Icons.history, color: Colors.white,), onPressed: () {
              Navigator.of(context).pushReplacementNamed("/history");
            },),
            IconButton(icon: Icon(Icons.people, color:  Color(0xff386bf6),), onPressed: () {
              Navigator.of(context).pushReplacementNamed("/profile");
            },),
          ],
        ),
      ),
    );
  }
}