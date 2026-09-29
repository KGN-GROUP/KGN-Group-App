# KGN GROUP Flutter App

This is the clean Flutter source project for KGN GROUP. It is intended for Android and iPhone from the same Flutter codebase.

## Included
- KGN GROUP branding/logo
- English / Arabic / Hindi / Bengali language selector
- Separate service detail pages
- Electronics
- CCTV & Security System
- Networking & Internet
- Telecommunication
- Video Door Phone
- Audio Door Phone
- Automation
- Smart Home
- Electrical
- AC & HVAC
- Home Appliances
- Preventive Maintenance
- Emergency Maintenance
- Renovation
- Customer quotation/lead form
- Vendor registration and document upload UI
- Vendor approval status workflow through the API
- Vendor login/OTP UI placeholder for production OTP provider
- Vendor Terms & Conditions acknowledgement
- SAR 10 lead fee display
- Vendor audio call / WhatsApp communication
- Customer data protection rule in the UI and API contract
- Gallery, Feedback, About Us and Contact
- Inquiry: +966568778195
- Customer Support / Business WhatsApp: +966541337646
- Email: kgngroupinfo@gmail.com
- Google Location

## Important production setup
Builds use the API URL through a Dart define:

`--dart-define=KGN_API=https://YOUR-REAL-API-DOMAIN`

Do not put API secrets, WhatsApp access tokens, payment secrets, or admin keys in the Flutter application. Those belong on the backend.

## GitHub Actions
The workflow runs `flutter create --platforms=android,ios` before building. This generates the exact Android/iOS native project templates for the current Flutter stable SDK, avoiding stale Gradle/Xcode template problems.


## Company logo
The supplied KGN GROUP crown logo is installed as `assets/kgn_logo.png` and configured as the Android and iOS launcher icon. GitHub Actions generates platform icon assets before building. 
