# Navoice SDK -- Production Troubleshooting Guide

This document provides production-level troubleshooting guidance for iOS integrations.

------------------------------------------------------------------------

## 🔐 License & Authentication Issues

### 1. License not active

**Symptom** - SDK shows banner: `License not active` - Navigation does
not execute

**Cause** - `projects.license_status` is not `trial` or `active`

**Resolution** - Verify Stripe subscription is active or trial started -

If you recently subscribed and still see ‘License not active’, contact support with your account email + timestamp + requestId from browser network tab.

------------------------------------------------------------------------

### 2. Invalid publishable_key

**Symptom** - Backend returns: `Invalid publishable_key`

**Resolution** - Use exact value from `projects.publishable_key` from the portal.

------------------------------------------------------------------------

### 3. Identifier is not allowed for this project

**Symptom** - Backend returns:
`Identifier is not allowed for this project`

**Cause** No matching row in `project_allowed_identifiers` for: -
`project_id` - `platform` - `identifier`

**Resolution** Add identifier in portal: - iOS → `bundle_id` 

**Example `/api/license/validate` request body (iOS):**

```json
{
  "publishable_key": "YOUR_PUBLISHABLE_KEY",
  "platform": "ios",
  "bundle_id": "com.yourcompany.yourapp"
}
```

------------------------------------------------------------------------

## 📱 iOS Framework Integration Issues

### 4. Framework not working after integration

**Symptom:**
- SDK does nothing
- No voice / no routing

**Cause:**
- XCFramework not embedded properly

**Resolution:**
- Ensure "Embed & Sign" is enabled in Xcode
- Check framework is added to the correct target

---

### 5. Missing Info.plist configuration

**Symptom:**
- License validation fails
- SDK not initialized

**Cause:**
- Missing required keys

**Resolution:**
Add to Info.plist:

```xml
<key>NavoicePublishableKey</key>
<string>YOUR_PUBLISHABLE_KEY</string>

<key>NSMicrophoneUsageDescription</key>
<string>Voice commands require microphone access</string>
```

------------------------------------------------------------------------

## 🎤 STT Issues

### 6. STT fails

**Possible Causes** - Backend issue

If STT mode uses server transcription and you get STT errors, contact support. 

------------------------------------------------------------------------

## 🧭 Navigation Issues

### 7. Voice works but no navigation

**Cause** - Missing route mapping - `navigate` callback not passed -
Spec does not contain matching task

**Checklist** - `/spec.json` loads successfully - `routes` contains all
`screenId` values - `navigate` is correctly wired

------------------------------------------------------------------------

## ✅ Production Validation Checklist

Before release, verify:

-   [ ] publishable_key correct
-   [ ] license_status is trial or active
-   [ ] identifier registered in portal
-   [ ] /api/license/validate returns JWT
-   [ ] Protected endpoints receive Bearer token
-   [ ] Spec loaded successfully
-   [ ] Routes match spec screenIds

------------------------------------------------------------------------

## 🏗 Architecture Overview

    App iOS
        ↓
    Navoice SDK
        ↓
    POST /api/license/validate
        ↓
    License Gate (publishable_key + identifier + status)
        ↓
    JWT Minted
        ↓
    Protected APIs (/api/stt, /api/interpret)
        ↓
    Navigation Result
