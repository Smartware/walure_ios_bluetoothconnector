//
//  PrintHead.swift
//  BluetoothTest
//
//  Created by Olajide Osho on 10/12/2023.
//

import Foundation

/// Different sizes of the Printer Head (Check Manual/Specifications)
public enum PrintHead {
    case mm58
    case mm80

    var imageWidth: CGFloat {
        switch self {
        case .mm58:
            return 430
        case .mm80:
            return 593
        }
    }

    var imageHorizontalByteLength: Int {
        switch self {
        case .mm58:
            return 128
        case .mm80:
            return 64
        }
    }

    var imageHorizontalByteDivisible: Int {
        switch self {
        case .mm58:
            return 1
        case .mm80:
            return 2
        }
    }
}
