//
//  AppTheme.swift
//  MyCity
//
//  Design tokens matching the HTML/Tailwind spec (primary #137fec, etc.)
//

import SwiftUI

enum AppTheme {
    // MARK: - Colors (light mode; dark uses same names with adjusted values where needed)
    static let primary = Color(red: 19/255, green: 127/255, blue: 236/255)
    static let backgroundLight = Color(red: 246/255, green: 247/255, blue: 248/255)
    static let backgroundDark = Color(red: 16/255, green: 25/255, blue: 34/255)
    static let secondary = Color(red: 34/255, green: 197/255, blue: 94/255)  // #22c55e
    static let accentGreen = Color(red: 39/255, green: 174/255, blue: 96/255) // #27ae60
    static let emerald = Color(red: 16/255, green: 185/255, blue: 129/255)    // emerald-500

    static let cardBackground = Color(.systemBackground)
    static let cardBorderLight = Color(white: 0.93)
    static let cardBorderDark = Color(white: 0.25)
    static let searchBackgroundLight = Color(white: 0.91)
    static let searchBackgroundDark = Color(white: 0.18)
    static let slate900 = Color(white: 0.11)
    static let slate100 = Color(white: 0.96)
    static let slate500 = Color(white: 0.45)
    static let slate400 = Color(white: 0.55)
    static let slate700 = Color(white: 0.28)
    static let slate800 = Color(white: 0.22)
}
