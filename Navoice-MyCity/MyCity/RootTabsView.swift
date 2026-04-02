//
//  RootTabsView.swift
//  MyCity
//
//  Tab shell: Education, Events, Recycle, Taxes. Floating mic button.
//  Integrated with NavoiceSDK: routeAudio (STT + routing) for voice; route(text:) for typed.
//

import SwiftUI
import NavoiceSDK
typealias NavoiceResultHandler = @MainActor @Sendable (NavoiceResult) -> Void

struct RootTabsView: View {
    
    enum Tab: Hashable { case education, events, recycle, taxes }
    
    enum MicState: Equatable { case speak, listening, thinking }
    
    // ✅ ADDED: Navoice instance comes from .environmentObject(...) in MyCityApp
    @EnvironmentObject private var navoice: Navoice
    @EnvironmentObject private var presentationPresenter: PresentationPresenter

    @State private var selectedTab: Tab = .education
    @State private var micState: MicState = .speak
    
    // Badge UI
    @State private var showBadge: Bool = false
    @State private var badgeColor: Color = .clear
    @State private var badgeTimerTask: DispatchWorkItem?
    
    // ✅ ADDED: bind onResult once (used when SDK invokes it; voice path uses routeAudio completion)
    @State private var didBindNavoice: Bool = false

    /// Audio capture for routeAudio (STT). Idle → Listening (recording) → Thinking (STT + routing) → Idle.
    @State private var audioCapture = AudioCaptureHelper()

    // Text input mode (pencil button): independent of mic permission
    @State private var isTextInputMode: Bool = false
    @State private var textInput: String = ""
    @State private var textInputHint: String? = nil
    @FocusState private var isTextFieldFocused: Bool
    @State private var showMissingKeyAlert = false
    
    private var hasPublishableKey: Bool {
        let key = (Bundle.main.infoDictionary?["NavoicePublishableKey"] as? String)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        return !key.isEmpty && key != "MISSING_PUBLISHABLE_KEY"
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottomTrailing) {

                TabView(selection: $selectedTab) {
                    EducationView()
                        .tabItem { Label("Education", systemImage: "book.closed.fill") }
                        .tag(Tab.education)
                    
                    EventsView()
                        .tabItem { Label("Events", systemImage: "calendar") }
                        .tag(Tab.events)
                    
                    RecycleView()
                        .tabItem { Label("Recycle", systemImage: "arrow.2.circlepath") }
                        .tag(Tab.recycle)
                    
                    TaxesView()
                        .tabItem { Label("Taxes", systemImage: "dollarsign.circle.fill") }
                        .tag(Tab.taxes)
                }
                .tint(AppTheme.primary)
                
                // Voice bar: mic + pencil, or text input row (pencil always available regardless of mic permission)
                voiceBarView(bottomSafe: proxy.safeAreaInsets.bottom)
                    .padding(.trailing, 16)
                    .padding(.bottom, 8 + proxy.safeAreaInsets.bottom)
                
                    .alert("Missing Publishable Key", isPresented: $showMissingKeyAlert) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text("Please configure NavoicePublishableKey in Info.plist to enable voice and text routing.")
                    }
            }
            .onAppear {
                bindNavoiceIfNeeded()
                print("DEBUG hasPublishableKey = \(hasPublishableKey)")
                print("DEBUG plist key = \(Bundle.main.infoDictionary?["NavoicePublishableKey"] ?? "nil")")
                
                if !hasPublishableKey {
                    showMissingKeyAlert = true
                }
            }
            .sheet(item: $presentationPresenter.pendingPresentation) { presentation in
                PresentationSheetView(presentation: presentation) {
                    presentationPresenter.dismiss()
                }
            }
        }
    }

    // MARK: - Voice bar (mic + text input mode)

    private func voiceBarView(bottomSafe: CGFloat) -> some View {
        HStack(alignment: .center, spacing: 12) {
            if isTextInputMode {
                textInputRow
            } else {
                // Default: blue pencil (left) + mic (right)
                pencilButton
                micFloatingButton
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isTextInputMode)
    }

    /// Blue circular pencil button – toggles text input mode. Shown regardless of mic permission.
    private var pencilButton: some View {
        Button {
            if !hasPublishableKey {
                showMissingKeyAlert = true
                return
            }
            withAnimation {
                isTextInputMode = true
                textInputHint = nil
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isTextFieldFocused = true
            }
        } label: {
            Image(systemName: "pencil")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(AppTheme.primary)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                )
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Text input mode")
    }

    /// Text mode row: pencil (toggle off) + green send + rounded text field.
    private var textInputRow: some View {
        VStack(alignment: .leading, spacing: 4) {
        HStack(spacing: 10) {
            Button {
                withAnimation {
                    isTextInputMode = false
                    isTextFieldFocused = false
                    textInput = ""
                    textInputHint = nil
                }
            } label: {
                Image(systemName: "pencil")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(
                        Circle()
                            .fill(AppTheme.primary)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    )
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Close text input")

            Button {
                submitTextInput()
            } label: {
                Image(systemName: "play.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 48, height: 48)
                    .background(
                        Circle()
                            .fill(AppTheme.secondary)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    )
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Send")

            HStack(spacing: 8) {
                TextField("Type your request…", text: $textInput)
                    .textFieldStyle(.plain)
                    .font(.system(size: 16))
                    .focused($isTextFieldFocused)
                    .submitLabel(.send)
                    .onSubmit { submitTextInput() }

                Button {
                    withAnimation {
                        isTextInputMode = false
                        isTextFieldFocused = false
                        textInput = ""
                        textInputHint = nil
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color(.systemGray3))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(Color(.systemGray6))
            )
            .overlay(
                Capsule()
                    .stroke(Color(.separator).opacity(0.5), lineWidth: 1)
            )
        }
        .padding(.vertical, 4)

        if let hint = textInputHint {
            Text(hint)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        }
        .onChange(of: isTextInputMode) { _, show in
            if !show {
                isTextFieldFocused = false
            }
        }
    }

    private func submitTextInput() {
        if !hasPublishableKey {
            showMissingKeyAlert = true
            return
        }
        let text = textInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else {
            textInputHint = "Enter something to send"
            return
        }
        textInputHint = nil
        bindNavoiceIfNeeded()
        routeTypedText(text)
        withAnimation {
            isTextInputMode = false
            textInput = ""
            isTextFieldFocused = false
        }
    }

    /// Routes typed text through the same Navoice pipeline as voice; result is passed to the shared handler.
    private func routeTypedText(_ text: String) {
        let locale = (Bundle.main.infoDictionary?["NavoiceLocale"] as? String) ?? "en-US"
        print("[MyCity][Typed] text='\(text)' locale=\(locale)")

        bindNavoiceIfNeeded()

        Task {
            do {
                let res = try await navoice.route(text: text)
                await MainActor.run {
                    handleNavoiceResult(res, originalText: text)
                }
            } catch {
                print("[MyCity][TypedRoute] error: \(error)")
            }
        }
    }

    // MARK: - Mic UI

    private var micFloatingButton: some View {
        ZStack(alignment: .topTrailing) {

            Button {
                print("✅ MIC BUTTON TAP FIRED")
                micButtonTapped()
            } label: {
                micIcon
                    .frame(width: 56, height: 56)
                    .background(
                        Circle()
                            .fill(backgroundColor)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    )
                    .foregroundColor(.white)
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(micAccessibilityLabel)

            if showBadge {
                Circle()
                    .fill(badgeColor)
                    .frame(width: 12, height: 12)
                    .overlay(Circle().stroke(Color.white, lineWidth: 1.5))
                    .offset(x: 8, y: -8)
                    .accessibilityHidden(true)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showBadge)
    }
    
    private var micIcon: some View {
        Group {
            switch micState {
            case .speak:
                Image(systemName: "mic.fill")
                    .font(.system(size: 24, weight: .semibold))
                
            case .listening:
                // ✅ FIX: show STOP icon (no fancy animations for now)
                Image(systemName: "stop.fill")
                    .font(.system(size: 22, weight: .bold))
                
            case .thinking:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(.white)
            }
        }
    }
    
    private var backgroundColor: Color {
        switch micState {
        case .speak: return AppTheme.primary
        case .listening: return .green
        case .thinking: return .orange
        }
    }
    
    private var micAccessibilityLabel: String {
        switch micState {
        case .speak: return "Tap to start listening"
        case .listening: return "Tap to stop and process"
        case .thinking: return "Processing"
        }
    }
    
    // MARK: - Mic actions (STT: capture audio → routeAudio)

    private func micButtonTapped() {
        if !hasPublishableKey {
            showMissingKeyAlert = true
            return
        }
        bindNavoiceIfNeeded()

        switch micState {
        case .speak:
            audioCapture.requestPermission { [self] granted in
                guard granted else {
                    print("[MyCity][STT] Mic permission denied")
                    return
                }
                print("[MyCity][STT] start recording")
                audioCapture.startRecording { [self] success, message in
                    if success {
                        withAnimation { micState = .listening }
                    } else {
                        print("[MyCity][STT] start failed: \(message ?? "unknown")")
                    }
                }
            }

        case .listening:
            withAnimation { micState = .thinking }
            print("[MyCity][STT] stop recording → routeAudio")
            audioCapture.stopRecording { [self] data in
                guard let audioData = data, !audioData.isEmpty else {
                    print("[MyCity][STT] no audio data")
                    DispatchQueue.main.async { withAnimation { self.micState = .speak } }
                    return
                }
                let locale = (Bundle.main.infoDictionary?["NavoiceLocale"] as? String) ?? "en-US"
                navoice.routeAudio(audioData, locale: locale) { result in
                    DispatchQueue.main.async {
                        if result.sttUsed {
                            print("[MyCity][STT] success; routing invoked")
                            if let sttDuration = result.timings?.stt {
                                print("[MyCity][STT] stt duration: \(sttDuration)")
                            }
                        }
                        withAnimation { self.micState = .speak }
                        self.handleNavoiceResult(result.result, originalText: "<voice>")
                    }
                }
            }

        case .thinking:
            break
        }
    }
    
    // MARK: - Navoice binding
    
    private func bindNavoiceIfNeeded() {
        guard didBindNavoice == false else { return }
        didBindNavoice = true
        
        navoice.onResult = { (res: NavoiceResult) in
            print("NAVOICE RESULT => \(res)")
            Task { @MainActor in
                withAnimation { self.micState = .speak }
                self.handleNavoiceResult(res, originalText: "<voice>")
            }
        }

        //navoice.onResult = handler
    }

    @MainActor
    private func handleNavoiceResult(_ result: NavoiceResult, originalText: String?) {
        switch result {
        case .execute(let screenId, let params, let say, let confidence, let taskId):
            print("EXECUTE screenId=\(screenId) params=\(params) taskId=\(String(describing: taskId))")
            showBadgeWith(color: .green, duration: 1.5)
            route(screenId: screenId, params: params)

        case .present(let presentationId, let params, let say, _, _):
            presentationPresenter.present(presentationId: presentationId, params: params, say: say)

        case .unsupported:
            showBadgeWith(color: .red, duration: 5.0)

        case .showChoices:
            showBadgeWith(color: .red, duration: 5.0)
        }
    }

    // MARK: - Routing (screenId -> tabs)
    
    private func route(screenId: String, params: [String: String]) {
        let id = screenId.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        withAnimation {
            switch id {
            case "education":
                selectedTab = .education
            case "events":
                selectedTab = .events
            case "recycle":
                selectedTab = .recycle
            case "taxes":
                selectedTab = .taxes
            default:
                // If spec returns something unknown -> show red
                showBadgeWith(color: .red, duration: 5.0)
            }
        }
        
        _ = params // keep for future deep-links
    }
    
    private func showBadgeWith(color: Color, duration: TimeInterval) {
        badgeTimerTask?.cancel()
        
        badgeColor = color
        showBadge = true
        
        let task = DispatchWorkItem {
            showBadge = false
        }
        
        badgeTimerTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
    }
}
