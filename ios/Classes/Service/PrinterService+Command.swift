//
//  PrinterService+Command.swift
//  BluetoothTest
//
//  Created by Olajide Osho on 10/12/2023.
//

import Foundation
import UIKit

extension WalureBluetoothPrinterService {
    /// Function to Reset the Printer
    public func initializePrinter() {
        guard let printer = connectedPeripheral,
              let characteristic = printCharacteristic else {
            delegate.didErrorOccur(error: .PrintError("Could not Initialize Printer"))
            return
        }

        let commandHex = [0x1b, 0x40]
        let commandData = Helper.commandHexToData(commandHex: commandHex)

        printer.writeValue(commandData, for: characteristic, type: .withoutResponse)
    }

    /// Function to Print a Line of text followed by a Line Feed
    /// - Parameter line: Text to be printed
    public func printLine(line: String) {
        guard let printer = connectedPeripheral,
              let characteristic = printCharacteristic,
              let printData = line.data(using: .utf8) else {
            delegate.didErrorOccur(error: .PrintError("Could not print to buffer with line feed"))
            return
        }

        let newLine = Helper.hexToData(hexValue: "0A") ?? Data()

        printer.writeValue(printData, for: characteristic, type: .withoutResponse)
        printer.writeValue(newLine, for: characteristic, type: .withoutResponse)
    }

    /// Function to Print a Line without Line Feed
    /// - Parameter line: Text to be printed
    public func printToBuffer(line: String) {
        guard let printer = connectedPeripheral,
              let characteristic = printCharacteristic,
              let printData = line.data(using: .utf8) else {
            delegate.didErrorOccur(error: .PrintError("Could not send data to Print Buffer"))
            return
        }

        printer.writeValue(printData, for: characteristic, type: .withoutResponse)
    }

    /// Function to Print a Line Tab
    public func printTab() {
        guard let printer = connectedPeripheral,
              let characteristic = printCharacteristic else {
            delegate.didErrorOccur(error: .PrintError("Could not print tab"))
            return
        }

        let tabFeed = Helper.hexToData(hexValue: "09") ?? Data()

        printer.writeValue(tabFeed, for: characteristic, type: .withoutResponse)
    }

    /// Function to Print a Line Feed
    public func printLineFeed() {
        guard let printer = connectedPeripheral,
              let characteristic = printCharacteristic else {
            delegate.didErrorOccur(error: .PrintError("Could not print Line Feed"))
            return
        }

        let lineFeed = Helper.hexToData(hexValue: "0A") ?? Data()

        printer.writeValue(lineFeed, for: characteristic, type: .withoutResponse)
    }

    /// Function to Print a Carriage Return
    public func carriageReturn() {
        guard let printer = connectedPeripheral,
              let characteristic = printCharacteristic else {
            delegate.didErrorOccur(error: .PrintError("Could not print Carriage Return"))
            return
        }

        let carriageReturn = Helper.hexToData(hexValue: "0D") ?? Data()

        printer.writeValue(carriageReturn, for: characteristic, type: .withoutResponse)
    }

    /// Function to Print whatever data is present in the connected printer's buffer
    /// with a specified number of Line Feeds measured in Dots
    /// - Parameter numberOfDots: Line Feed amount in Dots
    public func printBufferAndFeed(numberOfDots: Int) {
        guard numberOfDots < 256 && numberOfDots > -1 else {
            delegate.didErrorOccur(error: .PrintError("Invalid Number of Dots"))
            return
        }
        guard let printer = connectedPeripheral,
              let characteristic = printCharacteristic else {
            delegate.didErrorOccur(error: .PrintError("Could not send data to Buffer and print \(numberOfDots) Dots"))
            return
        }

        let commandHex = [0x1b, 0x4a, numberOfDots]
        let commandData = Helper.commandHexToData(commandHex: commandHex)

        printer.writeValue(commandData, for: characteristic, type: .withoutResponse)
    }

    /// Function to Print whatever data is present in the connected printer's buffer
    /// with a specified number of Line Feeds based on set Line Spacing
    /// - Parameter numberOfDots: Line Feed amount
    public func printBufferAndFeed(numberOfLines: Int) {
        guard numberOfLines < 256 && numberOfLines > -1 else {
            delegate.didErrorOccur(error: .PrintError("Invalid Number of Lines"))
            return
        }
        guard let printer = connectedPeripheral,
              let characteristic = printCharacteristic else {
            delegate.didErrorOccur(error: .PrintError("Could not send data to Buffer and print \(numberOfLines) Line Feeds"))
            return
        }

        let commandHex = [0x1b, 0x64, numberOfLines]
        let commandData = Helper.commandHexToData(commandHex: commandHex)

        printer.writeValue(commandData, for: characteristic, type: .withoutResponse)
    }

    /// Function to Set the Line Spacing
    /// - Parameter numberOfDots: Value in Dots of which Space Between Feeds should be
    public func setLineSpacing(numberOfDots: Int) {
        guard numberOfDots < 256 && numberOfDots > -1 else {
            delegate.didErrorOccur(error: .PrintError("Invalid Number of Dots"))
            return
        }
        guard let printer = connectedPeripheral,
              let characteristic = printCharacteristic else {
            delegate.didErrorOccur(error: .PrintError("Could not set Line Spacing to \(numberOfDots) Dots"))
            return
        }

        let commandHex = [0x1b, 0x33, numberOfDots]
        let commandData = Helper.commandHexToData(commandHex: commandHex)

        printer.writeValue(commandData, for: characteristic, type: .withoutResponse)
    }

    /// Function to Reset Line Spacing to Default
    public func resetLineSpacingToDefault() {
        guard let printer = connectedPeripheral,
              let characteristic = printCharacteristic else {
            delegate.didErrorOccur(error: .PrintError("Could not reset Line Spacing to default"))
            return
        }

        let commandHex = [0x1b, 0x32]
        let commandData = Helper.commandHexToData(commandHex: commandHex)

        printer.writeValue(commandData, for: characteristic, type: .withoutResponse)
    }

    /// Function to Set Printer's Alternate Fonts
    /// - Parameter mode: Value representing the Font of choice
    public func setPrintMode(mode: PrintMode) {
        guard let printer = connectedPeripheral,
              let characteristic = printCharacteristic else {
            delegate.didErrorOccur(error: .PrintError("Could not set Print Mode"))
            return
        }

        let commandHex = [0x1b, 0x21, mode.hexValue]
        let commandData = Helper.commandHexToData(commandHex: commandHex)

        printer.writeValue(commandData, for: characteristic, type: .withoutResponse)
    }

    /// Function to Set Print Justification. Works on Text and Barcode.
    /// - Parameter justification: Value Representing Justification of choice
    public func setPrintJustification(justification: PrintJustification) {
        guard let printer = connectedPeripheral,
              let characteristic = printCharacteristic else {
            delegate.didErrorOccur(error: .PrintError("Could not set Print Justification"))
            return
        }

        let commandHex = [0x1b, 0x61, justification.hexValue]
        let commandData = Helper.commandHexToData(commandHex: commandHex)

        printer.writeValue(commandData, for: characteristic, type: .withoutResponse)
    }

    /// Function to Print Barcode From Number
    /// - Parameter text: Barcode Number to Print. Must be either 11 or 12 Numeric characters in Length
    public func printBarcodeFromText(text: String) {
        guard !text.isEmpty else {
            delegate.didErrorOccur(error: .PrintError("Barcode Number Empty"))
            return
        }
        guard text.count > 10 && text.count < 13 else {
            delegate.didErrorOccur(error: .PrintError("Barcode Number must be 11 or 12 Digits"))
            return
        }

        for char in text {
            guard char.wholeNumberValue != nil else {
                delegate.didErrorOccur(error: .PrintError("Barcode must be Numeric only"))
                return
            }
        }

        guard let printer = connectedPeripheral,
              let characteristic = printCharacteristic,
              let barcodeData = text.data(using: .ascii)
        else {
            delegate.didErrorOccur(error: .PrintError("Could not Print Barcode"))
            return
        }

        var commandData = Helper.commandHexToData(commandHex: [0x1d, 0x6b, 0x00])
        commandData.append(barcodeData)
        commandData.append(
            Helper.commandHexToData(commandHex: [0x00])
        )
        printer.writeValue(commandData, for: characteristic, type: .withoutResponse)
    }

    /// Function to Set Barcode Height
    /// - Parameter height: Value Representing Height of Barcode
    public func setBarcodeHeight(height: Int) {
        guard height > 0 && height < 256 else {
            delegate.didErrorOccur(error: .PrintError("Invalid Barcode Height"))
            return
        }
        guard let printer = connectedPeripheral,
              let characteristic = printCharacteristic else {
            delegate.didErrorOccur(error: .PrintError("Could not set Barcode Height to \(height)"))
            return
        }

        let commandHex = [0x1d, 0x68, height]
        let commandData = Helper.commandHexToData(commandHex: commandHex)

        printer.writeValue(commandData, for: characteristic, type: .withoutResponse)
    }

    /// Function to print an image such as logo
    /// - Parameters:
    ///   - image: UIImage to print
    ///            Note:- For 58mm Printer Head, recommended dimension is 430x100 pixels
    ///            Note:- For 80mm Printer Head, recommended dimension is 593x100 pixels
    ///   - printHead: Represents Size in mm of the printer head (Check Printer Manual/Specifications)
    public func printImage(image: UIImage, printHead: PrintHead) {
        guard let printer = connectedPeripheral,
              let characteristic = printCharacteristic else {
            delegate.didErrorOccur(error: .PrintError("Could not Print image"))
            return
        }

        let rasterImage = Helper.imageToRaster(image: image, printHead: printHead)
        let rasterData = Helper.rasterToData(bmp: rasterImage, printHead: printHead)
        printer.writeValue(rasterData, for: characteristic, type: .withoutResponse)
    }

    /// Function to send custom hex commands as List of Hexagonal Values
    /// - Parameter commandHex: List of Hexagonal Command Values
    public func sendCommand(commandHex: [Int]) {
        guard let printer = connectedPeripheral,
              let characteristic = printCharacteristic else {
            delegate.didErrorOccur(error: .PrintError("Could not send Command"))
            return
        }

        let commandData = Helper.commandHexToData(commandHex: commandHex)
        printer.writeValue(commandData, for: characteristic, type: .withoutResponse)
    }

    /// Function to send custom commands as Bytes
    /// - Parameter commandData: Byte Buffer as Command Data Value
    public func sendCommand(commandData: Data) {
        guard let printer = connectedPeripheral,
              let characteristic = printCharacteristic else {
            delegate.didErrorOccur(error: .PrintError("Could not send Command"))
            return
        }

        printer.writeValue(commandData as Data, for: characteristic, type: .withoutResponse)
    }
}

