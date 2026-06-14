# MyCity-iOS — AUDIT.md

## What was scanned

All Swift source files in `MyCity/`. `MyCity.xcodeproj/project.pbxproj`. `NavoiceSDK.xcframework/Info.plist`. `mycity_spec.json`.

## What the project appears to do

A SwiftUI iOS reference application demonstrating Navoice voice-driven navigation in a municipal services context. Users can navigate to Taxes, Recycling, Events, and Education sections by voice command. The app integrates the Navoice SDK via a pre-built XCFramework and a `mycity_spec.json` that maps voice intents to screen IDs.

## Current architecture

- SwiftUI app with a tab bar (`RootTabsView`).
- Four content tabs: Taxes, Recycle, Events, Education.
- `AudioCaptureHelper` manages `AVAudioSession` and microphone capture.
- `PresentationPresenter` handles Navoice results of type "present" (modal/sheet presentation).
- `AppTheme` and `MyCityComponents` provide a shared design system.
- `AppUserProfile` manages user profile state.
- `NavoiceSDK.xcframework` is embedded as a pre-built binary (not via SPM).

## Main flows

1. **App launch** — init NavoiceSDK with publishable key + spec
2. **User taps mic** → `AudioCaptureHelper` starts recording
3. **Recording ends** → SDK processes audio (local or cloud STT)
4. **Result "execute"** → app navigates to the matching tab
5. **Result "show_choices"** → disambiguation UI shown
6. **Result "present"** → `PresentationPresenter` shows modal

## API endpoints consumed (via SDK)

| Endpoint | Purpose |
|---|---|
| `POST /api/license/validate` | License init |
| `POST /api/interpret` | Text routing |
| `POST /api/stt` | Cloud STT |

## Dependencies

- `NavoiceSDK.xcframework` (pre-built, local)
- Apple frameworks: SwiftUI, AVFoundation, Speech, Combine

## Missing documentation

- No README at the project root.
- Publishable key configuration is not documented.
- No documented steps to rebuild the XCFramework after SDK-iOS updates.
- `SplashView.swift` is in `MyCity.xcodeproj/` (not in `MyCity/`) — unusual placement, undocumented.

## Duplicated logic

- `mycity_spec.json` is a copy also present in `MyCity-Web/public/` and `MyCity-aOS/app/src/main/assets/`. All three must be kept in sync manually.
- `AudioCaptureHelper.swift` may duplicate what SDK-iOS handles internally — needs confirmation on where mic management responsibility lies.

## Security concerns

- Publishable key is presumably hardcoded in source — should not be a secret but should be documented.
- `NSMicrophoneUsageDescription` is required and present (assumed from Info.plist). If missing, the app crashes on mic access.
- The `NavoiceSDK.xcframework` binary is not signed independently — it relies on the host app's signing.

## Integration risks

- `NavoiceSDK.xcframework` can become stale relative to SDK-iOS. If the xcframework is not rebuilt after SDK changes, the demo may show outdated behavior.
- `mycity_spec.json` task IDs must exactly match the screen IDs the app navigates to. ID mismatch = silent navigation failure.
- Simulator STT is unreliable — cloud STT on device requires valid publishable key and active license.

## Recommended next tasks

1. Add a README with setup instructions and how to update the SDK.
2. Document the XCFramework rebuild process.
3. Clarify the location of `SplashView.swift` — move to `MyCity/` or document why it's in the project file folder.
4. Add a comment or constant documenting the publishable key source.
5. Automate spec sync across MyCity-iOS, MyCity-Web, and MyCity-aOS.
