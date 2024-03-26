//
//  PrintMode.swift
//  BluetoothTest
//
//  Created by Olajide Osho on 10/12/2023.
//

import Foundation

/// Different Print Modes that can be used to set different Font Styles
public enum PrintMode {
    case normal
    case alternateFont
    case bold
    case doubleHeight
    case doubleWidth
    case italics
    case underline

    var hexValue: Int {
        switch self {
        case .normal:
            return 0
        case .alternateFont:
            return 1
        case .bold:
            return 8
        case .doubleHeight:
            return 16
        case .doubleWidth:
            return 32
        case .italics:
            return 64
        case .underline:
            return 128
        }
    }
}
