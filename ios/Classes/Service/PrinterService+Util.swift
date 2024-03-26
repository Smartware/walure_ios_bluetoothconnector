//
//  PrinterService+Util.swift
//  BluetoothTest
//
//  Created by Olajide Osho on 10/12/2023.
//

import Foundation
import CoreBluetooth

extension WalureBluetoothPrinterService {
    /// Function to Start Scanning for Nearby Bluetooth Low Energy Printers
    public func startScanning() {
        guard let cm = centralManager, cm.state == .poweredOn else {
            delegate.didErrorOccur(error: .StartScanError)
            return
        }
        cm.scanForPeripherals(
            withServices: nil,
            options: [
                CBCentralManagerScanOptionAllowDuplicatesKey: true
            ]
        )
        delegate.didStartScanning()
    }

    /// Function to Stop Scanning for Nearby Bluetooth Low Energy Printers
    public func stopScanning() {
        guard let cm = centralManager, cm.state == .poweredOn else {
            delegate.didErrorOccur(error: .StopScanError)
            return
        }
        cm.stopScan()
        delegate.didStopScanning()
    }

    /// Function to Fetch List of Discovered Devices
    /// - Returns: A List of BluetoothPrinter
    public func getDiscoveredDevices() -> [BluetoothDevice] {
        return self.deviceList.map { $0.value }
    }

    /// Function to connect to a Printer via its corresponding Dynamic ID assigned during Discpvery
    /// - Parameter id: Blueetooth Printer ID
    public func connect(toDevice id: String) {
        guard let device = self.peripheralList[id] else {
            delegate.didErrorOccur(error: .DeviceNotFound)
            return
        }
        connectedPeripheral = device
        guard let cm = centralManager,
                cm.state == .poweredOn,
                let cp = connectedPeripheral else {
            delegate.didErrorOccur(error: .ConnectError(id))
            return
        }
        cp.delegate = self
        cm.connect(cp, options: nil)
    }

    /// Function to disconnect from currently connected Printer
    public func disconnect() {
        guard let cm = centralManager,
                cm.state == .poweredOn,
                let cp = connectedPeripheral else {
            delegate.didErrorOccur(
                error: .DisconnectError(connectedPeripheral?.identifier.uuidString ?? "Unknown Device ID")
            )
            return
        }
        cm.cancelPeripheralConnection(cp)
    }

    public func getConnectedDevice() {
        guard let cm = centralManager,
                cm.state == .poweredOn else {
            delegate.didErrorOccur(
                error: .DisconnectError(connectedPeripheral?.identifier.uuidString ?? "Unknown Device ID")
            )
            return
        }

        guard let cp = cm.retrieveConnectedPeripherals(withServices: []).first else {
            delegate.didErrorOccur(
                error: .DisconnectError("Classic Device ID")
            )
            return
        }

        let peripheralID = cp.identifier.uuidString
        let connectable = true
        let peripheralName = cp.name ?? "Device \(peripheralID.prefix(8))"
        let bluetoothPrinter = BluetoothDevice(id: peripheralID, name: peripheralName)
        peripheralList[peripheralID] = cp
        deviceList[peripheralID] = bluetoothPrinter
        delegate.didDiscoverBluetoothDevice(device: bluetoothPrinter, isConnectable: connectable)
    }
}
