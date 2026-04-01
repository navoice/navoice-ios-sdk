//
//  PresentationPresenter.swift
//  MyCity
//
//  App-level presenter for NavoiceSDK .present(presentationId:params:say:...) results.
//  Host app renders UI; SDK does not.
//

import SwiftUI
import Combine

// MARK: - Pending presentation model

struct PendingPresentation: Identifiable {
    let id = UUID()
    let presentationId: String
    let params: [String: String]
    let say: String?
}

// MARK: - Presenter (app-level)

@MainActor
final class PresentationPresenter: ObservableObject {
    @Published var pendingPresentation: PendingPresentation?

    /// Call when NavoiceSDK returns .present(presentationId:params:say:...).
    func present(presentationId: String, params: [String: String], say: String?) {
        print("[MyCity][Present] id=\(presentationId) params=\(params)")
        pendingPresentation = PendingPresentation(
            presentationId: presentationId,
            params: params,
            say: say
        )
    }

    func dismiss() {
        pendingPresentation = nil
    }
}

// MARK: - Sheet content view

struct PresentationSheetView: View {
    let presentation: PendingPresentation
    let onDismiss: () -> Void
    @EnvironmentObject private var profile: AppUserProfile

    var body: some View {
        Group {
            switch presentation.presentationId {
            case "id_number":
                valueContent(title: "ID Number", bodyText: profile.idNumber)
            case "subscriber_number":
                valueContent(title: "Subscriber Number", bodyText: profile.subscriberNumber)
            default:
                genericContent
            }
        }
        .padding(24)
    }

    /// Modal for id_number / subscriber_number: title from mapping, body from app user/profile (not say).
    private func valueContent(title: String, bodyText: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)

            Text(bodyText)
                .font(.system(size: 17))
                .foregroundColor(.secondary)

            Spacer(minLength: 16)

            Button("Close") {
                onDismiss()
            }
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(RoundedRectangle(cornerRadius: 10).fill(AppTheme.primary))
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    /// Other present modals: title from presentationId, body from say (existing behavior).
    private var genericContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(presentation.presentationId)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)

            if let say = presentation.say, !say.isEmpty {
                Text(say)
                    .font(.system(size: 17))
                    .foregroundColor(.secondary)
            }

            Spacer(minLength: 16)

            Button("Close") {
                onDismiss()
            }
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(RoundedRectangle(cornerRadius: 10).fill(AppTheme.primary))
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
