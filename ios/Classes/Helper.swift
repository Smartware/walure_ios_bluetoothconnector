//
//  Helper.swift
//  BluetoothTest
//
//  Created by Olajide Osho on 10/12/2023.
//

import Foundation
import UIKit

struct Helper {
    /// Function that converts a single Hexadecimal String Value to Data Bytes
    /// - Parameter hexValue: hexadecimal string value to convert to data
    /// - Returns: Data in form of bytes
    static func hexToData(hexValue: String) -> Data? {
        var data = Data(capacity: hexValue.count / 2)
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: hexValue, options: [], range: NSMakeRange(0, hexValue.count)) { match, flags, stop in
            let byteString = (hexValue as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        guard data.count > 0 else {
            return nil
        }
        return data
    }

    /// Function that converts an array of hexadecimal values to Data Bytes
    /// - Parameter commandHex: array of hexadecimal values
    /// - Returns: Data in form of bytes
    static func commandHexToData(commandHex: [Int]) -> Data {
        var printCommand = String()
        for command in commandHex {
            if let scalar = UnicodeScalar(command) {
                printCommand.append(Character(scalar))
            }
        }

        guard let commandData = printCommand.data(using: .utf8) else {
            return Data()
        }
        return commandData
    }

    /// Function that converts a pixel of an image into its Grayscale Hexadecimal value
    /// - Parameters:
    ///   - x: X Position of the Pixel in the image
    ///   - y: Y Position of the Pixel in the image
    ///   - bit: image in context
    /// - Returns: Hexadecimal value of pixel
    static func pixelToByte(x: Int, y: Int, bit: UIImage) -> UInt8 {
        guard let cgImage = bit.cgImage, x < cgImage.width, y < cgImage.height else {
            return 0
        }
        let data = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
        defer {
            data.deallocate()
        }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: data,
                                width: 1,
                                height: 1,
                                bitsPerComponent: 8,
                                bytesPerRow: 4,
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        context?.draw(cgImage, in: CGRect(x: -x, y: -y, width: cgImage.width, height: cgImage.height))

        let red = data[0]
        let green = data[1]
        let blue = data[2]
        let redGrayValue = 0.299 * CGFloat(red)
        let greenGrayValue = 0.587 * CGFloat(green)
        let blueGrayValue = 0.114 * CGFloat(blue)

        let gray = redGrayValue + greenGrayValue + blueGrayValue
        return gray < 128 ? 1 : 0
    }

    /// Function to convert a rasterized image into its byte representation
    /// - Parameters:
    ///   - bmp: Rasterized image to convert
    ///   - printHead: Represents Size in mm of the printer head (Check Printer Manual/Specifications)
    /// - Returns: Data Bytes
    static func rasterToData(bmp: UIImage, printHead: PrintHead) -> Data {
        let size = Int(bmp.size.width * bmp.size.height / 8) + 10000
        var data = Data(count: size)
        var k = 0

        data[k] = 0x1B
        k += 1
        data[k] = 0x33
        k += 1
        data[k] = 0x00
        k += 1

        for j in 0..<6 {
            data[k] = 0x1B
            k += 1
            data[k] = 0x2A
            k += 1
            data[k] = 33
            k += 1
            let xl = printHead.imageHorizontalByteLength
            data[k] = UInt8(xl)
            k += 1
            let xh = printHead.imageHorizontalByteDivisible
            data[k] = UInt8(xh)
            k += 1

            let horizontalConstraint = xl + (xh*256)
            for i in (0..<horizontalConstraint) {
                for m in (0..<3){
                    var byte: UInt8 = 0
                    for n in 0..<8 {
                        let b = pixelToByte(x: i, y: j * 24 + m * 8 + n, bit: bmp)
                        byte = (byte << 1) | b
                    }
                    data[k] = byte
                    k += 1
                }
            }

            data[k] = 10
            k += 1
        }
        let actualData = data[0...k]

        return actualData
    }

    /// Function to convert an image into raster format
    /// - Parameters:
    ///   - image: Image to convert to raster format
    ///   - printHead: Represents Size in mm of the printer head (Check Printer Manual/Specifications)
    /// - Returns: Rasterized Image
    static func imageToRaster(image: UIImage, printHead: PrintHead) -> UIImage {
        let heightPoints: CGFloat = 30

        let imageView = UIImageView(
            frame: CGRect(x:0, y: 0, width: printHead.imageWidth, height: 100)
        )
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        let mirrorTransform = CGAffineTransform(scaleX: 1, y: -1)
        imageView.transform = mirrorTransform

        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: printHead.imageWidth, height: 100))
        contentView.addSubview(imageView)

        let finalImageRenderer = UIGraphicsImageRenderer(bounds: contentView.bounds)
        let finalImage = finalImageRenderer.image { context in
            contentView.layer.render(in: context.cgContext)
        }

        let textAttachment = NSTextAttachment()
        let ratio = finalImage.size.width / finalImage.size.height
        let width = heightPoints * ratio
        textAttachment.bounds = CGRect(x: 0, y: 0, width: width, height: heightPoints)
        textAttachment.image = finalImage

        let iconString = NSAttributedString(attachment: textAttachment)
        let logoString = NSMutableAttributedString(attributedString: iconString)

        let options: NSStringDrawingOptions = [.truncatesLastVisibleLine, .usesLineFragmentOrigin]
        let dataRect = logoString.boundingRect(
            with: CGSize(width: width, height: heightPoints),
            options: options,
            context: nil
        )
        let dataSize = dataRect.size
        let renderer = UIGraphicsImageRenderer(size: dataSize)
        let rasterImage = renderer.image { context in
            UIColor.white.set()
            let rect = CGRect(x: 0, y: 0, width: dataSize.width + 1, height: dataSize.height + 1)
            context.fill(rect)
            logoString.draw(in: rect)
        }

        return rasterImage
    }
}
