//
//  PrinterService.swift
//  BluetoothTest
//
//  Created by Olajide Osho on 10/12/2023.
//

import Foundation
import CoreBluetooth

/// Bluetooth Low Energy Printer Service for:
/// - Searching and Listing Printers
/// - Connecting to a Printer
/// - Disconnecting from a Printer
/// - Perfoming Different Printing Functions
public class WalureBluetoothPrinterService: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate {

    /// Object Reference to the iOS Bluetooth Core Framework
    internal var centralManager: CBCentralManager?

    /// Object Reference to the Currently Connected Bluetooth Printer
    internal var connectedPeripheral: CBPeripheral?

    /// Discovered Low Energy Bluetooth Devices
    internal var peripheralList: [String: CBPeripheral] = [:]
    internal var deviceList: [String: BluetoothDevice] = [:]

    /// Printer Service Delegate
    internal var delegate: BluetoothPrinterDelegate

    /// Object Reference to Bluetooth Low Energy Printing Functionality
    internal var printCharacteristic: CBCharacteristic?

    /// UUID for Identifying Bluetooth Low Energy Devices with Printing Service
    internal var genericPrintServiceUUIDs: [CBUUID] {
        let ids: [String] = []
        let cbuuids = ids.map { CBUUID(string: $0) }
        return cbuuids
    }

    /// UUID for Identifying Bluetooth Low Energy Devices with Printing Capabilities
    internal var genericPrintCharacteristicUUIDs: [CBUUID] {
        let ids: [String] = []
        let cbuuids = ids.map { CBUUID(string: $0) }
        return cbuuids
    }

    /// Bluetooth Printer Service Constructor
    /// - Parameter delegate: Delegate that will communicate with the Bluetooth Printer Service
    public init(delegate: BluetoothPrinterDelegate) {
        self.delegate = delegate
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        guard let cm = centralManager else { return }

//        if #available(iOS 13.0, *) {
//            cm.registerForConnectionEvents(options: nil)
//        }
    }
}



// MARK: Bluetooth Service Protocols
/// Delegate Protocol to implement for Printer Service Communication
public protocol BluetoothPrinterDelegate {
    func didStartScanning()
    func didStopScanning()
    func didErrorOccur(error: PrinterError)
    func bluetoothStateDidChange(state: BluetoothState)
    func didDiscoverBluetoothDevice(device: BluetoothDevice, isConnectable: Bool)
    func didConnectToDevice(device: BluetoothDevice)
    func didDisconnectFromDevice(deviceId: String)
    func printFunctionDidBecomeReady()
    func getConnectedPeripheral()
}

public extension BluetoothPrinterDelegate {
    func didStartScanning() {}
    func didStopScanning() {}
    func didErrorOccur(error: PrinterError) {}
    func bluetoothStateDidChange(state: BluetoothState) {}
    func didDiscoverBluetoothDevice(device: BluetoothDevice, isConnectable: Bool) {}
    func didConnectToDevice(device: BluetoothDevice) {}
    func didDisconnectFromDevice(deviceId: String) {}
    func printFunctionDidBecomeReady() {}
    func getConnectedPeripheral() {}
}



// MARK: Bluetooth Manager Protocols
extension WalureBluetoothPrinterService {
    public func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {

        let peripheralID = peripheral.identifier.uuidString
        let connectable = true
        let peripheralName = peripheral.name ?? "Device \(peripheralID.prefix(8))"
        let bluetoothPrinter = BluetoothDevice(id: peripheralID, name: peripheralName)
        peripheralList[peripheralID] = peripheral
        deviceList[peripheralID] = bluetoothPrinter
        delegate.didDiscoverBluetoothDevice(device: bluetoothPrinter, isConnectable: connectable)

        switch event {
        case .peerConnected:
            connectedPeripheral = peripheral
            guard let cm = centralManager,
                  cm.state == .poweredOn,
                  let cp = connectedPeripheral else {
                delegate.didErrorOccur(error: .ConnectError(peripheral.identifier.uuidString))
                return
            }
            cp.delegate = self
            cm.connect(cp, options: nil)
            if #available(iOS 13.0, *) {
                cm.registerForConnectionEvents()
            }
        case .peerDisconnected:
            guard let cm = centralManager,
                    cm.state == .poweredOn,
                    let cp = connectedPeripheral else {
                delegate.didErrorOccur(
                    error: .DisconnectError(connectedPeripheral?.identifier.uuidString ?? "Unknown Device ID")
                )
                return
            }
            cm.cancelPeripheralConnection(cp)
        default:
            break
        }
    }

    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        guard let cm = centralManager else {
            delegate.didErrorOccur(error: .ServiceError)
            return
        }

        switch cm.state {
        case .poweredOn:
            delegate.bluetoothStateDidChange(state: .poweredOn)
        case .poweredOff:
            delegate.bluetoothStateDidChange(state: .poweredOff)
        case .unauthorized:
            delegate.bluetoothStateDidChange(state: .unauthorized)
        case .resetting:
            delegate.bluetoothStateDidChange(state: .resetting)
        case .unknown:
            delegate.bluetoothStateDidChange(state: .unknown)
        case .unsupported:
            delegate.bluetoothStateDidChange(state: .unsupported)
        default:
            break
        }
    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let peripheralID = peripheral.identifier.uuidString
        let connectable = ((advertisementData[CBAdvertisementDataIsConnectable] as? Int) ?? 0) == 1
        let peripheralName = peripheral.name
        ?? advertisementData[CBAdvertisementDataLocalNameKey] as? String
        ?? "Device \(peripheralID.prefix(8))"

        let bluetoothDevice = BluetoothDevice(id: peripheralID, name: peripheralName)
        peripheralList[peripheralID] = peripheral
        deviceList[peripheralID] = bluetoothDevice
        delegate.didDiscoverBluetoothDevice(device: bluetoothDevice, isConnectable: connectable)
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        guard let cp = self.connectedPeripheral else {
            delegate.didErrorOccur(error: .ConnectError(peripheral.identifier.uuidString))
            return
        }

        if peripheral == cp,
           let device = deviceList.map({ $0.value }).first(where: {$0.id == peripheral.identifier.uuidString}) {
            delegate.didConnectToDevice(device: device)
            cp.discoverServices(nil)
        }
    }

    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        delegate.didErrorOccur(error: .ConnectError(peripheral.identifier.uuidString))
        connectedPeripheral = nil
        printCharacteristic = nil
        guard error != nil else {
            return
        }
    }

    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        delegate.didDisconnectFromDevice(deviceId: peripheral.identifier.uuidString)
        connectedPeripheral = nil
        printCharacteristic = nil
        guard error != nil else {
            return
        }
    }
}



// MARK: Bluetooth Peripheral Protocols
extension WalureBluetoothPrinterService {
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard printCharacteristic == nil else { return }
        guard let printChar = service.characteristics?.first(
            where: { $0.properties.contains(.write) || $0.properties.contains(.writeWithoutResponse) }
        ) else {
            delegate.didErrorOccur(error: .NoPrintFunction)
            return
        }
        printCharacteristic = printChar
        delegate.printFunctionDidBecomeReady()
    }
}

