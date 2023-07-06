import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/utils.dart';

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

  @override
  Widget build(BuildContext context) {
    double baseWidth = 300;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Container(
      width: double.infinity,
      child: Container(
        // androidsmall1qTn (27:1489)
        width: double.infinity,
        height: 343*fem,
        decoration: BoxDecoration (
          color: Color(0xffffffff),
          borderRadius: BorderRadius.circular(10*fem),
        ),
        child: Container(
          // group229Da (19:1607)
          padding: EdgeInsets.fromLTRB(15*fem, 24.39*fem, 0*fem, 59*fem),
          width: 326*fem,
          height: 344*fem,
          decoration: BoxDecoration (
            color: Color(0xffd9d9d9),
            borderRadius: BorderRadius.circular(5*fem),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // autogroupoongDDS (Do37imSJFsWqcD2DT1oonG)
                margin: EdgeInsets.fromLTRB(57*fem, 0*fem, 52*fem, 25.83*fem),
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      // scanner211567w9S (19:1615)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 29*fem, 0*fem),
                      child: Text(
                        'Scanner 211567',
                        style: SafeGoogleFont (
                          'Roboto',
                          fontSize: 20*ffem,
                          fontWeight: FontWeight.w700,
                          height: 1.1725*ffem/fem,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                    Container(
                      // materialsymbolsarrowdropdownd2 (19:1617)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 5.73*fem),
                      width: 25*fem,
                      height: 35.87*fem,
                    ),
                  ],
                ),
              ),
              Container(
                // autogroupcxqgYQ8 (Do37obdaiVCS29r8zaCxQG)
                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 12*fem),
                width: double.infinity,
                height: 145.17*fem,
                child: Stack(
                  children: [
                    Positioned(
                      // anoleadingiconainactive3rg (19:1614)
                      left: 0*fem,
                      top: 71.1666564941*fem,
                      child: Container(
                        width: 266*fem,
                        height: 74*fem,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // inputfieldZKE (I19:1614;242:8210)
                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 4*fem),
                              padding: EdgeInsets.fromLTRB(14*fem, 16*fem, 13*fem, 14*fem),
                              width: double.infinity,
                              decoration: BoxDecoration (
                                color: Color(0x14212121),
                                borderRadius: BorderRadius.only (
                                  topLeft: Radius.circular(4*fem),
                                  topRight: Radius.circular(4*fem),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // inputtextERN (I19:1614;242:8211)
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 143*fem, 0*fem),
                                    child: Text(
                                      'Enter Site.',
                                      style: SafeGoogleFont (
                                        'Roboto',
                                        fontSize: 16*ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.5*ffem/fem,
                                        letterSpacing: 0.150000006*fem,
                                        color: Color(0xdd000000),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // trailingiconKxc (I19:1614;242:8212)
                                    margin: EdgeInsets.fromLTRB(0*fem, 1*fem, 0*fem, 0*fem),
                                    width: 22*fem,
                                    height: 15*fem,
                                    child: Image.asset(
                                      'assets/page-1/images/trailing-icon-jqz.png',
                                      width: 22*fem,
                                      height: 15*fem,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              // assistivetextF5a (I19:1614;242:8214)
                              margin: EdgeInsets.fromLTRB(16*fem, 0*fem, 0*fem, 0*fem),
                              child: Text(
                                'Inactive',
                                style: SafeGoogleFont (
                                  'Roboto',
                                  fontSize: 12*ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.3333333333*ffem/fem,
                                  letterSpacing: 0.400000006*fem,
                                  color: Color(0x99000000),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      // anoleadingiconcfocusedjmS (19:1616)
                      left: 0*fem,
                      top: 0*fem,
                      child: Container(
                        width: 311*fem,
                        height: 75*fem,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // inputfieldTBe (I19:1616;242:8188)
                              padding: EdgeInsets.fromLTRB(16*fem, 8*fem, 16*fem, 8*fem),
                              width: double.infinity,
                              height: 54*fem,
                              decoration: BoxDecoration (
                                color: Color(0x14212121),
                                borderRadius: BorderRadius.only (
                                  topLeft: Radius.circular(4*fem),
                                  topRight: Radius.circular(4*fem),
                                ),
                              ),
                              child: Container(
                                // inputN3i (I19:1616;242:8189)
                                width: 77*fem,
                                height: double.infinity,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      // inputautolayoutKDr (I19:1616;242:8190)
                                      left: 0*fem,
                                      top: 14*fem,
                                      child: Container(
                                        width: 77*fem,
                                        height: 24*fem,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              // inputtextdkL (I19:1616;242:8191)
                                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 3*fem, 0*fem),
                                              child: Text(
                                                'Input Text',
                                                style: SafeGoogleFont (
                                                  'Roboto',
                                                  fontSize: 16*ffem,
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.5*ffem/fem,
                                                  letterSpacing: 0.150000006*fem,
                                                  color: Color(0xdd000000),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              // cursork4G (I19:1616;242:8192)
                                              width: 1*fem,
                                              height: 17*fem,
                                              decoration: BoxDecoration (
                                                color: Color(0xff6200ee),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      // label688 (I19:1616;242:8193)
                                      left: 0*fem,
                                      top: 0*fem,
                                      child: Align(
                                        child: SizedBox(
                                          width: 45*fem,
                                          height: 16*fem,
                                          child: Text(
                                            'Job No.',
                                            style: SafeGoogleFont (
                                              'Roboto',
                                              fontSize: 12*ffem,
                                              fontWeight: FontWeight.w400,
                                              height: 1.3333333333*ffem/fem,
                                              letterSpacing: 0.400000006*fem,
                                              color: Color(0xff6200ee),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              // autogrouprs4yNrL (Do381B8dAGiKVYEzKCrS4Y)
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    // indicatorWxY (I19:1616;242:8195)
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 4*fem),
                                    width: 266*fem,
                                    height: 1*fem,
                                    decoration: BoxDecoration (
                                      color: Color(0xff6200ee),
                                    ),
                                  ),
                                  Container(
                                    // assistivetexteYx (I19:1616;242:8197)
                                    margin: EdgeInsets.fromLTRB(16*fem, 0*fem, 0*fem, 0*fem),
                                    child: Text(
                                      'Focused',
                                      style: SafeGoogleFont (
                                        'Roboto',
                                        fontSize: 12*ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.3333333333*ffem/fem,
                                        letterSpacing: 0.400000006*fem,
                                        color: Color(0xff6200ee),
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
                  ],
                ),
              ),
              Container(
                // containedatextenabledx3r (19:1609)
                margin: EdgeInsets.fromLTRB(55*fem, 0*fem, 97*fem, 0*fem),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom (
                    padding: EdgeInsets.zero,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 36*fem,
                    decoration: BoxDecoration (
                      color: Color(0xff6200ee),
                      borderRadius: BorderRadius.circular(4*fem),
                    ),
                    child: Center(
                      child: Text(
                        'ADD AS ONGOING',
                        style: SafeGoogleFont (
                          'Roboto',
                          fontSize: 14*ffem,
                          fontWeight: FontWeight.w500,
                          height: 1.1428571429*ffem/fem,
                          letterSpacing: 1.25*fem,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
          );
  }
}