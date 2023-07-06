import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_excel/excel.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
// import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';




class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  Future<void> deleteOutdatedData() async {
    final collectionRef = FirebaseFirestore.instance.collection('OnRemoveScanner');
    final oneMonthAgo = DateTime.now().subtract(Duration(days: 30));
    final formateddate =  DateFormat('yyyy-MM-dd HH:mm:ss').format(oneMonthAgo);
    // final oneMonthAgo= '2023-05-20 09:33:55';
    final querySnapshot =
    await collectionRef.where('returndate', isLessThan: formateddate).get();

    final batch = FirebaseFirestore.instance.batch();
    querySnapshot.docs.forEach((doc) {
      batch.delete(doc.reference);
    });
    // if (kDebugMode) {
    //   print(formateddate);
    //   print(querySnapshot.docs.length);
    // }

    await batch.commit();
  }

  @override
  void initState() {
    super.initState();
    // startReminderTimer();
    deleteOutdatedData();
  }

  Future<List<Map<String, dynamic>>> getFirestoreData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('OnRemoveScanner').get();
    return querySnapshot.docs.map<Map<String, dynamic>>((doc) => doc.data() as Map<String, dynamic>).toList();
  }
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
  }
  void _generateCsvFile() async {
    PermissionStatus status = await Permission.storage.request();
    if (status != PermissionStatus.granted) {
      // Handle permission denied
      return;
    }
    List<Map<String, dynamic>> firestoreData = await getFirestoreData();
    // Create the table headers
    List<String> headers = ['Device Type','Serialno.', 'Employee ID','Employee Name','Issued Date (YYYY-MM-DD HH:MM:SS)','Return Date (YYYY-MM-DD HH:MM:SS)','Time Duration(HH:MM:SS)'];
    List<List<String>> data = [headers];
    // Add Firestore data to the table
    for (var doc in firestoreData) {

      String devie_type = doc['devie_type'];
      String serialno = doc['serialno'];
      String empid = doc['empid'];
      String empname = doc['empname'];
      DateTime issueDate = DateTime.parse(doc['issue_date']);
      DateTime returnDate = DateTime.parse(doc['returndate']);
      String issue_date = DateFormat('yyyy-MM-dd HH:mm:ss').format(issueDate);
      String returndate = DateFormat('yyyy-MM-dd HH:mm:ss').format(returnDate);

      Duration difference = returnDate.difference(issueDate);
      String differenceFormatted = formatDuration(difference);

      List<String> rowData = [devie_type,serialno, empid,empname,issue_date,returndate,differenceFormatted];
      data.add(rowData);
    }

    String csv = const ListToCsvConverter().convert(data);

    Directory? directory = await getExternalStorageDirectory();
    if (directory != null) {
      String filePath = '${directory.path}/ASSET_HISTORY.csv';
      File file = File(filePath);
      await file.writeAsString(csv);
      print(filePath);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Report Generated"),
      ));
      await OpenFile.open(filePath);

    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;


    return Scaffold(
        appBar: AppBar(
          title: Text('History'),
        ),
        body: Container(
          width: double.infinity,
          child: Container(
            // androidlarge25rG (7:2002)
            width: double.infinity,
            height: 800*fem,
            decoration: BoxDecoration (
              color: Color(0xff1c1b1f),
            ),
            child: Stack(
              children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('OnRemoveScanner').orderBy('returndate', descending: true).snapshots(),
                        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(

                            );
                          }
                          final userSnapshot = snapshot.data?.docs;
                          if (userSnapshot!.isEmpty) {
                            return Text(
                              'This device is not received yet',
                              style: SafeGoogleFont (
                                'Anek Bangla',
                                fontSize: 10*ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.865*ffem/fem,
                                color: Color(0xffffffff),
                              ),
                            );      }
                          return ListView.builder(
                            padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                            itemCount: userSnapshot.length,
                            itemBuilder: (context, index){
                              QueryDocumentSnapshot document = userSnapshot[index];
                              return Container(
                                // group63vQ (7:1943)
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 13*fem),
                                padding: EdgeInsets.fromLTRB(20*fem, 11*fem, 24*fem, 14*fem),
                                width: double.infinity,
                                height: 170*fem,
                                decoration: BoxDecoration (
                                  color: Color(0xff48454e),
                                  borderRadius: BorderRadius.circular(15*fem),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x3f000000),
                                      offset: Offset(0*fem, 1*fem),
                                      blurRadius: 3*fem,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      // rectangle37579a (7:1933)
                                      margin: EdgeInsets.fromLTRB(0*fem, 2*fem, 27*fem, 0*fem),
                                      width: 80*fem,
                                      height: 130*fem,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5*fem),
                                        child: Image.asset(
                                          'assets/page-1/images/scanner.jpeg',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // autogrouphvpszz4 (Do2k8dufHUwf9qd2NMHvPS)
                                      width: 187*fem,
                                      height: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            // autogrouprt8u9MA (Do2kFDZ2hjYb2TJJJLRT8U)
                                            margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 74*fem, 0*fem),
                                            width: double.infinity,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  // ellipse207snx (7:1937)
                                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 9*fem, 0*fem),
                                                  width: 10*fem,
                                                  height: 10*fem,
                                                  decoration: BoxDecoration (
                                                    borderRadius: BorderRadius.circular(5*fem),
                                                    border: Border.all(color: Color(0xff000000)),
                                                    color: Color(0xffff0000),
                                                  ),
                                                ),
                                                Text(
                                                  // scanner211387CKS (7:1934)
                                                  document['serialno'],
                                                  style: SafeGoogleFont (
                                                    'Anek Bangla',
                                                    fontSize: 15*ffem,
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.865*ffem/fem,
                                                    color: Color(0xffc9c5d0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            // autogroupxpxvK9A (Do2kM3ieZrcNZMU8vRXPXv)
                                            margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 0*fem, 7*fem),
                                            width: double.infinity,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  // siteuseddvY (7:1935)
                                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 64*fem, 0*fem),
                                                  child: Text(
                                                    'Issued To: '+document['empid'],
                                                    style: SafeGoogleFont (
                                                      'Anek Bangla',
                                                      fontSize: 13*ffem,
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.865*ffem/fem,
                                                      color: Color(0xffc9c5d0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            // autogroupxpxvK9A (Do2kM3ieZrcNZMU8vRXPXv)
                                            margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 0*fem, 7*fem),
                                            width: double.infinity,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  // siteuseddvY (7:1935)
                                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 64*fem, 0*fem),
                                                  child: Text(
                                                    'Site Used: '+document['sitename'],
                                                    style: SafeGoogleFont (
                                                      'Anek Bangla',
                                                      fontSize: 13*ffem,
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.865*ffem/fem,
                                                      color: Color(0xffc9c5d0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            // autogroupxpxvK9A (Do2kM3ieZrcNZMU8vRXPXv)
                                            margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 0*fem, 7*fem),
                                            width: double.infinity,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  // issuedateLKA (7:1936)

                                                  'Issued Date: '+ document['issue_date'],
                                                  style: SafeGoogleFont (
                                                    'Anek Bangla',
                                                    fontSize: 13*ffem,
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.865*ffem/fem,
                                                    color: Color(0xffc9c5d0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            // autogroupxpxvK9A (Do2kM3ieZrcNZMU8vRXPXv)
                                            margin: EdgeInsets.fromLTRB(1*fem, 0*fem, 0*fem, 7*fem),
                                            width: double.infinity,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  // issuedateLKA (7:1936)

                                                  'Return Date: '+ document['returndate'],
                                                  style: SafeGoogleFont (
                                                    'Anek Bangla',
                                                    fontSize: 13*ffem,
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.865*ffem/fem,
                                                    color: Color(0xffc9c5d0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                    ),
              ],
            ),
          ),
        ),
          floatingActionButton:FloatingActionButton( //Floating action button on Scaffold
              onPressed: () async {
                _generateCsvFile();
              },

              child: Icon(Icons.file_copy), //icon inside button
            ),

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
              IconButton(icon: Icon(Icons.history, color: Color(0xff386bf6),), onPressed: () {
                Navigator.of(context).pushReplacementNamed("/history");
              },),
              IconButton(icon: Icon(Icons.people, color: Colors.white,), onPressed: () {
                Navigator.of(context).pushReplacementNamed("/profile");
              },),
            ],
          ),
        ),
      );
  }
}
