# Navoice iOS SDK

**Version:** 1.0.0  
**Platform:** iOS 15+  
**Distribution:** XCFramework

Voice-driven navigation for iOS. Navoice turns spoken phrases into structured navigation results so your app can route users by voice—for example: “Open events”, “Go to education”, or “Show my subscriber number”.

The SDK is **UI-agnostic**: it works with SwiftUI, UIKit, or mixed apps. **Your app owns navigation and UI**; Navoice focuses on speech, intent detection, and routing. **Callbacks are delivered on the main thread**, so you can update the interface directly from handlers such as `onResult`.

---

## What’s in this repository

This repository includes:

- **`NavoiceSDK.xcframework`** — the Navoice iOS SDK, delivered as an **XCFramework** (prebuilt binary; no SDK source in the framework).
- **`Navoice-MyCity`** — a demo iOS application that shows a complete integration pattern.

> **Swift Package Manager:** The same SDK is also buildable from the Swift package sources in this repo (`Package.swift`). For most app integrations, linking the **XCFramework** is the recommended path.

---

## Demo application: Navoice-MyCity

**Navoice-MyCity** is a reference iOS app shipped alongside the SDK. It is **disabled for real use until you configure your own project credentials** (publishable key and allowed bundle identifier). Out of the box it illustrates wiring, lifecycle, and result handling—not a production-ready tenant.

### What the demo is for

Use **Navoice-MyCity** to:

- Study a **reference integration** end to end  
- **Test** the SDK against your Navoice project  
- Use as a **starting point** for a production integration (replace branding, navigation, and spec as needed)

---

## Setting up the demo app (Navoice-MyCity)

1. **Open the Navoice-MyCity project** in Xcode (the demo target included in this repository).

2. **Go to the Navoice Portal** (sign in with your organization’s Navoice account).

3. **Open your project** in the portal.

4. **Copy the Publishable Key** for that project.

5. In Xcode, select the **Navoice-MyCity** app target → **Info** tab (or open the target’s **Info.plist**).

6. Set **`NavoicePublishableKey`** to the key you copied (see [Configuration](#configuration-infoplist)).

7. Still in the portal, on the **same project**, add your app’s **Bundle Identifier** under **Allowed Identifiers** (sometimes labeled similarly on the project page—allow-list for client apps).

8. **Find your Bundle Identifier in Xcode:** select the app target → **General** → **Identity** → **Bundle Identifier**. It must **exactly match** the value you registered in the portal.

9. Build and run on a device or simulator (microphone where required).

**License validation:** the SDK validates the app using your publishable key and the **host app’s bundle ID**. If the bundle identifier is **not** registered under **Allowed Identifiers** for that project, **license validation will fail** and voice features will not work as expected.

---

## Requirements

- **iOS 15** or later  
- **Xcode** compatible with your chosen integration (SwiftUI and/or UIKit)  
- Microphone access where you use voice input (see [Permissions](#permissions))

---

## Installation

1. Add **`NavoiceSDK.xcframework`** to your Xcode project (drag into the Project Navigator, or **File → Add Files…**).

2. In the target’s **Frameworks, Libraries, and Embedded Content** (or **General → Frameworks**):

   - Add **NavoiceSDK**  
   - Set embed to **Embed & Sign**

3. **Import** in Swift:

   ```swift
   import NavoiceSDK
   ```

---

## Quick start

1. Add **`NavoiceSDK.xcframework`** and embed **Embed & Sign**.  
2. Add your **publishable key** and optional keys to **Info.plist** ([Configuration](#configuration-infoplist)).  
3. Register your app’s **Bundle Identifier** under **Allowed Identifiers** in Navoice Portal.  
4. Add your **navigation spec** JSON to the app bundle.  
5. Create **`Navoice(specResourceName: "your_spec")`** (name without `.json`).  
6. Set **`onResult`** and call **`startVoice()`** when you want listening to begin.

---

## Configuration (Info.plist)

Configure the SDK via your app’s **Info.plist** (target → **Info** or `Info.plist` source).

| Key | Type | Required | Description |
|-----|------|----------|-------------|
| `NavoicePublishableKey` | String | Yes | Publishable key from Navoice Portal → your project. |
| `NavoiceLocale` | String | No | BCP 47 style locale (e.g. `en-US`) or `auto` for multilingual detection. Defaults to `en-US` if omitted. |
| `NavoiceSTTMode` | String | No | Speech-to-text strategy: `localOnly`, `cloudOnly`, `hybrid`, `disabled`. See [STT settings](#speech-to-text-stt-settings). |
| `NavoiceLocalSTTMinConfidence` | Number (Real) | No | Minimum confidence for accepting **local** STT; affects **hybrid** fallback. Default in SDK: `0.65`. See [STT settings](#speech-to-text-stt-settings). |

Optional advanced override (not required for typical integrations):

| Key | Type | Description |
|-----|------|-------------|
| `NavoiceBackendBaseURL` | String | Override API base URL (e.g. staging). Defaults to production. |

### Example `Info.plist` fragment

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>NavoicePublishableKey</key>
	<string>YOUR_PUBLISHABLE_KEY</string>

	<key>NavoiceLocale</key>
	<string>auto</string>

	<key>NavoiceSTTMode</key>
	<string>hybrid</string>

	<key>NavoiceLocalSTTMinConfidence</key>
	<real>0.65</real>

	<key>NSMicrophoneUsageDescription</key>
	<string>Voice commands require microphone access.</string>
 
    <key>NSSpeechRecognitionUsageDescription</key>
    <string>Navoice uses speech recognition to enable voice navigation</string>   
</dict>
</plist>
```

Use your real **Publishable Key** and keep **Allowed Identifiers** in sync with your **Bundle Identifier**.

---

## Speech-to-text (STT) settings

### A. `NavoiceSTTMode` (String)

Controls how spoken audio is turned into text.

| Value | Meaning |
|-------|---------|
| **`localOnly`** | Use on-device speech recognition only. No cloud STT. |
| **`cloudOnly`** | Send audio to Navoice cloud STT (when supported by your configuration). |
| **`hybrid`** | Prefer local recognition; if the local result is weak or missing, fall back to cloud STT when available. **Recommended** for a good balance of latency, privacy, and accuracy. |
| **`disabled`** | Do not run STT in the SDK path that depends on this mode (useful when you only route typed text or custom pipelines). |

**Recommendation:** set **`hybrid`** explicitly for most production apps. If you omit `NavoiceSTTMode`, the SDK defaults to **`localOnly`**.

Values are matched case-insensitively (e.g. `cloudOnly` or `cloudonly`).

### B. `NavoiceLocalSTTMinConfidence` (Number / Real)

Sets the **minimum confidence** the SDK requires to **accept a local STT transcript** as good enough to route.

- If local recognition confidence is **below** this threshold (or confidence is unavailable), the SDK **may fall back to cloud STT** when **`NavoiceSTTMode`** is **`hybrid`** (or when using paths that allow cloud fallback).
- **`0.65`** is a **balanced default** (and matches the SDK’s built-in default when the key is omitted).
- **Lower** values → more permissive (accept more local transcripts; less cloud fallback).
- **Higher** values → stricter (more local rejects; more cloud fallback in hybrid mode, where allowed).

### Multilingual STT and language=auto

For multilingual apps, use **`NavoiceLocale = auto`**.

- This is required for mixed Hebrew/English voice input.
- Do not hardcode `en-US` or `he-IL` when the app supports multiple languages.
- `auto` allows the SDK pipeline to detect and route mixed-language utterances.

---

## Initialize the SDK

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

The `specResourceName` is the JSON file in your bundle **without** the `.json` suffix (e.g. `mycity_spec` → `mycity_spec.json`).

---

## SwiftUI integration
Navigation handling is implemented by your app. Navoice only returns routing results (execute / present). This applies to both SwiftUI and UIKit apps.

```swift
@EnvironmentObject var navoice: Navoice

.onAppear {
    navoice.onResult = { result in
        switch result {

        case .execute(let screenId, let params, _, _, _):
            handleNavigation(screenId, params)

        case .present(let presentationId, let params, let say, _, _):
            presentSheet(id: presentationId, params: params, say: say)

        case .showChoices:
            showChoicesUI()

        case .unsupported:
            handleUnsupported()
        }
    }
}
```

Start and stop voice when it fits your UX:

```swift
navoice.startVoice()
navoice.stopVoice()
```

## Floating microphone button (SwiftUI)

```swift
@State private var isListening = false

Button(action: {
    if isListening {
        navoice.stopVoice()
    } else {
        navoice.startVoice()
    }

    isListening.toggle()
}) {
    Image(systemName: isListening ? "mic.fill" : "mic")
        .font(.system(size: 24))
        .foregroundColor(.white)
        .frame(width: 64, height: 64)
        .background(isListening ? Color.red : Color.blue)
        .clipShape(Circle())
}
```
---

## UIKit integration

Navoice works with **UIKit** apps: initialize in `AppDelegate`, `SceneDelegate`, or a long-lived owner (e.g. root coordinator), then call `startVoice()` / `stopVoice()` from view controllers.

### Initialize (example: `AppDelegate`)

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

### Start voice

```swift
navoice.startVoice()
```

---

## Result handling

Set **`onResult`** once (or when your root UI appears). Handle each `NavoiceResult` case and perform navigation / modals in **your** code.

### Full example (UIKit-style handlers)

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

### Catalog-aware handling guidance

- `execute` with `screenId == "catalogItemDetails"` means a catalog item was found.
- Demo apps may show **“Item Found”**.
- Production apps should navigate to the real item details page using `params`.
- `showChoices` means the client must show a popup/list and map the selected option to a catalog item.

### Example navigation

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

### Present modal example

```swift
func presentModal(id: String, params: [String: Any]) {

    let vc = PublishableKeyViewController()
    vc.modalPresentationStyle = .pageSheet
    present(vc, animated: true)
}
```

---

## Result types

| Case | Description |
|------|-------------|
| `execute` | Navigate to a screen (your app pushes/presents the destination). |
| `present` | Show a modal or sheet (your app presents the UI). |
| `showChoices` | Multiple intents detected; prompt the user to choose. |
| `unsupported` | No matching intent (show help or fallback UX). |

---

## Threading

**All Navoice callbacks (including `onResult`) are delivered on the main thread** (main actor). You can update SwiftUI state and UIKit views directly inside those closures.

---

## Minimal example

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

---

## Handling unsupported commands

```swift
case .unsupported:
    showUnsupportedUI()
```

---

## App lifecycle

Stop voice when the app moves to the background (or when your UX requires it):

```swift
navoice.stopVoice()
```

Restart listening when the user returns to a context where voice is appropriate.

---

## Architecture

Navoice is:

- **UI-agnostic** — no required Navoice screens; you supply UI.  
- **Navigation-agnostic** — you map results to your stack, tabs, or coordinators.  
- **Spec-driven** — behavior is driven by your bundled JSON navigation spec.  
- **Cloud-assisted** — license, semantic routing, and optional cloud STT interact with Navoice services.

Pipeline:

**STT → Normalize → Local Router → Semantic Tasks → Semantic Catalog → Cloud fallback**

---

## Navigation spec

Add a JSON spec to your app bundle (e.g. **`mycity_spec.json`**) and pass `specResourceName: "mycity_spec"`.

The spec defines screens, keywords, examples, and routing metadata your project expects.

**Minimal shape:**

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

Use the spec exported or managed for your Navoice project in the portal where applicable.

### Multilingual spec guidance

- `default_locale` should support multilingual setups (for example `he-IL` + `en-US`).
- `languageByLocale` should be removed or set to `"auto"`.

---

## Semantic Catalog

Semantic Catalog handles dynamic catalog content such as movies, products, courses, and articles.

- It is separate from navigation.
- Navigation intent has priority over catalog.
- Strong catalog match returns `execute`.
- Multiple possible catalog matches return `showChoices`.
- Weak catalog matches are rejected so catalog does not hijack navigation queries.

---

## Semantic Catalog Setup (Portal)

1. Open project in Navoice Portal.
2. Connect catalog JSON URL.
3. Run scan.
4. Map fields such as `id`, `title`, `description`, `image`, `keywords`.
5. Save catalog.
6. Latest saved catalog becomes active.

---

## Semantic Catalog Result Structure

Catalog search results may now include a `params.display` object alongside `params.itemId`. This generic display object carries human-readable fields extracted from your catalog data, so client applications can present rich item information without hardcoding domain-specific logic.

**Example result:**

```json
{
  "kind": "execute",
  "screenId": "catalogItemDetails",
  "params": {
    "itemId": "TITL0000000000000027",
    "display": {
      "title": "The Shawshank Redemption",
      "actors": [
        "Tim Robbins",
        "Morgan Freeman"
      ],
      "image": "https://...",
      "description": "Two imprisoned men bond over a number of years..."
    }
  }
}
```

---

## Generic Display Fields

In the Navoice Portal, you can define `displayFields` in your Semantic Catalog mapping. These fields are extracted dynamically from `semantic_items.raw` at query time and returned in `params.display`.

**Example mapping:**

```json
"displayFields": {
  "title": "title",
  "actors": "credits.actors",
  "image": "media[].url",
  "description": "synopsis"
}
```

This mechanism works for any catalog domain:

- Movies and TV series
- Products and e-commerce catalogs
- Restaurants
- Documents
- Real estate listings
- Medical providers (e.g. dentists, doctors)
- Any custom JSON catalog

---

## Client Rendering Recommendations

Use the following fallback order when choosing a human-readable label from a catalog result:

1. `params.display.title`
2. `params.display.name`
3. `params.display.label`
4. `params.itemId`

This covers common catalog domains:

- Movies → `title`
- Products → `name`
- Generic items → `label`
- Final fallback → `itemId`

**Swift example:**

```swift
let display = result.params["display"] as? [String: Any]
let label =
    (display?["title"] as? String) ??
    (display?["name"] as? String) ??
    (display?["label"] as? String) ??
    (result.params["itemId"] as? String) ??
    ""
```

---

## Backward Compatibility

- `params.itemId` remains unchanged — existing integrations continue to work without modification.
- `params.display` is **optional and additive**; it will not appear if no `displayFields` are configured.
- Applications that do not need richer presentation may safely ignore `params.display`.
- No database migration, catalog re-save, or catalog re-sync is required.
- Existing `semantic_items.raw` data is used to populate display fields dynamically at query time.

---

## Runtime Flow

1. Local Spec routing
2. Semantic Tasks
3. Semantic Catalog
4. Cloud Interpret fallback

---

## Cross-platform note

This behavior is aligned across iOS, Web, and Android.

---

## Permissions

Add a microphone usage string so iOS can show the system prompt:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>Voice commands require microphone access.</string>
```

---

## Voice lifecycle

```swift
navoice.startVoice()
navoice.stopVoice()
```

---

## Text routing

You can route typed or programmatic text through the same pipeline:

```swift
let result = try await navoice.route(text: "show my subscriber number")
```

---

## UI integration notes

You may:

- Use **optional** SDK UI helpers (e.g. mic affordances) where provided  
- **Build your own** controls and call `startVoice()` / `stopVoice()` yourself  
- Trigger voice **programmatically** from buttons or gestures  

The SDK does not replace your design system—it **emits results**; you **render** the experience.

---

## Responsibilities

**SDK**

- Speech recognition (per `NavoiceSTTMode`)  
- Intent detection and routing  
- License validation  
- Communication with Navoice backends as needed  

**Your app**

- **Navigation and UI**  
- Presenting sheets, tabs, and deep links  
- Microphone permission UX and product copy  

---

## Security

- Integration uses a **publishable** key (safe for client apps).  
- **License** is validated server-side against your project and **bundle identifier**.  
- Short-lived tokens are used for protected API calls where applicable.

---

## Binary distribution

- Shipped as **`NavoiceSDK.xcframework`**.  
- **No** SDK source inside the framework binary.  
- Integrates like any other native iOS XCFramework (**Embed & Sign**).

---

## Production checklist

- [ ] **`NavoiceSDK.xcframework`** added and set to **Embed & Sign**  
- [ ] **`NavoicePublishableKey`** set in **Info.plist**  
- [ ] App **Bundle Identifier** registered under **Allowed Identifiers** in Navoice Portal  
- [ ] **`NavoiceSTTMode`** chosen (recommend **`hybrid`**) and **`NavoiceLocalSTTMinConfidence`** tuned if needed  
- [ ] Navigation **spec** JSON added to the bundle  
- [ ] SDK **initialized** with correct `specResourceName`  
- [ ] **`onResult`** implemented for all relevant cases  
- [ ] **`NSMicrophoneUsageDescription`** present  
- [ ] NSSpeechRecognitionUsageDescription present
- [ ] **Background / foreground** behavior tested (`stopVoice` / `startVoice` as needed)

---

## Support

**Email:** contact@navoice.io  

For portal access, keys, and **Allowed Identifiers**, use **Navoice Portal** → your **project** settings.
