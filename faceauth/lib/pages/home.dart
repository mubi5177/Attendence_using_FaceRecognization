import 'dart:convert';

import 'package:face_net_authentication/pages/checkout.dart';
import 'package:face_net_authentication/pages/sign-in.dart';
import 'package:face_net_authentication/pages/sign-up.dart';
import 'package:face_net_authentication/pages/widgets/const.dart';
import 'package:face_net_authentication/services/facenet.service.dart';
import 'package:face_net_authentication/services/ml_kit_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  // Services injection
  FaceNetService _faceNetService = FaceNetService();
  MLKitService _mlKitService = MLKitService();
  // DataBaseService _dataBaseService = DataBaseService();
  CameraDescription cameraDescription;
  bool loading = false;
  List imagess;
  @override
  void initState() {
    super.initState();
    _startUp();
  }
  /// 1 Obtain a list of the available cameras on the device.
  /// 2 loads the face net model
  _startUp() async {
    _setLoading(true);
    List<CameraDescription> cameras = await availableCameras();
    /// takes the front camera
    cameraDescription = cameras.firstWhere(
      (CameraDescription camera) =>
          camera.lensDirection == CameraLensDirection.front,
    );
    // start the services
    await _faceNetService.loadModel();
    // await _dataBaseService.loadDB();
    _mlKitService.initialize();
    _setLoading(false);
  }
  // shows or hides the circular progress indicator
  _setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFC7FFBE),
      appBar: AppBar(
        leading: Container(),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
  IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => SignUp(
                                    cameraDescription: cameraDescription,
                                  ),
                                ),
                              );
                            },
                            icon: 
                            Icon(Icons.person_add,color: Color(0xFF0F0BDB))
                          ),
        ],
      ),
      body: !loading
          ? SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right:8.0),
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.end,
                        children:[
                        ]
                      ),
                    ),
                    Image(image: AssetImage('assets/logo.png')),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        children: [
                          Text(
                            "FACE RECOGNITION AUTHENTICATION",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            buildEmployeeData();
                              // DateFormat formatter = DateFormat('yyyy-MM-dd');
                            // print("Images are: $formatter");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => SignIn(
                                  cameraDescription: cameraDescription,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.1),
                                  blurRadius: 1,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Check In',
                                  style: TextStyle(color: Color(0xFF0F0BDB)),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.login, color: Color(0xFF0F0BDB))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                            InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => CheckOut(
                                  cameraDescription: cameraDescription,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top:10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.1),
                                    blurRadius: 1,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 16),
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                               Text(
                                  'Check Out',
                                  style: TextStyle(color: Color(0xFF0F0BDB)),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.logout, color: Color(0xFF0F0BDB))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
  buildEmployeeData() async {
     dataImages = [];
    var response = await http
        .get(Uri.parse("https://mapro.einnovention.tech/api/employeeData"));
    print("Response is :${response.body}");
    if (response.statusCode == 200) {
      List dataaaaa = json.decode(response.body)['data'];
      dataaaaa.forEach((e) {
        dataImages.add({
          "id": "${e['id']}",
          "name": "${e['Employee_Name']}",
          "image_data": json.decode(e['imagedata']['imageData']),
        });
      });
      print("Dataa is: ${json.encode(dataImages)}");
      ;
    }
  }
}

 
















