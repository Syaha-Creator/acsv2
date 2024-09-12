import 'dart:async';
import 'dart:convert';

import 'package:acsv2/ACS/scanner.dart';
import 'package:acsv2/backend/style.dart';
import 'package:acsv2/backend/url.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class datamodel {
  String deliverynumber;
  String name, date, acs;

  datamodel({
    required this.deliverynumber,
    required this.name,
    required this.date,
    required this.acs,
  });

  factory datamodel.fromJson(Map<String, dynamic> parsedJson) {
    return datamodel(
      deliverynumber: parsedJson['delivery_number'].toString(),
      name: parsedJson["creator"].toString(),
      acs: parsedJson["acs_receiver"].toString(),
      date: parsedJson["created_at"].toString(),
    );
  }
}

class Acc extends StatefulWidget {
  const Acc({super.key});

  @override
  State<Acc> createState() => _AccState();
}

class _AccState extends State<Acc> {
  String? nama, token, result;
  String serial = "";
  int? id, area;
  TextEditingController forminput = TextEditingController();
  ProgressDialog? progressDialog;
  bool loading = false;
  List<datamodel> models = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showdata();
    getPref();
  }

  Future save() async {
    progressDialog = ProgressDialog(context, type: ProgressDialogType.normal);
    progressDialog!.style(message: 'Mohon Tunggu');
    progressDialog!.show();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("access_token");
    nama = prefs.getString("name");
    id = prefs.getInt("id");
    area = prefs.getInt("area_id");

    var url = Uri.parse(
        "${URLV2}api/delivery_orders?access_token=$token$Client_Andro");
    var request = http.MultipartRequest("POST", url);
    request.headers["Content-Type"] = 'multipart/form-data';
    request.fields['delivery_order[delivery_number]'] = result!;
    request.fields['delivery_order[creator]'] = nama!;
    request.fields['delivery_order[creator_id]'] = id.toString();
    request.fields['delivery_order[area_id]'] = area.toString();

    var response = await request.send();
    print(response.statusCode);

    if (response.statusCode == 200) {
      progressDialog!.hide();
      print(response.statusCode);

      time();
      Fluttertoast.showToast(
          msg: "Berhasil",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM // also possible "TOP" and "CENTER"

          );
    } else {
      print("Gagal,data sudah ada");
      progressDialog!.hide();
      Fluttertoast.showToast(
          msg: "Delivery Number sudah ada",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM // also possible "TOP" and "CENTER"

          );
      time();
    }
  }

  time() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(
        context, new MaterialPageRoute(builder: (context) => Acc()));
  }

  Future _buildQrView(BuildContext context) async {
    final results = await Navigator.push(
        context, MaterialPageRoute(builder: (c) => Scanner()));
    result = results;

    setState(() {
      result = results;
    });
    print("hasil2 = " + result!);
    return result;
  }

  getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nama = prefs.getString("name")!;
    id = prefs.getInt("id")!;
    setState(() {
      nama = prefs.getString("name");
      id = prefs.getInt("id");
    });
  }

  Future<void> showdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getInt('id')!;
    token = prefs.getString('access_token').toString();
    nama = prefs.getString("name")!;

    setState(() {
      loading = true;
    });

    print(URLV2 + 'api/delivery_orders?access_token=$token' + Client_Andro);
    var responseData = await http.get(Uri.parse(
        URLV2 + 'api/delivery_orders?access_token=$token' + Client_Andro));

    if (responseData.statusCode == 200) {
      final data = jsonDecode(responseData.body);
      var array = data["result"];
      var filteredList;
      filteredList = array.where((val) => val["creator"] == nama);
      models = filteredList
          .map<datamodel>((parsedJson) => datamodel.fromJson(parsedJson))
          .toList();
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
        centerTitle: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Scan Surat Jalan",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              "Isi data dengan benar",
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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/home.png'), fit: BoxFit.fill)),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 15, top: 15, right: 15),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 3,
                decoration: kBoxStyle,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nama :",
                      style: textstyle,
                    ),
                    Text(
                      "$nama",
                      style: textstyle2,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "User ID :",
                      style: textstyle,
                    ),
                    Text(
                      "$id",
                      style: textstyle2,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Delivery Number :",
                      style: textstyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              _buildQrView(context);
                              forminput.clear();
                            },
                            icon: Icon(Icons.qr_code)),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 1.4,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            onSaved: (e) => serial = e!,
                            controller: forminput,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1,
                                      color: Colors.grey), //<-- SEE HERE
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                // labelText: "Serial Number",
                                hintText: result,
                                hintStyle: TextStyle(color: Colors.black)),
                            onChanged: (value) {
                              result = value;
                            },
                          ),
                        )
                      ],
                    ),
                    Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 1,
                        margin: EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1760FF)),
                            onPressed: () {
                              print(result);
                              save();
                            },
                            child: Text("Simpan", style: textstyle4))),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text("List Data", style: textstyle2),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Delivery \nNumber",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "Tanggal Input",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "Creator",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Divider(),
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.5,
                child: loading
                    ? CircularProgressIndicator()
                    : StatefulBuilder(
                        builder: (BuildContext context, StateSetter alerState) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height / 0.5,
                            child: ListView.builder(
                                itemCount: models.length,
                                itemBuilder: (context, index) {
                                  String date = models[index].date;
                                  DateFormat oldFormat =
                                      DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
                                  DateFormat newFormat =
                                      DateFormat("yyyy-MM-dd");
                                  DateFormat jamformat = DateFormat("HH:mm");
                                  String dateStr =
                                      newFormat.format(oldFormat.parse(date));
                                  String showjam =
                                      jamformat.format(oldFormat.parse(date));

                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        models[index].deliverynumber,
                                        style: textstyle,
                                      ),
                                      Text(
                                        "$dateStr - $showjam",
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        models[index].name,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
