//
//  Tools.swift
//  YYangPlugin
//
//  Created by mt on 2025/4/1.
//

import Foundation

import SwiftUI

class Tools {
    /// 将十六进制颜色码转换为 SwiftUI 的 Color 对象
    /// - Parameter hex: 十六进制颜色码，格式可以是 "#RRGGBB" 或 "RRGGBB"
    /// - Returns: 对应的 SwiftUI Color 对象
    static func color(_ hex: String) -> Color {
        var hexSanitized = hex.trimmingCharacters(in:.whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        return Color(red: red, green: green, blue: blue)
    }

    /// 将十六进制颜色码转换为 CGColor 对象
    /// - Parameter hex: 十六进制颜色码，格式可以是 "#RRGGBB" 或 "RRGGBB"
    /// - Returns: 对应的 CGColor 对象
    static func cgColor(_ hex: String) -> CGColor {
        var hexSanitized = hex.trimmingCharacters(in:.whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor
    }
}

// 使用示例
//let hexColor = "#F01534"
//let swiftUIColor = ColorUtils.colorFromHex(hexColor)
