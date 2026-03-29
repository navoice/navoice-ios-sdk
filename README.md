# Navoice iOS SDK

Version: 1.0.0  
Platform: iOS  
Distribution: XCFramework

Voice-driven navigation SDK for iOS applications.

Navoice enables users to control your app using natural language voice commands such as:
- “Open events”
- “Go to education”
- “Show my subscriber number”

The SDK returns structured navigation results — your app remains fully in control of UI and routing.
Navoice is UI-agnostic.  
It works with SwiftUI, UIKit, and hybrid applications.

---

## Requirements

Navoice supports both SwiftUI and UIKit applications.

- iOS 15+
- SwiftUI or UIKit supported

---

## Quick Start (2 Minutes)

1. Add `NavoiceSDK.xcframework` to your project  
2. Add your publishable key to `Info.plist`  
3. Add your spec file  
4. Initialize SDK  
5. Call `startVoice()`

Done.

---

## Installation

1. Drag `NavoiceSDK.xcframework` into your Xcode project  
2. Make sure:
   - **Add to target** is checked  
   - **Embed & Sign** is selected  

---

## Configuration

Add to **Info.plist**:

```xml
<key>NavoicePublishableKey</key>
<string>YOUR_PUBLISHABLE_KEY</string>
```

Optional:

```xml
<key>NavoiceLocale</key>
<string>en-US</string>

<key>NavoiceSTTMode</key>
<string>hybrid</string>
```

STT modes: `localOnly`, `cloudOnly`, `hybrid`, `disabled`

---

## Initialize SDK

```swift
import SwiftUI
import NavoiceSDK

@main
struct MyApp: App {

    let navoice = Navoice(specResourceName: "mycity_spec")

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(navoice)
        }
    }
}
```

---

## UIKit Integration

Navoice works with both SwiftUI and UIKit applications.

If your app is built using UIKit, you can initialize and use Navoice in your AppDelegate, SceneDelegate, or root view controller.

### Initialize in UIKit

```swift
import UIKit
import NavoiceSDK

class AppDelegate: UIResponder, UIApplicationDelegate {

    let navoice = Navoice(specResourceName: "mycity_spec")

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        return true
    }
}
```

### Start Voice

```swift
navoice.startVoice()
```

### Full Result Handling Example

```swift
navoice.onResult = { result in
    switch result {

    case .execute(let screenId, let params, _, _, _):
        handleNavigation(screenId, params)

    case .present(let presentationId, let params, let say, _, _):
        presentModal(id: presentationId, params: params)

    case .showChoices:
        showChoicesUI()

    case .unsupported:
        showUnsupportedUI()
    }
}
```

### Example Navigation (UIKit)

```swift
func handleNavigation(_ screenId: String, _ params: [String: Any]) {

    switch screenId {

    case "events":
        navigationController?.pushViewController(EventsViewController(), animated: true)

    case "education":
        navigationController?.pushViewController(EducationViewController(), animated: true)

    default:
        break
    }
}
```

### Present Modal Example

```swift
func presentModal(id: String, params: [String: Any]) {

    let vc = PublishableKeyViewController()
    vc.modalPresentationStyle = .pageSheet
    present(vc, animated: true)
}
```

---

## UI Framework Support

Navoice is UI-agnostic and works with:

- SwiftUI
- UIKit
- Hybrid applications

## Threading

All Navoice callbacks are delivered on the main thread.

You can safely update UI directly from `onResult`.

## Minimal Example

```swift
navoice.onResult = { result in

    switch result {

    case .execute(let screenId, _, _, _, _):
        print("Navigate to:", screenId)

    case .present(let id, _, _, _, _):
        print("Present:", id)

    default:
        break
    }
}

navoice.startVoice()
```

## Handling Unsupported Commands

```swift
case .unsupported:
    showUnsupportedUI()
```

## App Lifecycle

Stop voice when app goes to background:

```swift
navoice.stopVoice()
```

Restart voice when needed.

## Architecture

Navoice is:

- UI agnostic
- Navigation agnostic
- Spec driven
- Cloud assisted

---

## SwiftUI Result Handling

```swift
@EnvironmentObject var navoice: Navoice

.onAppear {
    navoice.onResult = { result in
        switch result {

        case .execute(let screenId, let params, _, _, _):
            handleNavigation(screenId, params)

        case .present(let presentationId, let params, let say, _, _):
            presentSheet(id: presentationId, params: params, say: say)

        case .showChoices, .unsupported:
            handleFailure()
        }
    }
}
```

---

## Result types

| Result | Description |
|--------|---------|
| `execute` | Navigate to a screen |
| `present` | Show modal / sheet |
| `showChoices` | Multiple intents detected |
| `unsupported` | No matching intent |



## Navigation Spec

Add a JSON spec file to your app bundle (for example: `mycity_spec.json`).

Defines:
- screens
- keywords
- examples

Example:

```json
{
  "screens": [
    {
      "id": "home",
      "keywords": ["home", "main"]
    }
  ]
}
```

---

## Permissions

Add to **Info.plist**:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>Voice commands require microphone access.</string>
```

---

## Voice Lifecycle

```swift
navoice.startVoice()
navoice.stopVoice()
```

---

## Text Routing

```swift
let result = try await navoice.route(text: "show my subscriber number")
```

---

## UI Integration

You can:
- Use built-in components (optional)
- Build your own UI
- Trigger voice programmatically

## Responsibilities

**SDK handles:**
- Speech recognition
- Intent detection
- Routing
- License validation

**Your app handles:**
- Navigation
- UI
- User experience

## Security

- Uses publishable key
- License validated via backend
- Short-lived tokens for protected APIs

## Binary Distribution

- Delivered as `XCFramework`
- No source code included
- Integrated like any native iOS framework

## Production Checklist

- [ ] XCFramework added (Embed & Sign)
- [ ] Publishable key configured
- [ ] Spec file added
- [ ] SDK initialized
- [ ] Result handling implemented

## Support
contact@navoice.io
