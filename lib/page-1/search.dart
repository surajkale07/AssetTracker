import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:myapp/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';

import 'dart:async';

enum SortBy { InvoiceDate, CalibrationDate, CalibrationDueDate }

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  SortBy selectedSortBy = SortBy.InvoiceDate;

  late Stream query;
  Timestamp timestamp = Timestamp.now();
  late DateTime dateTime;
  late String issuedate;

  String? codeDialog;
  String? valueText;
  late String companyname,
      selectedtype,
      serial,
      company,
      invoice,
      calibration,
      duedate,
      useserial;

  final TextEditingController empid = TextEditingController();
  final TextEditingController _sitename = TextEditingController();
  final TextEditingController jobno = TextEditingController();
  final TextEditingController name = TextEditingController();

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


  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: Color(0xff1c1b1f),
            tabs: [
              Tab(text: 'Scanner'),
              Tab(text: 'Tripod'),
              Tab(text: 'Battery'),
              Tab(text: 'SD Card'),
            ],
          ),
          // title: Text('Search '),
          title: Row(
            children: [
              Text('Search'),
              // SizedBox(width: 10.0),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
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
                      setState(
                          () {}); // Trigger rebuild when search query changes
                    },
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _SortDialog(context);
                },
                child: Icon(Icons.sort),
              ),
            ],
          ),
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
                TabBarView(
                  children: [
                    //SCANNER
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Scanner')
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          final userSnapshot = snapshot.data?.docs;
                          if (userSnapshot!.isEmpty) {
                            return const Text("no data");
                          }

                          List<DocumentSnapshot> filteredList = userSnapshot;
                          String searchQuery =
                              searchController.text.toLowerCase();
                          if (searchQuery.isNotEmpty) {
                            filteredList = userSnapshot.where((document) {
                              String serialNo =
                                  document['serialno']?.toLowerCase() ?? '';
                              return serialNo.contains(searchQuery);
                            }).toList();
                          }

                          // Sort the filteredList based on the selectedSortBy value
                          // filteredList.sort((a, b) {
                          //   // Get the values of invoice, calibration_date, and calibration_due_date
                          //   String invoiceA = a['invoice'];
                          //   String invoiceB = b['invoice'];
                          //   String calibrationDateA = a['calibration'];
                          //   String calibrationDateB = b['calibration'];
                          //   String calibrationDueDateA = a['calibration_duedate'];
                          //   String calibrationDueDateB = b['calibration_duedate'];
                          //
                          //   // Parse the date strings to DateTime objects for comparison
                          //   DateTime dateTimeInvoiceA = DateFormat('dd/MM/yyyy').parse(invoiceA);
                          //   DateTime dateTimeInvoiceB = DateFormat('dd/MM/yyyy').parse(invoiceB);
                          //   DateTime dateTimeCalibrationDateA = DateFormat('dd/MM/yyyy').parse(calibrationDateA);
                          //   DateTime dateTimeCalibrationDateB = DateFormat('dd/MM/yyyy').parse(calibrationDateB);
                          //   DateTime dateTimeCalibrationDueDateA = DateFormat('dd/MM/yyyy').parse(calibrationDueDateA);
                          //   DateTime dateTimeCalibrationDueDateB = DateFormat('dd/MM/yyyy').parse(calibrationDueDateB);
                          //
                          //   // Compare the fields in the desired order
                          //   if (dateTimeInvoiceA != dateTimeInvoiceB) {
                          //     return dateTimeInvoiceB.compareTo(dateTimeInvoiceA); // Sort by invoice date in descending order
                          //   } else if (dateTimeCalibrationDateA != dateTimeCalibrationDateB) {
                          //     return dateTimeCalibrationDateB.compareTo(dateTimeCalibrationDateA); // Sort by calibration date in descending order
                          //   } else {
                          //     return dateTimeCalibrationDueDateB.compareTo(dateTimeCalibrationDueDateA); // Sort by calibration due date in descending order
                          //   }
                          // });

                          filteredList.sort((a, b) {
                            String dateA = a[
                                selectedSortBy == SortBy.InvoiceDate
                                    ? 'invoice'
                                    : 'calibration'];
                            String dateB = b[
                                selectedSortBy == SortBy.InvoiceDate
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
                            padding: EdgeInsets.only(top: 10),
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot<Object?> document =
                                  filteredList[index];
                              return Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Container(
                                  child: TextButton(
                                    onPressed: () async {
                                      // final CollectionReference
                                      //     onUseCollectionReference =
                                      //     FirebaseFirestore.instance
                                      //         .collection('OnUseScanner');
                                      // QuerySnapshot onUseQuerySnapshot =
                                      //     await onUseCollectionReference.get();
                                      // List<String> onUseSerialNumbers =
                                      //     onUseQuerySnapshot.docs
                                      //         .map((doc) =>
                                      //             doc['serialno'] as String)
                                      //         .toList();
                                      // if (onUseSerialNumbers
                                      //     .contains(document['serialno'])) {
                                      //   ScaffoldMessenger.of(context)
                                      //       .showSnackBar(SnackBar(
                                      //     content:
                                      //         Text("Device is already issued"),
                                      //   ));
                                      // } else {
                                      //   _ScannerInputDialog(
                                      //       context, document['serialno']);
                                      // }
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(18 * fem,
                                          14 * fem, 16 * fem, 17 * fem),
                                      width: 338 * fem,
                                      height: 160 * fem,
                                      decoration: BoxDecoration(
                                        color: Color(0xff48454e),
                                        borderRadius:
                                            BorderRadius.circular(15 * fem),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x3f000000),
                                            offset: Offset(0 * fem, 4 * fem),
                                            blurRadius: 2 * fem,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            // rectangle375gbi (11:2195)
                                            margin: EdgeInsets.fromLTRB(0 * fem,
                                                4 * fem, 18 * fem, 0 * fem),
                                            width: 80 * fem,
                                            height: 130 * fem,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5 * fem),
                                              child: Image.asset(
                                                'assets/page-1/images/scanner.jpeg',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            // autogroupbkgcPW8 (Do33L4RNUcBKDiMWP7bKGC)
                                            margin: EdgeInsets.fromLTRB(0 * fem,
                                                0 * fem, 35 * fem, 0 * fem),
                                            height: double.infinity,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      if (document != null &&
                                                          document[
                                                                  'serialno'] !=
                                                              null)
                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  0 * fem,
                                                                  0 * fem,
                                                                  0 * fem,
                                                                  1 * fem),
                                                          child: Text(
                                                            'Serialno.: ' +
                                                                document[
                                                                    'serialno'],
                                                            style:
                                                                SafeGoogleFont(
                                                              'Anek Bangla',
                                                              fontSize:
                                                                  14 * ffem,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              height: 1.865 *
                                                                  ffem /
                                                                  fem,
                                                              color: Color(
                                                                  0xffffffff),
                                                            ),
                                                          ),
                                                        ),
                                                      SizedBox(
                                                        width: 50,
                                                      ),
                                                      InkWell(
                                                          onTap: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    title: const Text(
                                                                        'Alert!!!'),
                                                                    content: Container(
                                                                        height: 50,
                                                                        child: Column(
                                                                          children: [
                                                                            Text(
                                                                              'Do you want delete the device permanently???',
                                                                              style: SafeGoogleFont(
                                                                                'Anek Bangla',
                                                                                fontSize: 14 * ffem,
                                                                                fontWeight: FontWeight.w400,
                                                                                height: 1.865 * ffem / fem,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )),
                                                                    actions: <Widget>[
                                                                      MaterialButton(
                                                                        color: Colors
                                                                            .blue,
                                                                        textColor:
                                                                            Colors.white,
                                                                        child: const Text(
                                                                            'NO'),
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          });
                                                                        },
                                                                      ),
                                                                      MaterialButton(
                                                                        color: Colors
                                                                            .blue,
                                                                        textColor:
                                                                            Colors.white,
                                                                        child: const Text(
                                                                            'YES'),
                                                                        onPressed:
                                                                            () {
                                                                          final CollectionReference
                                                                              scannerReference =
                                                                              FirebaseFirestore.instance.collection('Scanner');
                                                                          Query
                                                                              query =
                                                                              scannerReference.where('serialno', isEqualTo: document['serialno']);
                                                                          query
                                                                              .get()
                                                                              .then((querySnapshot) {
                                                                            querySnapshot.docs.forEach((doc) {
                                                                              doc.reference.delete().then((value) => print('Document deleted')).catchError((error) => print('Error deleting document: $error'));
                                                                            });
                                                                          });
                                                                          final CollectionReference
                                                                              onusecollection =
                                                                              FirebaseFirestore.instance.collection('OnUseScanner');
                                                                          Query
                                                                              usequery =
                                                                              onusecollection.where('serialno', isEqualTo: document['serialno']);
                                                                          usequery
                                                                              .get()
                                                                              .then((querySnapshot) {
                                                                            querySnapshot.docs.forEach((doc) {
                                                                              doc.reference.delete().then((value) => print('Document deleted form onuse')).catchError((error) => print('Error deleting document: $error'));
                                                                            });
                                                                          });
                                                                          Navigator.pop(
                                                                              context);
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(SnackBar(
                                                                            content:
                                                                                Text("Device details deleted"),
                                                                          ));
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                });
                                                          },
                                                          child: Icon(Icons
                                                              .delete_forever))
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  // companybrand3ag (11:2197)
                                                  margin: EdgeInsets.fromLTRB(
                                                      0 * fem,
                                                      0 * fem,
                                                      0 * fem,
                                                      5 * fem),
                                                  child: Text(
                                                    'Company/Brand Name: ' +
                                                        document['company'],
                                                    style: SafeGoogleFont(
                                                      'Anek Bangla',
                                                      fontSize: 14 * ffem,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height:
                                                          1.865 * ffem / fem,
                                                      color: Color(0xffffffff),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  // calibrationdateZZ2 (11:2199)
                                                  margin: EdgeInsets.fromLTRB(
                                                      2 * fem,
                                                      0 * fem,
                                                      0 * fem,
                                                      0 * fem),
                                                  child: Text(
                                                    'Calibration Date: ' +
                                                        document["calibration"],
                                                    style: SafeGoogleFont(
                                                      'Anek Bangla',
                                                      fontSize: 14 * ffem,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height:
                                                          1.865 * ffem / fem,
                                                      color: Color(0xffffffff),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  // invoicedateRLL (11:2198)
                                                  margin: EdgeInsets.fromLTRB(
                                                      0 * fem,
                                                      0 * fem,
                                                      0 * fem,
                                                      5 * fem),
                                                  child: Text(
                                                    'Invoice Date: ' +
                                                        document["invoice"],
                                                    style: SafeGoogleFont(
                                                      'Anek Bangla',
                                                      fontSize: 14 * ffem,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height:
                                                          1.865 * ffem / fem,
                                                      color: Color(0xffffffff),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  // duedateMDz (11:2200)

                                                  'Calibration Duedate: ' +
                                                      document[
                                                          "calibration_duedate"],
                                                  style: SafeGoogleFont(
                                                    'Anek Bangla',
                                                    fontSize: 14 * ffem,
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.865 * ffem / fem,
                                                    color: Color(0xffffffff),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Tripod')
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          final userSnapshot = snapshot.data?.docs;
                          if (userSnapshot!.isEmpty) {
                            return const Text("no data");
                          }

                          List<DocumentSnapshot> filteredList = userSnapshot;
                          String searchQuery =
                              searchController.text.toLowerCase();
                          if (searchQuery.isNotEmpty) {
                            filteredList = userSnapshot.where((document) {
                              String serialNo =
                                  document['serialno']?.toLowerCase() ?? '';
                              return serialNo.contains(searchQuery);
                            }).toList();
                          }

                          filteredList.sort((a, b) {
                            String invoiceDateA = a['invoice'];
                            String invoiceDateB = b['invoice'];
                            DateTime dateTimeA =
                                DateFormat('dd/MM/yyyy').parse(invoiceDateA);
                            DateTime dateTimeB =
                                DateFormat('dd/MM/yyyy').parse(invoiceDateB);
                            return dateTimeB.compareTo(dateTimeA);
                          });

                          return ListView.builder(
                            padding: EdgeInsets.only(top: 10),
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot<Object?> document =
                                  filteredList[index];
                              return Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Container(
                                  // group16ef2 (11:2202)
                                  // left: 11*fem,
                                  // top: 139*fem,
                                  child: TextButton(
                                    onPressed: () async {
                                      // final CollectionReference
                                      //     onUseCollectionReference =
                                      //     FirebaseFirestore.instance
                                      //         .collection('OnUseTripod');
                                      // QuerySnapshot onUseQuerySnapshot =
                                      //     await onUseCollectionReference.get();
                                      // List<String> onUseSerialNumbers =
                                      //     onUseQuerySnapshot.docs
                                      //         .map((doc) =>
                                      //             doc['serialno'] as String)
                                      //         .toList();
                                      // if (onUseSerialNumbers
                                      //     .contains(document['serialno'])) {
                                      //   ScaffoldMessenger.of(context)
                                      //       .showSnackBar(SnackBar(
                                      //     content:
                                      //         Text("Device is already issued"),
                                      //   ));
                                      // } else {
                                      //   _TripodInputDialog(
                                      //       context, document['serialno']);
                                      // }
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(18 * fem,
                                          14 * fem, 16 * fem, 17 * fem),
                                      width: 338 * fem,
                                      height: 120 * fem,
                                      decoration: BoxDecoration(
                                        color: Color(0xff48454e),
                                        borderRadius:
                                            BorderRadius.circular(15 * fem),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x3f000000),
                                            offset: Offset(0 * fem, 4 * fem),
                                            blurRadius: 2 * fem,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            // rectangle375gbi (11:2195)
                                            margin: EdgeInsets.fromLTRB(0 * fem,
                                                4 * fem, 18 * fem, 0 * fem),
                                            width: 80 * fem,
                                            height: 77 * fem,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5 * fem),
                                              child: Image.asset(
                                                'assets/page-1/images/scanner.jpeg',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            // autogroupbkgcPW8 (Do33L4RNUcBKDiMWP7bKGC)
                                            margin: EdgeInsets.fromLTRB(0 * fem,
                                                0 * fem, 35 * fem, 0 * fem),
                                            height: double.infinity,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      if (document != null &&
                                                          document[
                                                                  'serialno'] !=
                                                              null)
                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  0 * fem,
                                                                  0 * fem,
                                                                  0 * fem,
                                                                  1 * fem),
                                                          child: Text(
                                                            'Serialno.: ' +
                                                                document[
                                                                    'serialno'],
                                                            style:
                                                                SafeGoogleFont(
                                                              'Anek Bangla',
                                                              fontSize:
                                                                  14 * ffem,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              height: 1.865 *
                                                                  ffem /
                                                                  fem,
                                                              color: Color(
                                                                  0xffffffff),
                                                            ),
                                                          ),
                                                        ),
                                                      SizedBox(
                                                        width: 50,
                                                      ),
                                                      InkWell(
                                                          onTap: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    title: const Text(
                                                                        'Alert!!!'),
                                                                    content: Container(
                                                                        height: 50,
                                                                        child: Column(
                                                                          children: [
                                                                            Text(
                                                                              'Do you want delete the device permanently???',
                                                                              style: SafeGoogleFont(
                                                                                'Anek Bangla',
                                                                                fontSize: 14 * ffem,
                                                                                fontWeight: FontWeight.w400,
                                                                                height: 1.865 * ffem / fem,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )),
                                                                    actions: <Widget>[
                                                                      MaterialButton(
                                                                        color: Colors
                                                                            .blue,
                                                                        textColor:
                                                                            Colors.white,
                                                                        child: const Text(
                                                                            'NO'),
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          });
                                                                        },
                                                                      ),
                                                                      MaterialButton(
                                                                        color: Colors
                                                                            .blue,
                                                                        textColor:
                                                                            Colors.white,
                                                                        child: const Text(
                                                                            'YES'),
                                                                        onPressed:
                                                                            () {
                                                                          final CollectionReference
                                                                              scannerReference =
                                                                              FirebaseFirestore.instance.collection('Tripod');
                                                                          Query
                                                                              query =
                                                                              scannerReference.where('serialno', isEqualTo: document['serialno']);
                                                                          query
                                                                              .get()
                                                                              .then((querySnapshot) {
                                                                            querySnapshot.docs.forEach((doc) {
                                                                              doc.reference.delete().then((value) => print('Document deleted')).catchError((error) => print('Error deleting document: $error'));
                                                                            });
                                                                          });
                                                                          final CollectionReference
                                                                              onusecollection =
                                                                              FirebaseFirestore.instance.collection('OnUseTripod');
                                                                          Query
                                                                              usequery =
                                                                              onusecollection.where('serialno', isEqualTo: document['serialno']);
                                                                          usequery
                                                                              .get()
                                                                              .then((querySnapshot) {
                                                                            querySnapshot.docs.forEach((doc) {
                                                                              doc.reference.delete().then((value) => print('Document deleted form onuse')).catchError((error) => print('Error deleting document: $error'));
                                                                            });
                                                                          });
                                                                          Navigator.pop(
                                                                              context);
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(SnackBar(
                                                                            content:
                                                                                Text("Device details deleted"),
                                                                          ));
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                });
                                                          },
                                                          child: Icon(Icons
                                                              .delete_forever))
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  // companybrand3ag (11:2197)
                                                  margin: EdgeInsets.fromLTRB(
                                                      0 * fem,
                                                      0 * fem,
                                                      0 * fem,
                                                      5 * fem),
                                                  child: Text(
                                                    'Company/Brand Name: ' +
                                                        document['company'],
                                                    style: SafeGoogleFont(
                                                      'Anek Bangla',
                                                      fontSize: 14 * ffem,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height:
                                                          1.865 * ffem / fem,
                                                      color: Color(0xffffffff),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  // invoicedateRLL (11:2198)
                                                  margin: EdgeInsets.fromLTRB(
                                                      0 * fem,
                                                      0 * fem,
                                                      0 * fem,
                                                      5 * fem),
                                                  child: Text(
                                                    'Invoice Date: ' +
                                                        document["invoice"],
                                                    style: SafeGoogleFont(
                                                      'Anek Bangla',
                                                      fontSize: 14 * ffem,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height:
                                                          1.865 * ffem / fem,
                                                      color: Color(0xffffffff),
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
                                ),
                              );
                            },
                          );
                        }),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Battery')
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          final userSnapshot = snapshot.data?.docs;
                          if (userSnapshot!.isEmpty) {
                            return const Text("no data");
                          }

                          List<DocumentSnapshot> filteredList = userSnapshot;
                          String searchQuery =
                              searchController.text.toLowerCase();
                          if (searchQuery.isNotEmpty) {
                            filteredList = userSnapshot.where((document) {
                              String serialNo =
                                  document['serialno']?.toLowerCase() ?? '';
                              return serialNo.contains(searchQuery);
                            }).toList();
                          }
                          filteredList.sort((a, b) {
                            String invoiceDateA = a['invoice'];
                            String invoiceDateB = b['invoice'];
                            DateTime dateTimeA =
                                DateFormat('dd/MM/yyyy').parse(invoiceDateA);
                            DateTime dateTimeB =
                                DateFormat('dd/MM/yyyy').parse(invoiceDateB);
                            return dateTimeB.compareTo(dateTimeA);
                          });

                          return ListView.builder(
                            padding: EdgeInsets.only(top: 10),
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot<Object?> document =
                                  filteredList[index];
                              return Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Container(
                                  // group16ef2 (11:2202)
                                  // left: 11*fem,
                                  // top: 139*fem,
                                  child: TextButton(
                                    onPressed: () async {
                                      // final CollectionReference
                                      //     onUseCollectionReference =
                                      //     FirebaseFirestore.instance
                                      //         .collection('OnUseBattery');
                                      // QuerySnapshot onUseQuerySnapshot =
                                      //     await onUseCollectionReference.get();
                                      // List<String> onUseSerialNumbers =
                                      //     onUseQuerySnapshot.docs
                                      //         .map((doc) =>
                                      //             doc['serialno'] as String)
                                      //         .toList();
                                      // if (onUseSerialNumbers
                                      //     .contains(document['serialno'])) {
                                      //   ScaffoldMessenger.of(context)
                                      //       .showSnackBar(SnackBar(
                                      //     content:
                                      //         Text("Device is already issued"),
                                      //   ));
                                      // } else {
                                      //   _BatteryInputDialog(
                                      //       context, document['serialno']);
                                      // }
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(18 * fem,
                                          14 * fem, 16 * fem, 17 * fem),
                                      width: 338 * fem,
                                      height: 120 * fem,
                                      decoration: BoxDecoration(
                                        color: Color(0xff48454e),
                                        borderRadius:
                                            BorderRadius.circular(15 * fem),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x3f000000),
                                            offset: Offset(0 * fem, 4 * fem),
                                            blurRadius: 2 * fem,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            // rectangle375gbi (11:2195)
                                            margin: EdgeInsets.fromLTRB(0 * fem,
                                                4 * fem, 18 * fem, 0 * fem),
                                            width: 80 * fem,
                                            height: 77 * fem,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5 * fem),
                                              child: Image.asset(
                                                'assets/page-1/images/scanner.jpeg',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            // autogroupbkgcPW8 (Do33L4RNUcBKDiMWP7bKGC)
                                            margin: EdgeInsets.fromLTRB(0 * fem,
                                                0 * fem, 35 * fem, 0 * fem),
                                            height: double.infinity,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      if (document != null &&
                                                          document[
                                                                  'serialno'] !=
                                                              null)
                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  0 * fem,
                                                                  0 * fem,
                                                                  0 * fem,
                                                                  1 * fem),
                                                          child: Text(
                                                            'Serialno.: ' +
                                                                document[
                                                                    'serialno'],
                                                            style:
                                                                SafeGoogleFont(
                                                              'Anek Bangla',
                                                              fontSize:
                                                                  14 * ffem,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              height: 1.865 *
                                                                  ffem /
                                                                  fem,
                                                              color: Color(
                                                                  0xffffffff),
                                                            ),
                                                          ),
                                                        ),
                                                      SizedBox(
                                                        width: 50,
                                                      ),
                                                      InkWell(
                                                          onTap: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    title: const Text(
                                                                        'Alert!!!'),
                                                                    content: Container(
                                                                        height: 50,
                                                                        child: Column(
                                                                          children: [
                                                                            Text(
                                                                              'Do you want delete the device permanently???',
                                                                              style: SafeGoogleFont(
                                                                                'Anek Bangla',
                                                                                fontSize: 14 * ffem,
                                                                                fontWeight: FontWeight.w400,
                                                                                height: 1.865 * ffem / fem,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )),
                                                                    actions: <Widget>[
                                                                      MaterialButton(
                                                                        color: Colors
                                                                            .blue,
                                                                        textColor:
                                                                            Colors.white,
                                                                        child: const Text(
                                                                            'NO'),
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          });
                                                                        },
                                                                      ),
                                                                      MaterialButton(
                                                                        color: Colors
                                                                            .blue,
                                                                        textColor:
                                                                            Colors.white,
                                                                        child: const Text(
                                                                            'YES'),
                                                                        onPressed:
                                                                            () {
                                                                          final CollectionReference
                                                                              scannerReference =
                                                                              FirebaseFirestore.instance.collection('Battery');
                                                                          Query
                                                                              query =
                                                                              scannerReference.where('serialno', isEqualTo: document['serialno']);
                                                                          query
                                                                              .get()
                                                                              .then((querySnapshot) {
                                                                            querySnapshot.docs.forEach((doc) {
                                                                              doc.reference.delete().then((value) => print('Document deleted')).catchError((error) => print('Error deleting document: $error'));
                                                                            });
                                                                          });
                                                                          final CollectionReference
                                                                              onusecollection =
                                                                              FirebaseFirestore.instance.collection('OnUseBattery');
                                                                          Query
                                                                              usequery =
                                                                              onusecollection.where('serialno', isEqualTo: document['serialno']);
                                                                          usequery
                                                                              .get()
                                                                              .then((querySnapshot) {
                                                                            querySnapshot.docs.forEach((doc) {
                                                                              doc.reference.delete().then((value) => print('Document deleted form onuse')).catchError((error) => print('Error deleting document: $error'));
                                                                            });
                                                                          });
                                                                          Navigator.pop(
                                                                              context);
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(SnackBar(
                                                                            content:
                                                                                Text("Device details deleted"),
                                                                          ));
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                });
                                                          },
                                                          child: Icon(Icons
                                                              .delete_forever))
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  // companybrand3ag (11:2197)
                                                  margin: EdgeInsets.fromLTRB(
                                                      0 * fem,
                                                      0 * fem,
                                                      0 * fem,
                                                      5 * fem),
                                                  child: Text(
                                                    'Company/Brand Name: ' +
                                                        document['company'],
                                                    style: SafeGoogleFont(
                                                      'Anek Bangla',
                                                      fontSize: 14 * ffem,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height:
                                                          1.865 * ffem / fem,
                                                      color: Color(0xffffffff),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  // invoicedateRLL (11:2198)
                                                  margin: EdgeInsets.fromLTRB(
                                                      0 * fem,
                                                      0 * fem,
                                                      0 * fem,
                                                      5 * fem),
                                                  child: Text(
                                                    'Invoice Date: ' +
                                                        document["invoice"],
                                                    style: SafeGoogleFont(
                                                      'Anek Bangla',
                                                      fontSize: 14 * ffem,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height:
                                                          1.865 * ffem / fem,
                                                      color: Color(0xffffffff),
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
                                ),
                              );
                            },
                          );
                        }),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('SdCard')
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          final userSnapshot = snapshot.data?.docs;
                          if (userSnapshot!.isEmpty) {
                            return const Text("no data");
                          }

                          List<DocumentSnapshot> filteredList = userSnapshot;
                          String searchQuery =
                              searchController.text.toLowerCase();
                          if (searchQuery.isNotEmpty) {
                            filteredList = userSnapshot.where((document) {
                              String serialNo =
                                  document['serialno']?.toLowerCase() ?? '';
                              return serialNo.contains(searchQuery);
                            }).toList();
                          }

                          filteredList.sort((a, b) {
                            String invoiceDateA = a['invoice'];
                            String invoiceDateB = b['invoice'];
                            DateTime dateTimeA =
                                DateFormat('dd/MM/yyyy').parse(invoiceDateA);
                            DateTime dateTimeB =
                                DateFormat('dd/MM/yyyy').parse(invoiceDateB);
                            return dateTimeB.compareTo(dateTimeA);
                          });
                          return ListView.builder(
                            padding: EdgeInsets.only(top: 10),
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot<Object?> document =
                                  filteredList[index];
                              return Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Container(
                                  // group16ef2 (11:2202)
                                  // left: 11*fem,
                                  // top: 139*fem,
                                  child: TextButton(
                                    onPressed: () async {
                                      // final CollectionReference
                                      //     onUseCollectionReference =
                                      //     FirebaseFirestore.instance
                                      //         .collection('OnUseSdcard');
                                      // QuerySnapshot onUseQuerySnapshot =
                                      //     await onUseCollectionReference.get();
                                      // List<String> onUseSerialNumbers =
                                      //     onUseQuerySnapshot.docs
                                      //         .map((doc) =>
                                      //             doc['serialno'] as String)
                                      //         .toList();
                                      // if (onUseSerialNumbers
                                      //     .contains(document['serialno'])) {
                                      //   ScaffoldMessenger.of(context)
                                      //       .showSnackBar(SnackBar(
                                      //     content:
                                      //         Text("Device is already issued"),
                                      //   ));
                                      // } else {
                                      //   _SdcardInputDialog(
                                      //       context, document['serialno']);
                                      // }
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(18 * fem,
                                          14 * fem, 16 * fem, 17 * fem),
                                      width: 338 * fem,
                                      height: 120 * fem,
                                      decoration: BoxDecoration(
                                        color: Color(0xff48454e),
                                        borderRadius:
                                            BorderRadius.circular(15 * fem),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x3f000000),
                                            offset: Offset(0 * fem, 4 * fem),
                                            blurRadius: 2 * fem,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            // rectangle375gbi (11:2195)
                                            margin: EdgeInsets.fromLTRB(0 * fem,
                                                4 * fem, 18 * fem, 0 * fem),
                                            width: 80 * fem,
                                            height: 77 * fem,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5 * fem),
                                              child: Image.asset(
                                                'assets/page-1/images/scanner.jpeg',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            // autogroupbkgcPW8 (Do33L4RNUcBKDiMWP7bKGC)
                                            margin: EdgeInsets.fromLTRB(0 * fem,
                                                0 * fem, 35 * fem, 0 * fem),
                                            height: double.infinity,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      if (document != null &&
                                                          document[
                                                                  'serialno'] !=
                                                              null)
                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  0 * fem,
                                                                  0 * fem,
                                                                  0 * fem,
                                                                  1 * fem),
                                                          child: Text(
                                                            'Serialno.: ' +
                                                                document[
                                                                    'serialno'],
                                                            style:
                                                                SafeGoogleFont(
                                                              'Anek Bangla',
                                                              fontSize:
                                                                  14 * ffem,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              height: 1.865 *
                                                                  ffem /
                                                                  fem,
                                                              color: Color(
                                                                  0xffffffff),
                                                            ),
                                                          ),
                                                        ),
                                                      SizedBox(
                                                        width: 50,
                                                      ),
                                                      InkWell(
                                                          onTap: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    title: const Text(
                                                                        'Alert!!!'),
                                                                    content: Container(
                                                                        height: 50,
                                                                        child: Column(
                                                                          children: [
                                                                            Text(
                                                                              'Do you want delete the device permanently???',
                                                                              style: SafeGoogleFont(
                                                                                'Anek Bangla',
                                                                                fontSize: 14 * ffem,
                                                                                fontWeight: FontWeight.w400,
                                                                                height: 1.865 * ffem / fem,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )),
                                                                    actions: <Widget>[
                                                                      MaterialButton(
                                                                        color: Colors
                                                                            .blue,
                                                                        textColor:
                                                                            Colors.white,
                                                                        child: const Text(
                                                                            'NO'),
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          });
                                                                        },
                                                                      ),
                                                                      MaterialButton(
                                                                        color: Colors
                                                                            .blue,
                                                                        textColor:
                                                                            Colors.white,
                                                                        child: const Text(
                                                                            'YES'),
                                                                        onPressed:
                                                                            () {
                                                                          final CollectionReference
                                                                              scannerReference =
                                                                              FirebaseFirestore.instance.collection('SdCard');
                                                                          Query
                                                                              query =
                                                                              scannerReference.where('serialno', isEqualTo: document['serialno']);
                                                                          query
                                                                              .get()
                                                                              .then((querySnapshot) {
                                                                            querySnapshot.docs.forEach((doc) {
                                                                              doc.reference.delete().then((value) => print('Document deleted')).catchError((error) => print('Error deleting document: $error'));
                                                                            });
                                                                          });
                                                                          final CollectionReference
                                                                              onusecollection =
                                                                              FirebaseFirestore.instance.collection('OnUseSdcard');
                                                                          Query
                                                                              usequery =
                                                                              onusecollection.where('serialno', isEqualTo: document['serialno']);
                                                                          usequery
                                                                              .get()
                                                                              .then((querySnapshot) {
                                                                            querySnapshot.docs.forEach((doc) {
                                                                              doc.reference.delete().then((value) => print('Document deleted form onuse')).catchError((error) => print('Error deleting document: $error'));
                                                                            });
                                                                          });
                                                                          Navigator.pop(
                                                                              context);
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(SnackBar(
                                                                            content:
                                                                                Text("Device details deleted"),
                                                                          ));
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                });
                                                          },
                                                          child: Icon(Icons
                                                              .delete_forever))
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  // companybrand3ag (11:2197)
                                                  margin: EdgeInsets.fromLTRB(
                                                      0 * fem,
                                                      0 * fem,
                                                      0 * fem,
                                                      5 * fem),
                                                  child: Text(
                                                    'Company/Brand Name: ' +
                                                        document['company'],
                                                    style: SafeGoogleFont(
                                                      'Anek Bangla',
                                                      fontSize: 14 * ffem,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height:
                                                          1.865 * ffem / fem,
                                                      color: Color(0xffffffff),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  // invoicedateRLL (11:2198)
                                                  margin: EdgeInsets.fromLTRB(
                                                      0 * fem,
                                                      0 * fem,
                                                      0 * fem,
                                                      5 * fem),
                                                  child: Text(
                                                    'Invoice Date: ' +
                                                        document["invoice"],
                                                    style: SafeGoogleFont(
                                                      'Anek Bangla',
                                                      fontSize: 14 * ffem,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height:
                                                          1.865 * ffem / fem,
                                                      color: Color(0xffffffff),
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
                                ),
                              );
                            },
                          );
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),

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
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed("/home");
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Color(0xff386bf6),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed("/search");
                },
              ),
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
      ),
    );
  }
}
