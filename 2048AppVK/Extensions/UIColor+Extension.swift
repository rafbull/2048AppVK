//
//  UIColor+Extension.swift
//  2048AppVK
//
//  Created by Rafis on 09.04.2024.
//

import UIKit

extension UIColor {
    class func convertFromHex(_ value: UInt64, alpha: CGFloat) -> UIColor {
        return UIColor(
            red: CGFloat((value & 0xFF0000) >> 16) / 255,
            green: CGFloat((value & 0x00FF00) >> 8) / 255,
            blue: CGFloat(value & 0x0000FF) / 255,
            alpha: alpha
        )
    }
}

