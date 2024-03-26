import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:iosbluetoothconnector/iosbluetoothconnector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _iosbluetoothconnectorPlugin = Iosbluetoothconnector();
  List<dynamic> bluetoothList = [];
  List connectedBluetoothList = [];
  bool isConnected = false;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    getUpdatedList();
    Timer.periodic(const Duration(seconds: 5), (Timer t) => getUpdatedList());
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _iosbluetoothconnectorPlugin.getPlatformVersion() ??
              'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  getUpdatedList() async {
    var res = await _iosbluetoothconnectorPlugin.getUpdatedDevices();
    setState(() {
      bluetoothList = res!;
    });
  }

  TextEditingController userInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text('Running on: $_platformVersion\n'),
              ),
              InkWell(
                onTap: () async {
                  var res = await _iosbluetoothconnectorPlugin.scanBluetooth();
                  print("I want to start scanning...   $res");

                  //list of devices here...
                },
                child: Container(
                  height: 100,
                  width: 200,
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: const Text('Scan Bluetooth'),
                ),
              ),
              const SizedBox(height: 20),
              // InkWell(
              //   onTap: () async {
              //     print("I want to see all list... ... ");
              //     var res =
              //         await _iosbluetoothconnectorPlugin.getUpdatedDevices();

              //     setState(() {
              //       bluetoothList = res!;
              //     });
              //     print("I want to see all list... $res ");
              //     print("I want to see all list... ${bluetoothList[0][0]}");

              //     //list of devices here...
              //   },
              //   child: Container(
              //     height: 100,
              //     width: 200,
              //     decoration: const BoxDecoration(color: Colors.orange),
              //     child: const Text('get updated list'),
              //   ),
              // ),
              // const SizedBox(height: 20),

              //The list
              Container(
                height: 150,
                child: ListView.builder(
                    itemCount: bluetoothList.length,
                    itemBuilder: (cxt, i) {
                      print(bluetoothList[i]);
                      String deviceId = bluetoothList[i][0];
                      bool isConnected =
                          connectedBluetoothList.contains(deviceId);

                      return Column(
                        children: [
                          Container(
                              height: 40,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    bluetoothList[i][1].toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      var res =
                                          await _iosbluetoothconnectorPlugin
                                              .connect(bluetoothList[i][0]);
                                      print(bluetoothList[i][0]);
                                      print("trying to connect?  $res");
                                      if (res == "Connected") {
                                        setState(() {
                                          connectedBluetoothList
                                              .add(bluetoothList[i][0]);
                                        });
                                        print("$res");
                                      }
                                    },
                                    child: !isConnected
                                        ? const Text(
                                            "Connect",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        : InkWell(
                                            onTap: () async {
                                              var res =
                                                  await _iosbluetoothconnectorPlugin
                                                      .disconnect();
                                              print(
                                                  "I want to disconnect from bluetooth...");

                                              if (res == "Disconnected") {
                                                setState(() {
                                                  connectedBluetoothList.remove(
                                                      bluetoothList[i][0]);
                                                });
                                                print(res);
                                              }
                                            },
                                            child: const Text(
                                              "Disconnect",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                  ),
                                ],
                              )),
                          const SizedBox(height: 10),
                        ],
                      );
                    }),
              ),

              InkWell(
                  onTap: () {
                    _iosbluetoothconnectorPlugin.printImage('w.sks');
                  },
                  child: Text("Print Image")),
              Container(
                  height: 50,
                  width: 300,
                  child: TextFormField(
                    controller: userInputController,
                  )),
              InkWell(
                onTap: () {
                  _iosbluetoothconnectorPlugin
                      .printLine(userInputController.text);

                  print("start printing....");
                },
                child: Container(
                  height: 100,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(12)),
                  child: const Text('Print'),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  _iosbluetoothconnectorPlugin.stopScanning();
                  print("I want to stop scanning...");
                },
                child: Container(
                  height: 100,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12)),
                  child: const Text('Stop Scanning'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
