import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:walure_ios_bluetoothconnector/model/bluetoothdevice_model.dart';

import 'iosbluetoothconnector_method_channel.dart';

abstract class IosbluetoothconnectorPlatform extends PlatformInterface {
  /// Constructs a IosbluetoothconnectorPlatform.
  IosbluetoothconnectorPlatform() : super(token: _token);

  static final Object _token = Object();

  static IosbluetoothconnectorPlatform _instance =
      MethodChannelIosbluetoothconnector();

  /// The default instance of [IosbluetoothconnectorPlatform] to use.
  ///
  /// Defaults to [MethodChannelIosbluetoothconnector].
  static IosbluetoothconnectorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [IosbluetoothconnectorPlatform] when
  /// they register themselves.
  static set instance(IosbluetoothconnectorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> startScanningBluetooth() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> stopScanning() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<List<BluetoothDeviceModel>?> getDiscoveredDevices() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<List<dynamic>?> getUpdatedDevices() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> connect(bluetoothId) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> disconnect() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  getConnectedDevice() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> initializePrinter() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> printLine(text) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> printToBuffer() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> printTab() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> printLineFeed() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> carriageReturn() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> printBufferAndFeed(number) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> setLineSpacing(number) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> printImage(imagePath) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> printBarcodeFromText(text) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
