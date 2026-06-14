# MyCity-iOS — CLAUDE.md

## Project purpose

A reference / demo SwiftUI app demonstrating Navoice SDK integration in an iOS city-services app. Shows how voice navigation works across multiple feature tabs (Taxes, Recycle, Events, Education). Used for demos, testing, and as an integration example for SDK customers.

## Tech stack

- **Language:** Swift (SwiftUI)
- **IDE:** Xcode
- **Platform:** iOS (target version — needs confirmation from project settings)
- **SDK integration:** `NavoiceSDK.xcframework` (pre-built, embedded in repo)
- **No external package manager** (Pods or SPM) — SDK is included as a pre-built framework

## Important folders

```
MyCity/
  MyCityApp.swift             App entry point
  ContentView.swift           Root content view
  RootTabsView.swift          Tab bar controller
  TaxesView.swift             Taxes tab
  RecycleView.swift           Recycling tab
  EventsView.swift            Events tab
  EducationView.swift         Education tab
  Models.swift                Data models
  MyCityComponents.swift      Shared UI components
  AppTheme.swift              Colors, fonts, design system
  AppUserProfile.swift        User profile state
  AudioCaptureHelper.swift    Microphone capture helper
  PresentationPresenter.swift Handles Navoice "present" result type
  mycity_spec.json            Navoice spec (task → screen mapping for this app)
  Info.plist                  App settings (includes microphone permission string)
  Assets.xcassets/            Images and icons
NavoiceSDK.xcframework/       Pre-built iOS SDK (arm64 device + arm64/x86_64 simulator)
MyCity.xcodeproj/             Xcode project
```

## Important files

| File | Purpose |
|---|---|
| `MyCity/mycity_spec.json` | The Navoice spec for this demo app — defines voice commands |
| `MyCity/MyCityApp.swift` | SDK initialization on app launch |
| `MyCity/AudioCaptureHelper.swift` | Manages microphone session for Navoice |
| `NavoiceSDK.xcframework/` | Pre-built SDK — do not modify; rebuild from SDK-iOS if needed |
| `MyCity.xcodeproj/project.pbxproj` | Xcode project file |

## Environment variables

None — iOS app has no environment variable system. Configuration is hardcoded or in Info.plist.

The Navoice `publishableKey` is likely hardcoded in `MyCityApp.swift` (needs confirmation).
The backend base URL defaults to `https://api.navoice.io` (SDK default).

## External services

- **Navoice Backend** (via SDK) — license validate, STT, interpret
- **SFSpeechRecognizer** (Apple) — used for local STT. Note: depending on device settings and locale, Apple may route some recognition to its own servers. Not guaranteed to be purely on-device. Require microphone and speech recognition permissions in Info.plist.

## How this project connects to the rest of Navoice

- Integrates `NavoiceSDK.xcframework` (built from SDK-iOS).
- Uses `mycity_spec.json` which mirrors the spec in `MyCity-Web` and `MyCity-aOS`.
- Demonstrates the same user flows as `MyCity-Web` and `MyCity-aOS` on iOS.
- Used for SDK customer demos and integration validation.

## Do-not-break rules

- **`NavoiceSDK.xcframework`** — do not modify binary files. If SDK-iOS is updated, rebuild the xcframework and replace the folder.
- **`mycity_spec.json`** — task IDs must match tab names exactly. If IDs change, voice navigation breaks.
- **`Info.plist` permission strings** — `NSMicrophoneUsageDescription` and `NSSpeechRecognitionUsageDescription` must remain present. Removing them crashes the app on first mic use.
- **`AudioCaptureHelper.swift`** — handles AVAudioSession configuration. Changes here affect microphone + speaker behavior across the whole app.

## Common development tasks

- **Update the spec:** edit `MyCity/mycity_spec.json`. Match IDs to SwiftUI view names.
- **Update the SDK:** rebuild `NavoiceSDK.xcframework` from SDK-iOS, replace `NavoiceSDK.xcframework/` folder.
- **Add a new tab:** create a new `*View.swift`, add to `RootTabsView.swift`, add a task entry in `mycity_spec.json`.
- **Test voice navigation:** run on device (simulator has limited STT support).

## Build / run / test commands

```
# Open in Xcode
open MyCity.xcodeproj

# Build and run on simulator: Cmd+R in Xcode
# Build and run on device: Cmd+R with device selected

# No automated test targets visible in project structure
```

## Known risks

- `NavoiceSDK.xcframework` is a manually managed binary — easy to become out of sync with SDK-iOS.
- `SplashView.swift` is inside `MyCity.xcodeproj/` folder (unusual location — normally source is in `MyCity/`). Needs confirmation.
- No automated tests.
- Simulator has limited `SFSpeechRecognizer` support — full testing requires a physical device.
- Publishable key is hardcoded (presumed) — needs to be rotated if leaked.
