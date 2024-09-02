import 'dart:convert';

import 'package:acsv2/backend/url.dart';
import 'package:acsv2/backend/style.dart';
// import 'package:acsv2/input/checkin.dart';
import 'package:acsv2/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class dataabsen {
  String status;
  String name, alamat, date;

  dataabsen({
    required this.status,
    required this.name,
    required this.alamat,
    required this.date,
  });

  factory dataabsen.fromJson(Map<String, dynamic> parsedJson) {
    return dataabsen(
        status: parsedJson['status'].toString(),
        name: parsedJson['name'].toString(),
        alamat: parsedJson['location'].toString(),
        date: parsedJson['created_at'].toString());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? name, token;
  bool loading = false;
  List<dataabsen> data = [];

  Future<List<dataabsen>> showdata() async {
    setState(() {
      loading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("access_token");

    var respons = await http.get(Uri.parse(URLV2 +
        'api/attendances?user_id=382&access_token=$token' +
        Client_Andro));
    if (respons.statusCode == 200) {
      final jsonitem = json.decode(respons.body);

      data = jsonitem.map<dataabsen>((json) {
        return dataabsen.fromJson(json);
      }).toList();
      setState(() {
        loading = false;
      });

      return data;
    } else {
      throw Exception("Failed Load Data");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    // showdata();
  }

  getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString("name");
    setState(() {
      name = prefs.getString("name");
    });
  }

  Future<bool> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("access_token");

    final response = await http.post(
      Uri.parse(URLV2 + 'oauth/revoke?token=' + token! + Client_Andro),
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
          msg: "Logout Failed " + " Status = " + response.statusCode.toString(),
          backgroundColor: Colors.cyan.shade300,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP);
    }
    throw Exception(response.statusCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 150,
          flexibleSpace: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 66, 137, 194),
                  blurRadius: 8,
                  offset: Offset(0.2, 0.5),
                ),
              ],
            ),
          ),
          title: Container(
              margin: const EdgeInsets.all(10),
              height: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      // logout();
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      setState(() {
                        preferences.setInt("value", 0);
                        preferences.remove("email");
                        preferences.remove("name");
                        preferences.commit();
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()));
                    },
                    child: Image.asset(
                      'assets/power.png',
                      width: 30,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Halo, $name",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                  width: 220,
                                  child: Text(
                                    "Selamat datang di Dashboard Anda",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 11),
                                  )),
                            ],
                          )),
                      Image.asset(
                        "assets/Login.png",
                        width: 100,
                      )
                    ],
                  ),
                ],
              )),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Menu Kehadiran", style: textstyle2),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Home()));
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              width: 100,
                              height: 100,
                              decoration: kBoxStyle,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.phone_android,
                                    color: Colors.blueAccent,
                                    size: 30,
                                  ),
                                  Text(
                                    "Check In \nOffice",
                                    style: textstyle3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            width: 100,
                            height: 100,
                            decoration: kBoxStyle,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.apartment,
                                  color: Colors.blueAccent,
                                  size: 30,
                                ),
                                Text(
                                  "Work Outside",
                                  style: textstyle3,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            width: 100,
                            height: 100,
                            decoration: kBoxStyle,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.home_rounded,
                                  color: Colors.blueAccent,
                                  size: 30,
                                ),
                                Text(
                                  "Work For Home",
                                  style: textstyle3,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(15),
                            width: 100,
                            height: 100,
                            decoration: kBoxStyleGradient,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.store,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                Text(
                                  "Check In",
                                  style: textstyle4,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            width: 100,
                            height: 100,
                            decoration: kBoxStyleGradient,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.travel_explore,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                Text(
                                  "Official Travel",
                                  style: textstyle4,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            width: 100,
                            height: 100,
                            decoration: kBoxStyleGradient,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.holiday_village,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                Text(
                                  "Work of Holiday",
                                  style: textstyle4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text("Menu Ketidakhadiran", style: textstyle2),
                      SizedBox(height: 15),
                      SingleChildScrollView(
                        padding: EdgeInsets.all(5),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              padding: EdgeInsets.all(15),
                              width: 150,
                              height: 200,
                              decoration: kBoxStyle,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.timelapse,
                                    color: Colors.blueAccent,
                                    size: 40,
                                  ),
                                  Text(
                                    "Ijin \nTerlambat",
                                    style: textstyle,
                                  ),
                                  Text(
                                    "Form menu ijin terlambat kerja",
                                    style: TextStyle(
                                        fontSize: 10,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              width: 150,
                              height: 200,
                              decoration: kBoxStyleGradient,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.sick,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  Text(
                                    "Ijin Sakit",
                                    style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "Form Pengajuan ijin Sakit",
                                    style: TextStyle(
                                        fontSize: 10,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              width: 150,
                              height: 200,
                              decoration: kBoxStyle,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.time_to_leave,
                                    color: Colors.blueAccent,
                                    size: 40,
                                  ),
                                  Text(
                                    "Ijin Cuti",
                                    style: textstyle,
                                  ),
                                  Text(
                                    "Form Pengajuan Ijin Cuti Kerja",
                                    style: TextStyle(
                                        fontSize: 10,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]))));
  }
}
