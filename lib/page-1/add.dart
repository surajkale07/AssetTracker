

import 'dart:io';

import 'package:firebase_picture_uploader/firebase_picture_uploader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart' as picker;
import 'package:firebase_storage/firebase_storage.dart';

class Add extends StatefulWidget {
  // const Add({Key? key}) : super(key: key);



  @override
  State<Add> createState() => _AddState();


}
class _AddState extends State<Add> {
  String dropdownvalue = 'Item 1';

  TextEditingController devicetype =new TextEditingController();
  TextEditingController serial =new TextEditingController();
  TextEditingController company =new TextEditingController();
  TextEditingController invoice =new TextEditingController();
  TextEditingController calibration =new TextEditingController();
  TextEditingController duedate =new TextEditingController();
  bool showTextFormField = false;

  var selectedtype ;
  final GlobalKey<FormState> _formkeyvalue =new GlobalKey<FormState>();
  List <String> _devicetype = <String>[
    "Scanner",
    "Tripod",
    "SdCard",
    "Battery"
  ];

  late File _image;



  // Future<void> _pickImage() async {
  //   File pickedImage = (await ImagePicker().pickImage(source: ImageSource.gallery)) as File;
  //   setState(() {
  //     _image = File(pickedImage!.path);
  //   });
  // }


  void _pickImage()async{
    // final pickedFile = await
    // File image;
    // if (pickedFile != null) {
    //   image = File(pickedFile.path);
    // } else {
    //   print('No image selected.');
    // }
  }


  List<UploadJob>? _profilePictures = [];
  void profilePictureCallback(
      {List<UploadJob>? uploadJobs, bool? pictureUploadProcessing}) {
    _profilePictures = uploadJobs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //       // image: AssetImage('assets/images/register.png'), fit: BoxFit.cover),
      // ),
      child: Scaffold(
        backgroundColor: Color(0xff1c1b1f),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35, top: 15),
              child: Text(
                'Add\nDevice',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28),
                child: Form(
                  // key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [

                            DropdownButton(
                                items: _devicetype.map((value) => DropdownMenuItem(
                                    child: Text(
                                      value,
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                value: value,
                                )).toList(),
                                onChanged: (selectedDevicetype){
                                  print('$selectedDevicetype');
                                  setState(() {
                                    selectedtype= selectedDevicetype;
                                    showTextFormField = selectedDevicetype == 'Scanner'; // set visibility based on selected option
                                  });
                                  },
                              value: selectedtype,
                              hint: Text('Choose Devide Type',
                              style: TextStyle(color: Colors.white),

                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: serial,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Serial No. ",
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Enter Serial No.";
                                }else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              // controller: _email,
                              controller: company,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Company / Brand",
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Enter Company / Brand";
                                }else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: invoice,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Invoice Date (DD/MM/YYYY)",
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Enter Invoice Date";
                                }else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Visibility(
                              visible: showTextFormField,

                              child:TextFormField(
                              // controller: _password,
                              controller: calibration,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Calibration Date (DD/MM/YYYY)",
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Enter Calibration Date";
                                }else {
                                  return null;
                                }
                              },
                            ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Visibility(
                                visible: showTextFormField,

                               child:TextFormField(
                              controller: duedate,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Calibration Due Date (DD/MM/YYYY) ",
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Enter Calibration Due Date";
                                }else {
                                  return null;
                                }
                              },
                            ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            // PictureUploadWidget(
                            //   onPicturesChange: profilePictureCallback,
                            //   initialImages: _profilePictures,
                            //   // settings: PictureUploadSettings(onErrorFunction: onErrorCallback),
                            //   buttonStyle: PictureUploadButtonStyle(),
                            //   buttonText: 'Upload Picture',
                            //   enabled: true,
                            // ),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'SUBMIT',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 27,
                                      fontWeight: FontWeight.w700),
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Color(0xff4c505b),
                                  child: IconButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        // _pickImage();
                                        Map<String,dynamic> data={"devie_type" :selectedtype, "serialno" :serial.text, "company" :company.text,
                                          "invoice" :invoice.text, "calibration" :calibration.text, "calibration_duedate" :duedate.text};
                                        FirebaseFirestore.instance.collection(selectedtype).add(data);
                                        Navigator.of(context).pushReplacementNamed("/home");
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text("Device added Successful"),
                                        ));
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward,
                                      )),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'BACK TO HOME ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 27,
                                      fontWeight: FontWeight.w700),
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Color(0xff4c505b),
                                  child: IconButton(
                                      color: Colors.white,
                                      onPressed: () async{
                                        Navigator.of(context).pushReplacementNamed("/home");
                                      },
                                      icon: Icon(
                                        Icons.arrow_back,
                                      )),

                                )
                              ],
                            ),

                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}