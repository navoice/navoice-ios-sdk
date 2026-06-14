//
//  RecycleView.swift
//  MyCity
//
//  Waste & Recycling tab: pickup card, search, categories, drop-off.
//

import SwiftUI

struct RecycleView: View {
    @State private var searchText = ""

    private let pickupImageURL = "https://lh3.googleusercontent.com/aida-public/AB6AXuBjCy00n5HtmIzc-wo6yISlSGEcio2I9wvrNFcJOJOefHnfGCf8YJOw1p5HkZLDtHHRaM4fJfB3qp62fGtdZEnbPgO3UXVRXfp2V0xHtBPR4oB-8Qh_XDXjkeXaqpAddN02uouQcght1IRDPXYdHtGCccjRslGj8cAoZExA_eZ6EsjlE4R0Kei8cvB_vZZdN7RUQeJKPmJKJ3qdohql_zCNNY3ALJHkicYK8STvMqhTOWC4ARVrwuwIRti2ruCxPHRaHiwb7FrdJpc"
    private let mapImageURL = "https://lh3.googleusercontent.com/aida-public/AB6AXuD993v7k_ywV0Gu8wcZYLd7udjZs5dqmrsQwuYe8TZePR2VF3NogAOmZWbBRexGRfNWJLwaSG4E-j4qN6NXPtlPSMfZxdbAADEUHvqnIQLzJmfCSmMq_fc49-Ro0F_GSITTZQmloxRj_l5u2sMHKbnVcAzPo64JVeUog7sX1TUJzPxnLJhroUZGdSAGSPXEjr32c46JhuzfJjNDm7R6mCd7LIuo-7S7w81GAY4eU-3mG9eSyeeBa0XJ3Syl6vq-glAtBQy8ww6Uiis"

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Header: back + title + notifications
                    TopBarView(
                        title: "Recycle",
                        showBack: true,
                        trailingIcon: "bell"
                    )
                    .padding(.bottom, 8)

                    // Next pickup card
                    PickupCardView(
                        date: "Friday, Oct 25",
                        imageURL: pickupImageURL
                    )
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)

                    // Search
                    SearchBarView(placeholder: "How do I dispose of...", text: $searchText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)

                    // Waste categories
                    sectionHeader("Waste Categories")
                        .padding(.top, 24)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)

                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ], spacing: 12) {
                        WasteCategoryItem(
                            icon: "arrow.2.circlepath",
                            title: "Plastic",
                            iconColor: AppTheme.primary,
                            bgColor: AppTheme.primary.opacity(0.12)
                        )
                        WasteCategoryItem(
                            icon: "cpu",
                            title: "E-waste",
                            iconColor: Color.purple,
                            bgColor: Color.purple.opacity(0.12)
                        )
                        WasteCategoryItem(
                            icon: "exclamationmark.triangle",
                            title: "Hazardous",
                            iconColor: Color.red,
                            bgColor: Color.red.opacity(0.12)
                        )
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)

                    // Nearest drop-off
                    sectionHeader("Nearest Drop-off Center")
                        .padding(.top, 24)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)

                    DropOffCardView(
                        name: "Main Street EcoCenter",
                        detail: "0.8 miles • Open until 6:00 PM",
                        mapImageURL: mapImageURL
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
            }
            .background(AppTheme.backgroundLight)
        }
    }

    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.primary)
    }
}

#Preview {
    RecycleView()
}
