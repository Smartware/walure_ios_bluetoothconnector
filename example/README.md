# iosbluetoothconnector_example


## Getting Started

Installation
Run the bellow command in the root directory of your flutter project.

flutter pub add iosbluetoothconnector

## USAGE
Initialization

     class MyApp extends StatefulWidget {
       const MyApp({Key? key}) : super(key: key);

        @override
        State<MyApp> createState() => _MyAppState();
          }
     class _MyAppState extends State<MyApp> {

    final _iosbluetoothconnectorPlugin = Iosbluetoothconnector();
    List<dynamic> bluetoothList = [];
    List connectedBluetoothList = [];
    bool isConnected = false;
  
      @override
       void initState() {
        super.initState();
         getUpdatedList();
         Timer.periodic(const Duration(seconds: 5), (Timer t) => getUpdatedList());
        }

      getUpdatedList() async {
      var res = await _iosbluetoothconnectorPlugin.getUpdatedDevices();
      setState(() {
       bluetoothList = res!;
       });
       }

     @override
     Widget build(BuildContext context) {
        return  MaterialApp(
        home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
            
              InkWell(
                onTap: () async {
                  var res = await _iosbluetoothconnectorPlugin.scanBluetooth();
                  print("I want to start scanning...   $res");
                  //list of devices here...
                },
                child: Widget
              ),
              InkWell(
                  onTap: () {
                    _iosbluetoothconnectorPlugin.printImage('ImagePath');
                  },
                  child: Widget),
            
              InkWell(
                onTap: () {
                  _iosbluetoothconnectorPlugin.stopScanning();
                  print("I want to stop scanning...");
                },
                child:Widget ),
            ],
          ),
        ),
      ),
    );

      }
    }



## To Scan  
_iosbluetoothconnectorPlugin.scanBluetooth();

## To Connect 
 _iosbluetoothconnectorPlugin.connect("bluetoothId);

## To Disconnect 
 _iosbluetoothconnectorPlugin.disconnect("bluetoothId);

## To PrintImage
   _iosbluetoothconnectorPlugin.printImage('ImagePath');

## To stopScanning
   _iosbluetoothconnectorPlugin.stopScanning();



