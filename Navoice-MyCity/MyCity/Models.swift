import Foundation

struct School: Identifiable, Hashable {
    let id: UUID
    let name: String
    let address: String
    let level: String
    let phone: String
}

struct Program: Identifiable, Hashable {
    let id: UUID
    let title: String
    let summary: String
}

struct Announcement: Identifiable, Hashable {
    let id: UUID
    let title: String
    let detail: String
    let date: Date
}

struct Event: Identifiable, Hashable {
    let id: UUID
    let title: String
    let location: String
    let date: Date
    let summary: String
}

struct RecyclePickup: Identifiable, Hashable {
    let id: UUID
    let area: String
    let weekday: String
    let nextDate: Date
}

struct IssueReport: Identifiable, Hashable {
    let id: UUID
    let category: String
    let description: String
    let email: String?
}

struct Property: Identifiable, Hashable {
    let id: UUID
    let address: String
    let parcel: String
    let assessedValue: Double
}

struct TaxPayment: Identifiable, Hashable {
    let id: UUID
    let date: Date
    let amount: Double
    let method: String
}
