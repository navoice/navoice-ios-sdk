//
//  MyCityComponents.swift
//  MyCity
//
//  Reusable UI: top bars, search, cards, list rows.
//

import SwiftUI

// MARK: - Top app bar (back + centered title, optional trailing)
struct TopBarView: View {
    let title: String
    var showBack: Bool = true
    var trailing: (() -> Void)? = nil
    var trailingIcon: String? = nil

    var body: some View {
        HStack {
            if showBack {
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppTheme.primary)
                        .frame(width: 44, height: 44)
                }
            } else {
                Color.clear.frame(width: 44, height: 44)
            }
            Spacer()
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            Spacer()
            if let icon = trailingIcon {
                Button(action: { trailing?() }) {
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                }
            } else if trailing != nil {
                Button(action: { trailing?() }) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(Color(.systemGray))
                        .frame(width: 44, height: 44)
                }
            } else {
                Color.clear.frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 8)
    }
}

// MARK: - Search field
struct SearchBarView: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 20))
                .foregroundColor(AppTheme.slate500)
            TextField(placeholder, text: $text)
                .font(.system(size: 16))
        }
        .padding(.horizontal, 16)
        .frame(height: 44)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

// MARK: - Banner (gradient overlay over image)
struct BannerView: View {
    let tag: String
    let title: String
    let imageURL: String?

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let urlString = imageURL, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image): image.resizable().scaledToFill()
                    case .failure: placeholderGradient
                    default: ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .frame(minHeight: 160)
                .clipped()
            } else {
                placeholderGradient
                    .frame(minHeight: 160)
            }
            LinearGradient(
                colors: [.clear, .black.opacity(0.6)],
                startPoint: .top,
                endPoint: .bottom
            )
            VStack(alignment: .leading, spacing: 4) {
                Text(tag)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))
                    .tracking(1.2)
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(16)
        }
        .frame(minHeight: 160)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var placeholderGradient: some View {
        LinearGradient(
            colors: [AppTheme.primary.opacity(0.3), AppTheme.primary.opacity(0.6)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Education service card (icon + title + description + button + optional image)
struct EducationServiceCard: View {
    let icon: String
    let title: String
    let description: String
    let buttonTitle: String
    let isPrimaryButton: Bool
    let imageURL: String?

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(AppTheme.primary)
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                }
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.slate500)
                Button(action: {}) {
                    Text(buttonTitle)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(isPrimaryButton ? .white : AppTheme.primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 9)
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isPrimaryButton ? AppTheme.primary : AppTheme.primary.opacity(0.15))
                )
                .buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            if let urlString = imageURL, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image): image.resizable().scaledToFill()
                    case .failure: RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray5))
                    default: ProgressView()
                    }
                }
                .frame(width: 96, height: 96)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.separator).opacity(0.5), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        )
    }
}

// MARK: - Board meeting row (date badge + title + subtitle + chevron)
struct BoardMeetingRow: View {
    let month: String
    let day: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 2) {
                Text(month)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(AppTheme.primary)
                Text(day)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppTheme.primary)
            }
            .frame(width: 48, height: 48)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppTheme.primary.opacity(0.12))
            )
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.slate500)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppTheme.slate400)
        }
        .padding(16)
    }
}

// MARK: - Event hero (featured event with badge)
struct EventHeroView: View {
    let badge: String
    let title: String
    let locationLine: String
    let imageURL: String?

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let urlString = imageURL, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image): image.resizable().scaledToFill()
                    case .failure: eventPlaceholder
                    default: ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .frame(minHeight: 256)
                .clipped()
            } else { eventPlaceholder.frame(minHeight: 256) }
            LinearGradient(
                colors: [.clear, .black.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
            VStack(alignment: .leading, spacing: 8) {
                Text(badge)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .tracking(1.5)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppTheme.secondary)
                    )
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                HStack(spacing: 4) {
                    Image(systemName: "mappin")
                        .font(.system(size: 14))
                    Text(locationLine)
                        .font(.system(size: 14))
                }
                .foregroundColor(.white.opacity(0.9))
            }
            .padding(20)
        }
        .frame(minHeight: 256)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
    }

    private var eventPlaceholder: some View {
        LinearGradient(
            colors: [AppTheme.primary.opacity(0.4), AppTheme.secondary.opacity(0.4)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Category pill (horizontal filter)
struct CategoryPillView: View {
    let title: String
    let icon: String?
    let isSelected: Bool
    /// When not selected, use this color for the icon (e.g. green for Festivals, orange for Workshops).
    var iconTint: Color = AppTheme.primary

    var body: some View {
        HStack(spacing: 6) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(isSelected ? .white : iconTint)
            }
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? .white : .primary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(isSelected ? AppTheme.primary : AppTheme.cardBackground)
        )
        .overlay(
            Capsule()
                .stroke(Color(.separator).opacity(0.6), lineWidth: isSelected ? 0 : 1)
        )
    }
}

// MARK: - Event list card (image + date + title + location + Add to Calendar)
struct EventRowCard: View {
    let dateTime: String
    let title: String
    let location: String
    let imageURL: String?

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            if let urlString = imageURL, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image): image.resizable().scaledToFill()
                    case .failure: Color(.systemGray5)
                    default: ProgressView()
                    }
                }
                .frame(width: 96, height: 96)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(dateTime)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(AppTheme.secondary)
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                Text(location)
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.slate500)
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 12))
                        Text("Add to Calendar")
                            .font(.system(size: 12, weight: .bold))
                    }
                    .foregroundColor(AppTheme.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppTheme.primary.opacity(0.15))
                )
                .buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.separator).opacity(0.5), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        )
    }
}

// MARK: - Recycle pickup card
struct PickupCardView: View {
    let date: String
    let imageURL: String?

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                if let urlString = imageURL, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image): image.resizable().scaledToFill()
                        case .failure: Color(.systemGray5)
                        default: ProgressView()
                        }
                    }
                    .frame(height: 120)
                    .clipped()
                } else {
                    Color(.systemGray5).frame(height: 120)
                }
            }
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Circle()
                        .fill(AppTheme.accentGreen)
                        .frame(width: 8, height: 8)
                    Text("UPCOMING PICKUP")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(AppTheme.accentGreen)
                        .tracking(1.2)
                }
                Text(date)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            Image(systemName: "trash").font(.system(size: 14)).foregroundColor(AppTheme.slate400)
                            Text("Trash").font(.system(size: 14)).foregroundColor(AppTheme.slate500)
                        }
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.2.circlepath").font(.system(size: 14)).foregroundColor(AppTheme.primary)
                            Text("Recycling").font(.system(size: 14)).foregroundColor(AppTheme.slate500)
                        }
                        HStack(spacing: 8) {
                            Image(systemName: "leaf").font(.system(size: 14)).foregroundColor(AppTheme.accentGreen)
                            Text("Green Waste").font(.system(size: 14)).foregroundColor(AppTheme.slate500)
                        }
                    }
                    Spacer()
                    Button(action: {}) {
                        Text("Full Schedule")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 9)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppTheme.primary)
                    )
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.separator).opacity(0.5), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        )
    }
}

// MARK: - Waste category grid item
struct WasteCategoryItem: View {
    let icon: String
    let title: String
    let iconColor: Color
    let bgColor: Color

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(bgColor)
                    .frame(width: 48, height: 48)
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(iconColor)
            }
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.separator).opacity(0.5), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        )
    }
}

// MARK: - Drop-off center card (map + name + distance + directions)
struct DropOffCardView: View {
    let name: String
    let detail: String
    let mapImageURL: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                if let urlString = mapImageURL, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image): image.resizable().scaledToFill()
                        case .failure: Color(.systemGray5)
                        default: ProgressView()
                        }
                    }
                    .frame(height: 160)
                    .clipped()
                } else {
                    Color(.systemGray5).frame(height: 160)
                }
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 36))
                    .foregroundColor(AppTheme.primary)
                    .background(Circle().fill(.white).padding(4))
                .shadow(radius: 4)
            }
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.primary)
                    Text(detail)
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.slate500)
                }
                Spacer()
                Image(systemName: "arrow.triangle.turn.up.right.diamond")
                    .font(.system(size: 20))
                    .foregroundColor(AppTheme.primary)
            }
            .padding(16)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.separator).opacity(0.5), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        )
    }
}

// MARK: - Tax obligation card (status + title + subtitle + icon + CTA)
struct ObligationCardView: View {
    let status: String
    let statusColor: Color
    let title: String
    let subtitle: String
    let icon: String
    let iconBgColor: Color
    let buttonTitle: String
    let buttonIcon: String
    let isPrimaryButton: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(status)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(statusColor)
                        .tracking(1)
                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.slate500)
                }
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconBgColor.opacity(0.15))
                        .frame(width: 48, height: 48)
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(iconBgColor)
                }
            }
            Button(action: {}) {
                HStack(spacing: 8) {
                    Image(systemName: buttonIcon)
                    Text(buttonTitle)
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(isPrimaryButton ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isPrimaryButton ? AppTheme.primary : Color(.systemGray5))
            )
            .shadow(color: isPrimaryButton ? AppTheme.primary.opacity(0.25) : .clear, radius: 8, x: 0, y: 4)
            .buttonStyle(.plain)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.separator).opacity(0.5), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        )
    }
}

// MARK: - Tax relief row (icon + title + subtitle + chevron)
struct TaxReliefRow: View {
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 32))
                .foregroundColor(AppTheme.primary)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.slate500)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(AppTheme.slate400)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.primary.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppTheme.primary.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// MARK: - Past payment row (receipt icon + title + date/amount + PDF button)
struct PastPaymentRow: View {
    let title: String
    let detail: String

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 40, height: 40)
                Image(systemName: "doc.text")
                    .font(.system(size: 20))
                    .foregroundColor(AppTheme.slate500)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.primary)
                Text(detail)
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.slate500)
            }
            Spacer()
            Button(action: {}) {
                Image(systemName: "doc.richtext")
                    .font(.system(size: 22))
                    .foregroundColor(AppTheme.primary)
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.separator).opacity(0.5), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        )
    }
}
