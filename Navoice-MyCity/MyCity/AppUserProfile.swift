//
//  AppUserProfile.swift
//  MyCity
//
//  App-level user/profile values for present modals (id_number, subscriber_number).
//  Wire real values from your auth/profile layer when available.
//

import Foundation
import Combine

final class AppUserProfile: ObservableObject {
    @Published var idNumber: String = "02424355"
    @Published var subscriberNumber: String = "02424355"
}
