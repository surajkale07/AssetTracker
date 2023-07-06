import 'dart:async';
import 'dart:ui';
import 'dart:ui';
// import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/page-1/search.dart';
import 'package:myapp/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:math' as math;

import 'package:timezone/src/date_time.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

enum SortBy { InvoiceDate, CalibrationDate, CalibrationDueDate }

class _HomeState extends State<Home> {
  SortBy selectedSortBy = SortBy.InvoiceDate;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? codeDialog;
  String? valueText;
  late String company,
      devicetype,
      serialno,
      invoice,
      calibration,
      duedate,
      empid,
      empname,
      sitename,
      issuedate,
      returndate,
      jobno,
      name,
      serial,
      selectedtype;
  Timestamp timestamp = Timestamp.now();
  late DateTime dateTime;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController Empid = TextEditingController();
  final TextEditingController _sitename = TextEditingController();
  final TextEditingController Jobno = TextEditingController();
  final TextEditingController Name = TextEditingController();
  DateTime selectedDate = DateTime.now();

  Future<void> scannerremovebtn(serial) async {
    dateTime = DateTime.now();
    returndate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('OnUseScanner');
    QuerySnapshot querySnapshot =
        await collectionReference.where('serialno', isEqualTo: serial).get();
    List<DocumentSnapshot> documents = querySnapshot.docs;
    for (int i = 0; i < documents.length; i++) {
      devicetype = documents[i].get('devie_type');
      company = documents[i].get('company');
      serialno = documents[i].get('serialno');
      invoice = documents[i].get('invoice');
      calibration = documents[i].get('calibration');
      duedate = documents[i].get('calibration_duedate');
      empid = documents[i].get('empid');
      sitename = documents[i].get('sitename');
      issuedate = documents[i].get('issue_date');
      jobno = documents[i].get('jobno');
      name = documents[i].get('empname');
    }
    Map<String, dynamic> data = {
      "devie_type": devicetype,
      "serialno": serialno,
      "company": company,
      "invoice": invoice,
      "calibration": calibration,
      "calibration_duedate": duedate,
      "empid": empid,
      "sitename": sitename,
      "issue_date": issuedate,
      "returndate": returndate,
      "jobno": jobno,
      "empname": name
    };
    FirebaseFirestore.instance.collection("OnRemoveScanner").add(data);

    Query query = collectionReference.where('serialno', isEqualTo: serial);
    query.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference
            .delete()
            .then((value) => print('Document deleted'))
            .catchError((error) => print('Error deleting document: $error'));
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Device Received"),
    ));
  }

  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    // startReminderTimer();
    // checkEndDateAndAlert();
    initializeSharedPreferences();
  }

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    checkIfDueDateCheckNeeded();
  }

  Future<void> checkIfDueDateCheckNeeded() async {
    final lastExecutionTimeMillis =
        prefs?.getInt('lastExecutionTimeMillis') ?? 0;
    final lastExecutionTime =
        DateTime.fromMillisecondsSinceEpoch(lastExecutionTimeMillis);
    final currentDate = DateTime.now();
    final lastExecutionDate = DateTime(
        lastExecutionTime.year, lastExecutionTime.month, lastExecutionTime.day);
    final currentDateWithoutTime =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    if (currentDateWithoutTime.isAfter(lastExecutionDate)) {
      await checkDueDates();
      await prefs?.setInt(
          'lastExecutionTimeMillis', currentDate.millisecondsSinceEpoch);
    }
  }

  Future<void> checkDueDates() async {
    final oneMonthAgo = DateTime.now().subtract(Duration(days: 30));
    final formateddate = DateFormat('yyyy-MM-dd HH:mm:ss').format(oneMonthAgo);

    final querySnapshot = await FirebaseFirestore.instance
        .collection('Scanner')
        .where('calibration_duedate', isGreaterThan: formateddate)
        .get();
    if (kDebugMode) {
      print(oneMonthAgo);
      print(formateddate);
      print(querySnapshot.docs.length);
    }

    if (querySnapshot.docs.isNotEmpty) {
      String message =
          'Your scanner calibration due date is within one month. Serial numbers: \n';

      for (var doc in querySnapshot.docs) {
        final serialNo = doc['serialno'];
        message += '$serialNo\n';
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Reminder'),
            content: Text(message),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> Showdetails(BuildContext context, serialno) async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('OnUseScanner');
    QuerySnapshot querySnapshot =
        await collectionReference.where('serialno', isEqualTo: serialno).get();
    List<DocumentSnapshot> documents = querySnapshot.docs;
    for (int i = 0; i < documents.length; i++) {
      empid = documents[i].get('empid');
      empname = documents[i].get('empname');
      sitename = documents[i].get('sitename');
      // Map<String, dynamic> data = documents[0].data() as Map<String, dynamic>;
      // String dateField = data.containsKey('schedule')
      //     ? 'schedule'
      //     : 'issue_date';
      // issuedate = documents[0].get(dateField);
      // String issuedateText = dateField == 'schedule' ? 'Schedule Date' : 'Issued Date';
      issuedate = documents[i].get('issue_date');
      jobno = documents[i].get('jobno');
    }
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Device Details'),
            content: Container(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Employee ID:' + empid),
                    Text('Employee Name:' + empname),
                    Text('Job Number:' + jobno),
                    Text('Site Name:' + sitename),
                    Text('Issue Date: $issuedate'),
                  ],
                )),
            actions: <Widget>[
              MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: const Text('SUBMIT DEVICE'),
                onPressed: () {
                  setState(() {
                    scannerremovebtn(serialno);
                    Navigator.of(context).pop();
                  });
                },
              ),
              MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: const Text('CLOSE'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  TextEditingController _controller = TextEditingController();

  Future<void> _ScannerInputDialog(BuildContext context, serialno) async {
    final formKey = GlobalKey<FormState>();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter the following details'),
            content: SingleChildScrollView(
                child: Container  (
                    child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  valueText = value;
                                });
                              },
                              controller: Empid,
                              decoration: const InputDecoration(
                                  hintText: "Enter Emp Id"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Emp Id is required';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  valueText = value;
                                });
                              },
                              controller: Name,
                              decoration: const InputDecoration(
                                  hintText: "Enter Your name"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Name is required';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  valueText = value;
                                });
                              },
                              controller: Jobno,
                              decoration: const InputDecoration(
                                  hintText: "Enter Job No."),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Job Number is required';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  valueText = value;
                                });
                              },
                              controller: _sitename,
                              decoration: const InputDecoration(
                                  hintText: "Enter Site name"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Site name is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        )))),
            actions: <Widget>[
              Row(children: [
                MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: const Text('ISSUE NOW'),
                  onPressed: () {
                    setState(() async {
                      if (formKey.currentState!.validate()) {
                        codeDialog = valueText;

                        dateTime = DateTime.now();
                        issuedate =
                            DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
                        final CollectionReference collectionReference =
                            FirebaseFirestore.instance.collection('Scanner');
                        QuerySnapshot querySnapshot = await collectionReference
                            .where('serialno', isEqualTo: serialno)
                            .get();
                        List<DocumentSnapshot> documents = querySnapshot.docs;
                        for (int i = 0; i < documents.length; i++) {
                          selectedtype = documents[i].get('devie_type');
                          company = documents[i].get('company');
                          serial = documents[i].get('serialno');
                          invoice = documents[i].get('invoice');
                          calibration = documents[i].get('calibration');
                          duedate = documents[i].get('calibration_duedate');
                        }

                        Map<String, dynamic> data = {
                          "devie_type": selectedtype,
                          "serialno": serial,
                          "company": company,
                          "invoice": invoice,
                          "calibration": calibration,
                          "calibration_duedate": duedate,
                          "empid": Empid.text,
                          "sitename": _sitename.text,
                          "issue_date": issuedate,
                          "jobno": Jobno.text,
                          "empname": Name.text
                        };
                        FirebaseFirestore.instance
                            .collection("OnUseScanner")
                            .add(data);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Device Issued"),
                        ));
                        // }
                      }
                    });
                  },
                ),
                SizedBox(
                  width: 60,
                ),
                MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: const Text('SCHEDULE'),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          setState(() {
                            selectedDate = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });

                          codeDialog = valueText;

                          issuedate = DateFormat('yyyy-MM-dd HH:mm:ss')
                              .format(selectedDate);
                          final CollectionReference collectionReference =
                              FirebaseFirestore.instance.collection('Scanner');
                          QuerySnapshot querySnapshot =
                              await collectionReference
                                  .where('serialno', isEqualTo: serialno)
                                  .get();
                          List<DocumentSnapshot> documents = querySnapshot.docs;
                          for (int i = 0; i < documents.length; i++) {
                            selectedtype = documents[i].get('devie_type');
                            company = documents[i].get('company');
                            serial = documents[i].get('serialno');
                            invoice = documents[i].get('invoice');
                            calibration = documents[i].get('calibration');
                            duedate = documents[i].get('calibration_duedate');
                          }

                          Map<String, dynamic> data = {
                            "devie_type": selectedtype,
                            "serialno": serial,
                            "company": company,
                            "invoice": invoice,
                            "calibration": calibration,
                            "calibration_duedate": duedate,
                            "empid": Empid.text,
                            "sitename": _sitename.text,
                            "issue_date": issuedate,
                            "jobno": Jobno.text,
                            "empname": Name.text,
                            "schedule": "yes"
                          };
                          FirebaseFirestore.instance
                              .collection("OnUseScanner")
                              .add(data);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Device Scheduled"),
                          ));
                        }
                      }
                    }
                  },
                ),
              ]),
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
            ],
          );
        });
  }

  TextEditingController searchController = TextEditingController();

  Future<void> _SortDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Select the option on which you want to sort '),
            content: Container(
                height: 200,
                child: Column(
                  children: [
                    RadioListTile<SortBy>(
                      title: const Text('Invoice Date'),
                      value: SortBy.InvoiceDate,
                      groupValue: selectedSortBy,
                      onChanged: (SortBy? value) {
                        if (value != null) {
                          setState(() {
                            selectedSortBy = value;
                            Navigator.pop(context);
                          });
                        }
                      },
                    ),
                    RadioListTile<SortBy>(
                      title: const Text('Calibration Date'),
                      value: SortBy.CalibrationDate,
                      groupValue: selectedSortBy,
                      onChanged: (SortBy? value) {
                        if (value != null) {
                          setState(() {
                            selectedSortBy = value;
                            Navigator.pop(context);
                          });
                        }
                      },
                    ),
                  ],
                )),
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
          toolbarHeight: 180,
          title: Container(
              child: Column(children: [
            Row(children: <Widget>[
              Column(
                children: [
                  Text(
                    'Welcome Back!',
                    style: SafeGoogleFont(
                      'Anek Bangla',
                      fontSize: 24 * ffem,
                      fontWeight: FontWeight.w700,
                      height: 1.865 * ffem / fem,
                      color: Color(0xffffffff),
                    ),
                  ),
                  Text(
                    'Dashboard',
                    style: SafeGoogleFont(
                      'Anek Bangla',
                      fontSize: 20 * ffem,
                      fontWeight: FontWeight.w600,
                      height: 1.865 * ffem / fem,
                      color: Color(0xffffffff),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                // margin: EdgeInsets.fromLTRB(0*fem, 8*fem, 0*fem, 0*fem),
                padding:
                    EdgeInsets.fromLTRB(15 * fem, 10 * fem, 15 * fem, 10 * fem),
                width: 160 * fem,
                height: 100 * fem,
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(10 * fem),
                  // Adjust the value to control the roundness
                  border: Border.all(
                      color:
                          Colors.white), // Set the color of the border to white
                ),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        // group9Vrx (7:1997)
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 0 * fem, 0 * fem, 4 * fem),
                        width: double.infinity,
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  0 * fem, 0 * fem, 8 * fem, 1 * fem),
                              width: 10 * fem,
                              height: 10 * fem,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5 * fem),
                                border: Border.all(color: Color(0xff000000)),
                                color: Color(0xff00ff29),
                              ),
                            ),
                            Text(
                              'Device is Available',
                              style: SafeGoogleFont(
                                'Anek Bangla',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.865 * ffem / fem,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // group9Vrx (7:1997)
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 0 * fem, 0 * fem, 4 * fem),
                        width: double.infinity,
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  0 * fem, 0 * fem, 8 * fem, 1 * fem),
                              width: 10 * fem,
                              height: 10 * fem,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5 * fem),
                                border: Border.all(color: Color(0xff000000)),
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              'Device is Not Available',
                              style: SafeGoogleFont(
                                'Anek Bangla',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.865 * ffem / fem,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // group9Vrx (7:1997)
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 0 * fem, 0 * fem, 4 * fem),
                        width: double.infinity,
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  0 * fem, 0 * fem, 8 * fem, 1 * fem),
                              width: 10 * fem,
                              height: 10 * fem,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5 * fem),
                                border: Border.all(color: Color(0xff000000)),
                                color: Colors.orange,
                              ),
                            ),
                            Text(
                              'Scheduled Devices',
                              style: SafeGoogleFont(
                                'Anek Bangla',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.865 * ffem / fem,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
            Row(
              children: [
                Container(
                  width: 250,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[200],
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter serial number',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    ),
                    onChanged: (value) {
                      // setState(() {}); // Trigger rebuild when search query changes
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    _SortDialog(context);
                  },
                  child: Icon(Icons.sort),
                ),
              ],
            )
          ]))
          // backgroundColor: Color(0xff1c1b1f),
          ),
      body: Container(
        width: double.infinity,
        child: Container(
          // androidlarge25rG (7:2002)
          width: double.infinity,
          height: 800 * fem,
          decoration: BoxDecoration(
            color: Color(0xff1c1b1f),
          ),
          child: Stack(
            children: [
              //SCANNER
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Scanner')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    final userSnapshot = snapshot.data?.docs;
                    if (userSnapshot!.isEmpty) {
                      return Center(
                        child: Text(
                          'No data to show...!',
                          style: SafeGoogleFont(
                            'Anek Bangla',
                            fontSize: 20 * ffem,
                            fontWeight: FontWeight.w700,
                            height: 1.865 * ffem / fem,
                            color: Color(0xffffffff),
                          ),
                        ),
                      );
                    }
                    List<DocumentSnapshot> filteredList = userSnapshot;
                    String searchQuery = searchController.text.toLowerCase();
                    if (searchQuery.isNotEmpty) {
                      filteredList = userSnapshot.where((document) {
                        String serialNo =
                            document['serialno']?.toLowerCase() ?? '';
                        return serialNo.contains(searchQuery);
                      }).toList();
                    }
                    filteredList.sort((a, b) {
                      String dateA = a[selectedSortBy == SortBy.InvoiceDate
                          ? 'invoice'
                          : 'calibration'];
                      String dateB = b[selectedSortBy == SortBy.InvoiceDate
                          ? 'invoice'
                          : 'calibration'];

                      // Parse the date strings to DateTime objects for comparison
                      DateTime dateTimeA =
                          DateFormat('dd/MM/yyyy').parse(dateA);
                      DateTime dateTimeB =
                          DateFormat('dd/MM/yyyy').parse(dateB);

                      // Compare the DateTime objects
                      return dateTimeB.compareTo(dateTimeA);
                    });

                    return ListView.builder(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot<Object?> document =
                            filteredList[index];
                        final CollectionReference onUseCollectionReference =
                            FirebaseFirestore.instance
                                .collection('OnUseScanner');
                        return FutureBuilder<QuerySnapshot>(
                            future: onUseCollectionReference.get(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> onUseSnapshot) {
                              if (onUseSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container();
                              }
                              final onUseDocuments = onUseSnapshot.data!.docs;
                              final onUseSerialNumbers = onUseDocuments
                                  .map((doc) => doc['serialno'] as String)
                                  .toList();

                              var containerColor = Colors.green;
                              for (var onUseDocument in onUseDocuments) {
                                final onUseData = onUseDocument.data()
                                    as Map<String, dynamic>?;

                                if (onUseData != null &&
                                    onUseData.containsKey('schedule') &&
                                    onUseData['schedule'] == 'yes') {
                                  if (onUseData.containsKey('serialno') &&
                                      onUseData['serialno'] ==
                                          document['serialno']) {
                                    containerColor = Colors.orange;
                                    break;
                                  }
                                } else {
                                  if (onUseData != null &&
                                      onUseData.containsKey('serialno') &&
                                      onUseData['serialno'] ==
                                          document['serialno']) {
                                    containerColor = Colors.red;
                                    break;
                                  }
                                }
                              }

                              return Container(
                                // group63vQ (7:1943)
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 0 * fem, 13 * fem),
                                padding: EdgeInsets.fromLTRB(
                                    20 * fem, 11 * fem, 24 * fem, 0),
                                width: double.infinity,
                                height: 190 * fem,
                                decoration: BoxDecoration(
                                  color: Color(0xff48454e),
                                  borderRadius: BorderRadius.circular(15 * fem),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x3f000000),
                                      offset: Offset(0 * fem, 1 * fem),
                                      blurRadius: 3 * fem,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      // rectangle37579a (7:1933)
                                      margin: EdgeInsets.fromLTRB(
                                          0 * fem, 2 * fem, 27 * fem, 0 * fem),
                                      width: 80 * fem,
                                      height: 130 * fem,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(5 * fem),
                                        child: Image.asset(
                                          'assets/page-1/images/scanner.jpeg',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // autogrouphvpszz4 (Do2k8dufHUwf9qd2NMHvPS)
                                      width: 187 * fem,
                                      height: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            // autogrouprt8u9MA (Do2kFDZ2hjYb2TJJJLRT8U)
                                            margin: EdgeInsets.fromLTRB(0 * fem,
                                                0 * fem, 74 * fem, 0 * fem),
                                            width: double.infinity,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  // ellipse207snx (7:1937)
                                                  margin: EdgeInsets.fromLTRB(
                                                      0 * fem,
                                                      0 * fem,
                                                      9 * fem,
                                                      0 * fem),
                                                  width: 10 * fem,
                                                  height: 10 * fem,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5 * fem),
                                                    border: Border.all(
                                                        color:
                                                            Color(0xff000000)),
                                                    color: containerColor,
                                                  ),
                                                ),
                                                Text(
                                                  // scanner211387CKS (7:1934)
                                                  document['serialno'],
                                                  style: SafeGoogleFont(
                                                    'Anek Bangla',
                                                    fontSize: 15 * ffem,
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.865 * ffem / fem,
                                                    color: Color(0xffc9c5d0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            // autogroupxpxvK9A (Do2kM3ieZrcNZMU8vRXPXv)
                                            margin: EdgeInsets.fromLTRB(1 * fem,
                                                0 * fem, 0 * fem, 7 * fem),
                                            width: double.infinity,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Company/Brand Name:' +
                                                      document['company'],
                                                  style: SafeGoogleFont(
                                                    'Anek Bangla',
                                                    fontSize: 13 * ffem,
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.865 * ffem / fem,
                                                    color: Color(0xffc9c5d0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            // autogroupxpxvK9A (Do2kM3ieZrcNZMU8vRXPXv)
                                            margin: EdgeInsets.fromLTRB(1 * fem,
                                                0 * fem, 0 * fem, 7 * fem),
                                            width: double.infinity,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Calibration Date: ' +
                                                      document["calibration"],
                                                  style: SafeGoogleFont(
                                                    'Anek Bangla',
                                                    fontSize: 13 * ffem,
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.865 * ffem / fem,
                                                    color: Color(0xffc9c5d0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            // autogroupxpxvK9A (Do2kM3ieZrcNZMU8vRXPXv)
                                            margin: EdgeInsets.fromLTRB(1 * fem,
                                                0 * fem, 0 * fem, 7 * fem),
                                            width: double.infinity,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Invoice Date: ' +
                                                      document["invoice"],
                                                  style: SafeGoogleFont(
                                                    'Anek Bangla',
                                                    fontSize: 13 * ffem,
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.865 * ffem / fem,
                                                    color: Color(0xffc9c5d0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            // autogroupxpxvK9A (Do2kM3ieZrcNZMU8vRXPXv)
                                            margin: EdgeInsets.fromLTRB(1 * fem,
                                                0 * fem, 0 * fem, 7 * fem),
                                            width: double.infinity,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Calibration Duedate: ' +
                                                      document[
                                                          "calibration_duedate"],
                                                  style: SafeGoogleFont(
                                                    'Anek Bangla',
                                                    fontSize: 13 * ffem,
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.865 * ffem / fem,
                                                    color: Color(0xffc9c5d0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              final CollectionReference
                                                  onUseCollectionReference =
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          'OnUseScanner');
                                              QuerySnapshot onUseQuerySnapshot =
                                                  await onUseCollectionReference
                                                      .get();
                                              List<String> onUseSerialNumbers =
                                                  onUseQuerySnapshot.docs
                                                      .map((doc) =>
                                                          doc['serialno']
                                                              as String)
                                                      .toList();
                                              if (onUseSerialNumbers.contains(
                                                  document['serialno'])) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Device is already issued"),
                                                ));
                                                Showdetails(context,
                                                    document['serialno']);
                                              } else {
                                                _ScannerInputDialog(context,
                                                    document['serialno']);
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  17 * fem,
                                                  8.5 * fem,
                                                  20 * fem,
                                                  8.5 * fem),
                                              width: 130,
                                              height: 33 * fem,
                                              decoration: BoxDecoration(
                                                color: Color(0xff690005),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        50 * fem),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0x33000000),
                                                    offset: Offset(
                                                        0 * fem, 2 * fem),
                                                    blurRadius: 2 * fem,
                                                  ),
                                                  BoxShadow(
                                                    color: Color(0x1e000000),
                                                    offset: Offset(
                                                        0 * fem, 1 * fem),
                                                    blurRadius: 5 * fem,
                                                  ),
                                                  BoxShadow(
                                                    color: Color(0x23000000),
                                                    offset: Offset(
                                                        0 * fem, 4 * fem),
                                                    blurRadius: 2.5 * fem,
                                                  ),
                                                ],
                                              ),
                                              child: Container(
                                                // buttontzt (I8:2113;242:7198)
                                                width: double.infinity,
                                                height: double.infinity,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      // labelxUx (I8:2113;242:7201)
                                                      'VIEW DETAILS',
                                                      style: SafeGoogleFont(
                                                        'Anek Bangla',
                                                        fontSize: 14 * ffem,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1.1428571429 *
                                                            ffem /
                                                            fem,
                                                        letterSpacing:
                                                            1.25 * fem,
                                                        color:
                                                            Color(0xffffb4ab),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //Floating action button on Scaffold
        onPressed: () {
          Navigator.of(context).pushReplacementNamed("/add");
        },

        child: Icon(Icons.add), //icon inside button
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      //floating action button position to center

      bottomNavigationBar: BottomAppBar(
        //bottom navigation bar on scaffold
        color: Color(0xff48454e),
        shape: CircularNotchedRectangle(),
        //shape of notch
        notchMargin: 5,
        //notche margin between floating button and bottom appbar
        child: Row(
          //children inside bottom appbar
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home,
                color: Color(0xff386bf6),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/home");
              },
            ),
            // IconButton(
            //   icon: Icon(
            //     Icons.search,
            //     color: Colors.white,
            //   ),
            //   onPressed: () {
            //     Navigator.of(context).pushReplacementNamed("/search");
            //   },
            // ),
            IconButton(
              icon: Icon(
                Icons.history,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/history");
              },
            ),
            IconButton(
              icon: Icon(
                Icons.people,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/profile");
              },
            ),
          ],
        ),
      ),
    );
  }
}
