//
//  EventsView.swift
//  MyCity
//
//  City Events tab: hero, categories, this weekend list.
//

import SwiftUI

struct EventsView: View {
    @State private var selectedCategory = 0

    private let heroImageURL = "https://lh3.googleusercontent.com/aida-public/AB6AXuB04BaiZaZNzkCjIrXCzcJUR1sU147262dgggAJFpsaQ75hgphGtvk-nP8qMFt-19Wrf4VP6xG4piSS7uUscfs-i8jIi_jll186Ov5kH9RuC_A8NS5cEL34sSzs7K8v-SUJhhMLDlgzNb08h7AOdp1Hxgg0rvoSsAJFewbgK7b0VpoGnArq2R7cBPmbY8CUji_u1lf9LSJWx8I3m0er09yGRX7OzQ2IQvXUaAzahL1IZRz37HHj8CHqg9CK30XHkqzMnHBvNmK2sNU"
    private let streetFairImageURL = "https://lh3.googleusercontent.com/aida-public/AB6AXuASs50j41uS_LsyR30CFgExteCURXlZQaAijQTkX0oorFJTgQoq9Rt-DfSMXaNzuTAW0Ew8s_W5BfSWStFniPRYFHK0_CHAWnLr6PAvrErZQs49N1sLRLT_8FTiVaJIyhdQn6T4-tICSLTA8eo0-PoMGlzasDGzbKzldcikKnACZAntnHdONCGJMAorCtiPYCvVepo-y4zgqeY8p_sxNQnr3CiGXa7yPALE5hp-3jDIii9cJRtpPvHWz_r0-Cb9yRtr_8jxJEKevhE"
    private let runImageURL = "https://lh3.googleusercontent.com/aida-public/AB6AXuCcPw5udv3-oVfpD2a1rxObQinx0eAyuRIiWrYlGdYdTItee9cl74z4-jqer7WKMQneWgJQcnpc9gmPjORphDd2k_N5rbixIRhvcxGz2TGtIeIIz9HbHF8sXwRE23Op9Bams6QK6Ig6BFazuafRnzKUT6V4lkXTWvfJKFD_8Cds95FiB2ouBNTGzbS39eZXOaN2Qob8h5FUK5NeX2UFuZzC7lLW-9aU8oluBemXNM51UGWzKICi_zeF_FR09acz66TnL-e63HhFIQs"
    private let potteryImageURL = "https://lh3.googleusercontent.com/aida-public/AB6AXuCCIF1yxbbjhqCPRabRq9BlEAJDI1sog8Nqc0p_IPXljYrQ_aeqo_WbZ5A98ezckzPvpgLAn89cS6g7MU13wbqjBnYhmZPRHd8ShfGt7PEC7xjLirU6sxuL3bFuGxtz-jzy55STixiV5w59s4CBeMDqNpNRgqD_DiPKCPtcSovaxTtP5gikgXV1Rn6iwJ7M4cRXy1Ag0jZHG0GA0A1mv67QShfHVSNd1yB7dAP1o-0PVghvnqC3cVhEEV8OQaBpA6D_jkAa8Tuwkng"

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Top bar: menu + title + profile
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "line.3.horizontal")
                                .font(.system(size: 24))
                                .foregroundColor(AppTheme.primary)
                                .frame(width: 48, height: 48)
                        }
                        Spacer()
                        Text("MyCity Events")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(Color(.systemGray))
                                .frame(width: 48, height: 48)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)

                    // Featured hero
                    EventHeroView(
                        badge: "Featured Event",
                        title: "Summer Jazz in the Central Park",
                        locationLine: "Central Pavilion • Today 6:00 PM",
                        imageURL: heroImageURL
                    )
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                    // Horizontal categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            CategoryPillView(title: "All Events", icon: nil, isSelected: selectedCategory == 0)
                                .onTapGesture { selectedCategory = 0 }
                            CategoryPillView(title: "Festivals", icon: "party.popper", isSelected: selectedCategory == 1, iconTint: AppTheme.secondary)
                                .onTapGesture { selectedCategory = 1 }
                            CategoryPillView(title: "Sports", icon: "sportscourt", isSelected: selectedCategory == 2, iconTint: AppTheme.primary)
                                .onTapGesture { selectedCategory = 2 }
                            CategoryPillView(title: "Workshops", icon: "book", isSelected: selectedCategory == 3, iconTint: .orange)
                                .onTapGesture { selectedCategory = 3 }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 8)

                    // This Weekend
                    HStack {
                        Text("This Weekend")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)
                        Spacer()
                        Button("See all") {}
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(AppTheme.primary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)

                    VStack(spacing: 16) {
                        EventRowCard(
                            dateTime: "Saturday • 10:00 AM",
                            title: "Downtown Street Fair",
                            location: "Main Street District",
                            imageURL: streetFairImageURL
                        )
                        EventRowCard(
                            dateTime: "Sunday • 07:30 AM",
                            title: "MyCity 5K Charity Run",
                            location: "Riverside Park Entrance",
                            imageURL: runImageURL
                        )
                        EventRowCard(
                            dateTime: "Sunday • 02:00 PM",
                            title: "Community Pottery Class",
                            location: "Arts Center, Room 4",
                            imageURL: potteryImageURL
                        )
                    }
                    .padding(.horizontal, 16)

                    Color.clear.frame(height: 100)
                }
            }
            .background(AppTheme.backgroundLight)
        }
    }
}

#Preview {
    EventsView()
}
