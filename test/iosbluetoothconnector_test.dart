import 'package:flutter_test/flutter_test.dart';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:walure_ios_bluetoothconnector/iosbluetoothconnector.dart';
import 'package:walure_ios_bluetoothconnector/iosbluetoothconnector_method_channel.dart';
import 'package:walure_ios_bluetoothconnector/iosbluetoothconnector_platform_interface.dart';
import 'package:walure_ios_bluetoothconnector/model/bluetoothdevice_model.dart';

class MockIosbluetoothconnectorPlatform
    with MockPlatformInterfaceMixin
    implements IosbluetoothconnectorPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> carriageReturn() {
    // TODO: implement carriageReturn
    throw UnimplementedError();
  }

  @override
  Future<String> connect(bluetoothId) {
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  Future<String?> disconnect() {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  Future<List<BluetoothDeviceModel>?> getConnectedDevice() {
    // TODO: implement getConnectedDevice
    throw UnimplementedError();
  }

  @override
  Future<List<BluetoothDeviceModel>?> getDiscoveredDevices() {
    // TODO: implement getDiscoveredDevices
    throw UnimplementedError();
  }

  @override
  Future<String?> initializePrinter() {
    // TODO: implement initializePrinter
    throw UnimplementedError();
  }

  @override
  Future<String?> printBufferAndFeed(number) {
    // TODO: implement printBufferAndFeed
    throw UnimplementedError();
  }

  @override
  Future<String?> printLine(text) {
    // TODO: implement printLine
    throw UnimplementedError();
  }

  @override
  Future<String?> printLineFeed() {
    // TODO: implement printLineFeed
    throw UnimplementedError();
  }

  @override
  Future<String?> printTab() {
    // TODO: implement printTab
    throw UnimplementedError();
  }

  @override
  Future<String?> printToBuffer() {
    // TODO: implement printToBuffer
    throw UnimplementedError();
  }

  @override
  Future<String?> startScanningBluetooth() {
    // TODO: implement startScanningBluetooth
    throw UnimplementedError();
  }

  @override
  Future<String?> stopScanning() {
    // TODO: implement stopScanning
    throw UnimplementedError();
  }

  @override
  Future<List<dynamic>> getUpdatedDevices() {
    // TODO: implement getUpdatedDevices
    throw UnimplementedError();
  }

  @override
  Future<String?> printImage(text) {
    // TODO: implement printImage
    throw UnimplementedError();
  }

  @override
  Future<String?> printBarcodeFromText(text) {
    // TODO: implement printBarcodeFromText
    throw UnimplementedError();
  }

  @override
  Future<String?> setLineSpacing(number) {
    // TODO: implement setLineSpacing
    throw UnimplementedError();
  }
}

void main() {
  final IosbluetoothconnectorPlatform initialPlatform =
      IosbluetoothconnectorPlatform.instance;

  test('$MethodChannelIosbluetoothconnector is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelIosbluetoothconnector>());
  });

  test('getPlatformVersion', () async {
    Iosbluetoothconnector iosbluetoothconnectorPlugin = Iosbluetoothconnector();
    MockIosbluetoothconnectorPlatform fakePlatform =
        MockIosbluetoothconnectorPlatform();
    IosbluetoothconnectorPlatform.instance = fakePlatform;

    expect(await iosbluetoothconnectorPlugin.getPlatformVersion(), '42');
  });
}
