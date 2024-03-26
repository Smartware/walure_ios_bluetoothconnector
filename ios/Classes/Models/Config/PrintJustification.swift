//
//  PrintJustification.swift
//  BluetoothTest
//
//  Created by Olajide Osho on 10/12/2023.
//

import Foundation

/// Different Justification Values that can be used to set Printer's Text Alignment
public enum PrintJustification {
    case left
    case right
    case center

    var hexValue: Int {
        switch self {
        case .left:
            return 0
        case .center:
            return 1
        case .right:
            return 2
        }
    }
}
