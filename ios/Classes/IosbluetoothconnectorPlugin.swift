import Flutter
import UIKit


public class IosbluetoothconnectorPlugin: NSObject, FlutterPlugin, BluetoothPrinterDelegate {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "iosbluetoothconnector", binaryMessenger: registrar.messenger())
    let instance = IosbluetoothconnectorPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
     
  }

    var deviceList: [String: BluetoothDevice] = [:]
    var tableData: [BluetoothDevice] = []
    var adaptedData: [[String]] = []
    var selectedDeviceId = ""
    var isConnect = ""
    lazy var wb: WalureBluetoothPrinterService = {
        return WalureBluetoothPrinterService(delegate: self)
    }()
   

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult)  {

    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)

    case "startScanningBluetooth":
        wb.startScanning()
        result("Started Scanning")

    case "stopScanning":
         wb.stopScanning()
        result("Stopped Scanning")
        
    case "getDiscoveredDevices":
        let res = wb.getDiscoveredDevices()
        result(res)
         
     case "getUpdatedDevices":
        result(adaptedData)

     case "connect":
     if let arguments = call.arguments as? [String: Any],
         let bluetoothId = arguments["bluetoothId"] as? String {
        print("Received bluetooth Id: \(bluetoothId)");
        wb.connect(toDevice: bluetoothId);
        print(isConnect);
        result(isConnect)
         }

    case "disconnect":
         wb.disconnect()
        result("Disconnected")

    case "getConnectedDevice":
        wb.getConnectedDevice()
        

    case "initializePrinter":
        wb.initializePrinter()
        result("Initializing")


  case "printLine":
     if let arguments = call.arguments as? [String: Any],
         let text = arguments["text"] as? String {
        print("I am printing this line: \(text)");
        wb.printLine(line: text);
        result("Printing...")
        }

    case "printBarcodeFromText":
     if let arguments = call.arguments as? [String: Any],
         let text = arguments["text"] as? String {
        print("I am printing barCode: \(text)");
        wb.printBarcodeFromText(text: text);
        result("Printing Bar Code...")
        }

    case "printImage":
     if let arguments = call.arguments as? [String: Any],
         let imagePath = arguments["imagePath"] as? String {
        print("I am printing image: \(imagePath)");
        wb.printImage(image: imagePath, printHead: 4);
        result("Printing...")
        }

    case "setLineSpacing":
     if let arguments = call.arguments as? [Int: Any],
         let number = arguments["number"] as? Int {
        print("I am printing image: \(number)");
        wb.setLineSpacing(numberOfDots: number);
        result("Printing...")
        }

    case "printBufferAndFeed":
     if let arguments = call.arguments as? [Int: Any],
         let number = arguments["number"] as? Int {
        print("I am printing image: \(number)");
        wb.printBufferAndFeed(numberOfLines: number);
        result("Printing...")
        }

    case "carriageReturn":
        wb.carriageReturn()
        result("carriageReturn")
    
    case "printLineFeed":
        wb.printLineFeed()
        result("printLineFeed")
      
    case "printTab":
        wb.printTab()
        result("printTab")

    case "printToBuffer":
     if let arguments = call.arguments as? [String: Any],
         let text = arguments["text"] as? String {
        print("I am printing this line: \(text)");
        wb.printToBuffer(line: text);
        result("Printing...")
        }

      
    default:
      result(FlutterMethodNotImplemented)
    }
  }
    
    public func didDiscoverBluetoothDevice(device: BluetoothDevice, isConnectable: Bool) {
       if isConnectable {
            if deviceList[device.id] != nil {
                deviceList[device.id] = nil
            }
            deviceList[device.id] = device
            tableData = deviceList.map({ $0.value })
            tableData = tableData.sorted(by: {$0.name > $1.name})
            adaptedData = tableData.map{ [$0.id, $0.name]} 
        }
        
        print(adaptedData)
      
    }

    public func didStartScanning() {
        print("Pluging scannig started")
        print("Pluging scannig started")
        print("Pluging scannig started")

  }
    public func didConnectToDevice(device: BluetoothDevice) {
      isConnect = "Connected"
      print("connected")
      print("connected")
      print("connected")
     
    }
}
