//
//  PrinterError.swift
//  BluetoothTest
//
//  Created by Olajide Osho on 10/12/2023.
//

import Foundation

/// Bluetooth Process Errors
public enum PrinterError: Error {
    case StartScanError
    case StopScanError
    case DeviceNotFound
    case ConnectError(_ deviceId: String)
    case DisconnectError(_ deviceId: String)
    case ServiceError
    case PrintError(_ message: String)
    case NoPrintFunction
}
