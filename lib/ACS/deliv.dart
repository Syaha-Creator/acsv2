import 'dart:async';
import 'dart:convert';
import 'package:acsv2/ACS/acc.dart';
import 'package:acsv2/ACS/scanner.dart';
import 'package:acsv2/backend/style.dart';
import 'package:acsv2/backend/url.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Deliv extends StatefulWidget {
  const Deliv({super.key});

  @override
  State<Deliv> createState() => _DelivState();
}

class _DelivState extends State<Deliv> {
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

    getPref();
    show();
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

  Future<void> showdata(String? result) async {
    progressDialog = ProgressDialog(context, type: ProgressDialogType.normal);
    progressDialog!.style(message: 'Mohon Tunggu');
    progressDialog!.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getInt('id')!;
    token = prefs.getString('access_token').toString();

    setState(() {
      loading = true;
    });

    print(URLV2 +
        'api/search_delivery_order?delivery_number=$result&access_token=$token' +
        Client_Andro);
    var responseData = await http.get(Uri.parse(URLV2 +
        'api/search_delivery_order?delivery_number=$result&access_token=$token' +
        Client_Andro));

    if (responseData.statusCode == 200) {
      final data = jsonDecode(responseData.body);
      var array = data["result"];
      int idorder = array[0]["id"];
      print(idorder);
      update(idorder);
      progressDialog!.hide();
      // models = array.map<datamodel>((parsedJson) => datamodel.fromJson(parsedJson))
      //       .toList();
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> show() async {
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

      filteredList = array.where((val) => val["acs_receiver"] == nama);
      models = filteredList
          .map<datamodel>((parsedJson) => datamodel.fromJson(parsedJson))
          .toList();
      setState(() {
        loading = false;
      });
    }
  }

  Future update(int idorder) async {
    DateTime now = DateTime.now();
    progressDialog = ProgressDialog(context, type: ProgressDialogType.normal);
    progressDialog!.style(message: 'Mohon Tunggu');
    progressDialog!.show();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("access_token");
    nama = prefs.getString("name");
    id = prefs.getInt("id");
    area = prefs.getInt("area_id");

    var url = Uri.parse(
        "${URLV2}api/delivery_orders/$idorder?access_token=$token$Client_Andro");
    var request = http.MultipartRequest("PUT", url);
    request.headers["Content-Type"] = 'multipart/form-data';
    request.fields['delivery_order[acs_delivery_number]'] = result!;
    request.fields['delivery_order[acs_receiver]'] = nama!;
    request.fields['delivery_order[acs_receive_date]'] = now.toString();
    request.fields['delivery_order[acs]'] = "true";
    request.fields['delivery_order[acs_id]'] = id.toString();

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
        context, new MaterialPageRoute(builder: (context) => Deliv()));
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
              "Scan Surat Jalan Balik",
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
          margin: EdgeInsets.all(15),
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
                        ),
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
                              showdata(result);
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
                    "Acs",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "Delivery \nNumber",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "Tanggal \nInput",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Divider(),
              Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: loading
                      ? CircularProgressIndicator()
                      : StatefulBuilder(builder:
                          (BuildContext context, StateSetter alerState) {
                          return Container(
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
                                      SizedBox(
                                          width: 70,
                                          child: Text(
                                            models[index].acs,
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          )),
                                      Text(
                                        models[index].deliverynumber,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "$dateStr - $showjam",
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          );
                        }))
            ],
          ),
        ),
      ),
    );
  }
}
