//
//  BluetoothState.swift
//  BluetoothTest
//
//  Created by Olajide Osho on 10/12/2023.
//

import Foundation

/// Bluetooth State of Service Host Device
public enum BluetoothState {
    case poweredOn
    case poweredOff
    case unauthorized
    case resetting
    case unknown
    case unsupported
}
