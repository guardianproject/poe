# 0.5.1
- Updated dependency Localize to version 2.2.0 witch is now fully Swift 5 compliant.
- Added missing translations (still incomplate) for "Scan QR Code".

# 0.5.0
- Updated to Xcode 10.2/Swift 5.
- Breaking change: `BridgeSelectViewController#init` renamed to `BridgeSelectViewController#instantiate`.

# 0.4.3
- Minor update to French translation.
- Fixed CocoaPods Swift language configuration.
- Use CocoaPods 1.6.1.

# 0.4.2
- Allow an explicit delegate on `BridgeSelectViewController` to support situations, 
where the presentingViewController and the callback delegate are not the same.

# 0.4.1
- Adapted to changed signature of `AVCaptureMetadataOutputObjectsDelegate` callback method.

#  0.4.0
- Fixed sizing of `IntroViewController`'s "Use a Bridge" and "Continue Without" buttons
  for languages where translation is rather long.
- Updated existing and added more languages (partly stubs only): Breton, Greek, Gujarati, 
  Hebrew, Indonesian, Italian, Macedonian, Polish, Romanian, Turkish, Vietnamese
- Updated to Swift 4.2.
- Updated dependencies.
