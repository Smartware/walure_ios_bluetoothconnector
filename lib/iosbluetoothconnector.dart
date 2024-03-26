import 'package:walure_ios_bluetoothconnector/model/bluetoothdevice_model.dart';

import 'iosbluetoothconnector_platform_interface.dart';

class Iosbluetoothconnector {
  Future<String?> getPlatformVersion() {
    return IosbluetoothconnectorPlatform.instance.getPlatformVersion();
  }

  Future<String?> scanBluetooth() {
    return IosbluetoothconnectorPlatform.instance.startScanningBluetooth();
  }

  Future<String?> stopScanning() {
    return IosbluetoothconnectorPlatform.instance.stopScanning();
  }

  Future<List<BluetoothDeviceModel>?> getDiscoveredDevices() {
    return IosbluetoothconnectorPlatform.instance.getDiscoveredDevices();
  }

  Future<List<dynamic>?> getUpdatedDevices() {
    return IosbluetoothconnectorPlatform.instance.getUpdatedDevices();
  }

  Future<String?> connect(bluetoothId) {
    return IosbluetoothconnectorPlatform.instance.connect(bluetoothId);
  }

  Future<String?> disconnect() {
    return IosbluetoothconnectorPlatform.instance.disconnect();
  }

  getConnectedDevice() {
    return IosbluetoothconnectorPlatform.instance.getConnectedDevice();
  }

  Future<String?> initializePrinter() {
    return IosbluetoothconnectorPlatform.instance.initializePrinter();
  }

  Future<String?> printLine(text) {
    return IosbluetoothconnectorPlatform.instance.printLine(text);
  }

  Future<String?> printToBuffer() {
    return IosbluetoothconnectorPlatform.instance.printToBuffer();
  }

  Future<String?> printTab() {
    return IosbluetoothconnectorPlatform.instance.printTab();
  }

  Future<String?> printLineFeed() {
    return IosbluetoothconnectorPlatform.instance.printLineFeed();
  }

  Future<String?> carriageReturn() {
    return IosbluetoothconnectorPlatform.instance.carriageReturn();
  }

  Future<String?> printBarcodeFromText(text) {
    return IosbluetoothconnectorPlatform.instance.printBarcodeFromText(text);
  }

  Future<String?> printImage(imagePath) {
    return IosbluetoothconnectorPlatform.instance.printImage(imagePath);
  }

  Future<String?> setLineSpacing(number) {
    return IosbluetoothconnectorPlatform.instance.setLineSpacing(number);
  }

  Future<String?> printBufferAndFeed(number) {
    return IosbluetoothconnectorPlatform.instance.printBufferAndFeed(number);
  }
}
