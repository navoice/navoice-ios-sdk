//
//  EducationView.swift
//  MyCity
//
//  Education Services tab: banner, search, service cards, board meetings.
//

import SwiftUI

struct EducationView: View {
    @State private var searchText = ""

    private let bannerImageURL = "https://lh3.googleusercontent.com/aida-public/AB6AXuDCqv_neTr7x0awvKhG6ZIYTr3Oq_xAIWuzi3MnZMcVHihtZjZzOjp7UCkmGDNVcbApFnUCVE0MfH7wX1ys4nBRLOcsI-g6oHRBF9LI07MWOIOO-ADdS0kRaN_k7CBp-xHta4frTxDAd9YCaISaMJx7jHeQV5jIRPAZ-OGDf8sxPUqrVspgUw11vHJmD2mGhuCMzoyRBA-pCjAg09Joc7oMKYWchpNlpCoE_CosOov-_pf5Towm8vVcRazE04zMZQH0o3_7OHqqy-w"
    private let schoolImageURL = "https://lh3.googleusercontent.com/aida-public/AB6AXuDT9TspbPcBr8IU42iJWBbMMx6swD22i86_SzeKcmx5TjdTIrkoDve58dlYJOZaT4qvBOiClCNfQY-2d20orv4HuSzeI4gRDPy69Ri5ac_Zxck8TJc8mXPh77CwG5SN5Oeks3vszqoRzJvpfgwcsJbObM5E8CSqhZybP3ZpOyotJNXCoyrEKl-LxKZHczI6dCzxg3yarAsrKPZrVq8EHHIaGmsQFH5SRxJYE9jfld-GRG9kLRvkE7RzQQ2lpJ0B-qgpWJVmTcsPjZk"
    private let libraryImageURL = "https://lh3.googleusercontent.com/aida-public/AB6AXuBkblWMSdBWgeX2FgMfHUPT8LmxjmjMRMqzg7CPJHwTBzHu3duN21rlkhDoGqocGrk-P6K4zRp1VrJRTadVwopjBBn1vUH_gW5q0AusriD-3_dirlaSdSEbjx5VLOccMbLhEehCo6KEHYztNWLius9g54dAvzpV6M-KQY4zCuU2yBkgBm6lOiFDUvpwa2IB6OHjlrOm1M2-RbQP1gsMIYA-FXvki3AHEk675LFMaoTbK-ZwJt_dUG4uTTYvuCjMTH6GQPBAxJbEhMY"
    private let adultLearningImageURL = "https://lh3.googleusercontent.com/aida-public/AB6AXuBuRHmun2psTkekibqHu9vFpQLTxB-soIsdr6VAIrCvpBDk2yuokptu5kviAD902gZth7lbbQnuiHiDZYMO2o_UOQfXYdqKhcOPYJ3Tw2h32KGJFzb0il92yfjb0171M-lNzJNfeOC5ApMdmBGVDxRsYUVWAmqDWFLuoS1ZSusce0e-0e1PSRVhJPtT_3mUjmscLJkGW365oZz0AKuYFc2yU5SnUt4Re4oooI-arZ1U4MJDiOti-do6cJ5fCqGb1Yxv94EuKB55lEE"

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Top bar
                    TopBarView(title: "Education Services", showBack: true, trailingIcon: nil)

                    // Search
                    SearchBarView(placeholder: "Search schools or programs", text: $searchText)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)

                    // Banner
                    BannerView(
                        tag: "Seasonal Guide",
                        title: "Back to School 2024",
                        imageURL: bannerImageURL
                    )
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)

                    // Our Services
                    sectionHeader("Our Services")
                        .padding(.top, 24)

                    VStack(spacing: 16) {
                        EducationServiceCard(
                            icon: "building.columns",
                            title: "School Registration",
                            description: "Enroll your child in local public schools for the upcoming term.",
                            buttonTitle: "Enroll Now",
                            isPrimaryButton: true,
                            imageURL: schoolImageURL
                        )
                        EducationServiceCard(
                            icon: "books.vertical",
                            title: "Library Services",
                            description: "Access digital catalogs, book rentals, and community study spaces.",
                            buttonTitle: "Find Library",
                            isPrimaryButton: false,
                            imageURL: libraryImageURL
                        )
                        EducationServiceCard(
                            icon: "person.3",
                            title: "Adult Learning",
                            description: "Skill development, vocational training, and night classes for adults.",
                            buttonTitle: "View Courses",
                            isPrimaryButton: false,
                            imageURL: adultLearningImageURL
                        )
                    }
                    .padding(.horizontal, 16)

                    // Board Meetings
                    HStack {
                        sectionHeader("Board Meetings")
                        Spacer()
                        Button("See All") {}
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppTheme.primary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 32)
                    .padding(.bottom, 12)

                    VStack(spacing: 0) {
                        BoardMeetingRow(
                            month: "Oct",
                            day: "12",
                            title: "Curriculum Review 2024",
                            subtitle: "6:30 PM • City Hall Room 4"
                        )
                        Divider().padding(.leading, 80)
                        BoardMeetingRow(
                            month: "Oct",
                            day: "15",
                            title: "Budget Allocation Hearing",
                            subtitle: "5:00 PM • Virtual Meeting"
                        )
                        Divider().padding(.leading, 80)
                        BoardMeetingRow(
                            month: "Oct",
                            day: "22",
                            title: "New School Safety Protocol",
                            subtitle: "7:00 PM • Southside High"
                        )
                    }
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppTheme.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.separator).opacity(0.5), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 16)

                    // Bottom padding for tab bar + FAB
                    Color.clear.frame(height: 100)
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
    EducationView()
}
