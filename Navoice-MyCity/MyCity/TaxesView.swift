//
//  TaxesView.swift
//  MyCity
//
//  Municipal Tax Center: hero, obligation cards, tax relief, past payments.
//

import SwiftUI

struct TaxesView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Top bar
                    TopBarView(title: "Municipal Tax Center", showBack: true)
                        .padding(.bottom, 8)

                    // Hero
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Taxes & Licenses")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                        Text("Manage your city obligations securely.")
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.slate500)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)

                    // Active obligations
                    VStack(spacing: 16) {
                        ObligationCardView(
                            status: "PENDING PAYMENT",
                            statusColor: AppTheme.primary,
                            title: "Property Tax 2024",
                            subtitle: "$1,240.50 Due Oct 31, 2024",
                            icon: "house.fill",
                            iconBgColor: AppTheme.primary,
                            buttonTitle: "Pay Now",
                            buttonIcon: "creditcard",
                            isPrimaryButton: true
                        )
                        ObligationCardView(
                            status: "ACTIVE STATUS",
                            statusColor: AppTheme.emerald,
                            title: "Business License",
                            subtitle: "Valid until Dec 15, 2024",
                            icon: "storefront",
                            iconBgColor: AppTheme.emerald,
                            buttonTitle: "Renew Early",
                            buttonIcon: "arrow.clockwise",
                            isPrimaryButton: false
                        )
                    }
                    .padding(16)

                    // Tax relief
                    HStack {
                        sectionHeader("Tax Relief Programs")
                        Spacer()
                        Button("View All") {}
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppTheme.primary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)

                    TaxReliefRow(
                        title: "Senior Citizens Exemption",
                        subtitle: "Check eligibility for property tax reductions."
                    )
                    .padding(.horizontal, 16)

                    // Past payments
                    sectionHeader("Past Payments")
                        .padding(.horizontal, 16)
                        .padding(.top, 32)
                        .padding(.bottom, 16)

                    VStack(spacing: 12) {
                        PastPaymentRow(
                            title: "Water Utility Tax",
                            detail: "Sep 12, 2023 • $45.20"
                        )
                        PastPaymentRow(
                            title: "Property Tax Q3",
                            detail: "Jul 15, 2023 • $1,240.50"
                        )
                    }
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
    TaxesView()
}
