import 'dart:convert';

import 'package:acsv2/ACS/acc.dart';
import 'package:acsv2/ACS/deliv.dart';
import 'package:acsv2/ACS/invoice.dart';
import 'package:flutter/material.dart';
import 'package:acsv2/backend/url.dart';
import 'package:acsv2/login.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? nama, token, image;
  getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nama = prefs.getString('name')!;
    image = prefs.getString('image_url')!;

    setState(() {
      nama = prefs.getString('name');
      image = prefs.getString('image_url');
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  Future<bool> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("access_token");

    final response = await http.post(
      Uri.parse('${URLV2}oauth/revoke?token=${token!}$Client_Andro'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      print(result);
      Fluttertoast.showToast(
          msg: "Logout Success",
          backgroundColor: Colors.cyan.shade300,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP);

      setState(() {
        preferences.setInt("value", 0);
        preferences.remove("email");
        preferences.remove("name");
        preferences.commit();
      });

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Login()));

      return true;
    } else {
      Fluttertoast.showToast(
          msg: "Logout Failed " " Status = " + response.statusCode.toString(),
          backgroundColor: Colors.cyan.shade300,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP);
    }
    throw Exception(response.statusCode);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 250,
            title: Stack(
              children: [
                SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage('$image'),
                        ),
                      ),
                      Text(
                        "$nama",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const Text(
                        "Semoga Harimu Menyenangkan",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w200,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      logout();
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        'assets/power.png',
                        width: 30,
                      ),
                    ),
                  ),
                )
              ],
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/home.png'), fit: BoxFit.fill)),
            ),
          ),
          backgroundColor: Colors.white,
          body: Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Acc()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF7DA3F6), Color(0xFF0051FF)]),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 5, top: 15, bottom: 15),
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.assignment,
                            size: 40,
                            color: Color(0xFF264A99),
                          ),
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Scan Surat Jalan",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "Scan Pertama Menerima Surat Jalan",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Deliv()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF7DA3F6), Color(0xFF0051FF)]),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 5, top: 15, bottom: 15),
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.book,
                            size: 40,
                            color: Color(0xFF264A99),
                          ),
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Scan Surat Jalan Balik",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "Scan Surat Jalan yang Diterima",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Invoice()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF7DA3F6), Color(0xFF0051FF)]),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 5, top: 15, bottom: 15),
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.feed,
                            size: 40,
                            color: Color(0xFF264A99),
                          ),
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Scan Invoice",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "Scan Nomor Invoice",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container()
              ],
            ),
          ),
        ),
        onWillPop: () async => false);
  }
}
