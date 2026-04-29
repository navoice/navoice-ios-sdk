//
//  MyCityApp-MyCity.swift
//  MyCity
//
//  Legacy app entry placeholder removed to avoid duplicate @main.
//  The active app entry point is defined in MyCityApp.swift.
//

import SwiftUI
import NavoiceSDK

/// App metadata and constants used across the app.
struct AppInfo {
    static let cityName: String = "MyCity"
    static let subtitle: String = "City Services"
}

@main
struct MyCityApp: App {
    private let navoice = Navoice(specResourceName: "mycity_spec")
    @StateObject private var presentationPresenter = PresentationPresenter()
    @StateObject private var profile = AppUserProfile()

    var body: some Scene {
        WindowGroup {
            RootTabsView()
                .environmentObject(navoice)
                .environmentObject(presentationPresenter)
                .environmentObject(profile)
        }
    }
}






