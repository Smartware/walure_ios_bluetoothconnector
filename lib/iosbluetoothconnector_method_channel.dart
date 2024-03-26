import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:walure_ios_bluetoothconnector/model/bluetoothdevice_model.dart';
import 'iosbluetoothconnector_platform_interface.dart';

/// An implementation of [IosbluetoothconnectorPlatform] that uses method channels.
class MethodChannelIosbluetoothconnector extends IosbluetoothconnectorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('iosbluetoothconnector');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> startScanningBluetooth() async {
    final res =
        await methodChannel.invokeMethod<String>('startScanningBluetooth');
    return res;
  }

  @override
  Future<String?> stopScanning() async {
    final res = await methodChannel.invokeMethod<String>('stopScanning');
    return res;
  }

  @override
  Future<List<BluetoothDeviceModel>?> getDiscoveredDevices() async {
    final res = await methodChannel
        .invokeMethod<List<BluetoothDeviceModel>?>('getDiscoveredDevices');
    return res;
  }

  @override
  Future<List<dynamic>?> getUpdatedDevices() async {
    final res =
        await methodChannel.invokeMethod<List<dynamic>>('getUpdatedDevices');
    return res;
  }

  @override
  Future<String?> connect(bluetoothId) async {
    final res = await methodChannel.invokeMethod<String>(
      "connect",
      {"bluetoothId": bluetoothId},
    );
    return res;
    // await methodChannel.invokeMethod<String>('$bluetoothId');
  }

  @override
  Future<String?> disconnect() async {
    final res = await methodChannel.invokeMethod<String>('disconnect');
    return res;
  }

  @override
  getConnectedDevice() async {
    final res = await methodChannel
        .invokeMethod<List<BluetoothDeviceModel>?>('getConnectedDevice');
    return res;
  }

  @override
  Future<String?> initializePrinter() async {
    final res = await methodChannel.invokeMethod<String>('initializePrinter');
    return res;
  }

  @override
  Future<String?> printLine(text) async {
    final res = await methodChannel.invokeMethod<String>(
      'printLine',
      {"text": text},
    );
    return res;
  }

  @override
  Future<String?> printBarcodeFromText(text) async {
    final res = await methodChannel.invokeMethod<String>(
      'printBarcodeFromText',
      {"text": text},
    );
    return res;
  }

  @override
  Future<String?> printImage(imagePath) async {
    final res = await methodChannel.invokeMethod<String>(
      'printImage',
      {"imagePath": imagePath},
    );
    return res;
  }

  @override
  Future<String?> setLineSpacing(number) async {
    final res = await methodChannel.invokeMethod<String>(
      'setLineSpacing',
      {"number": number},
    );
    return res;
  }

  @override
  Future<String?> carriageReturn() async {
    final res = await methodChannel.invokeMethod<String>('carriageReturn');
    return res;
  }

  // @override
  // Future<String?> printBufferAndFeed(text) async {
  //   final res = await methodChannel.invokeMethod<String>(
  //     'printBufferAndFeed',
  //     {"text": text},
  //   );
  //   return res;
  // }

  @override
  Future<String?> printToBuffer() async {
    final res = await methodChannel.invokeMethod<String>('printToBuffer');
    return res;
  }

  @override
  Future<String?> printTab() async {
    final res = await methodChannel.invokeMethod<String>('printTab');
    return res;
  }

  @override
  Future<String?> printLineFeed() async {
    final res = await methodChannel.invokeMethod<String>('printLineFeed');
    return res;
  }

  @override
  Future<String?> printBufferAndFeed(number) async {
    final res = await methodChannel.invokeMethod<String>(
      'printBufferAndFeed',
      {"number": number},
    );
    return res;
  }
}
