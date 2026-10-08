# Changelog

All notable changes to the Calcula UAT mobile application are documented in this file.

## [2.0.0] - 2026

### Overview

Calcula UAT Mobile v2.0.0 is the Android research-software release prepared for reproducible educational experimentation and scientific dissemination.

The application is implemented with Flutter and Dart and communicates directly with Cloud Firestore.

### Added

- Explicit Cloud Firestore local persistence for intermittent-connectivity support.
- Firebase setup documentation.
- Mobile architecture documentation.
- MIT software license.
- Software citation metadata through `CITATION.cff`.
- Documentation of Android-only support.
- Documentation of the relationship between the mobile and web components.

### Changed

- Renamed the Flutter package from `empty_app` to `calcula_uat`.
- Standardized the Android namespace and application identifier as:

```text
uat.uamm.calculauat
```

- Updated Firebase Android configuration to use the Calcula UAT package identifier.
- Improved connectivity checking by targeting the Firestore service and adding a timeout.
- Updated offline-connectivity messages to reflect Firestore local persistence behavior.
- Improved project documentation and installation instructions.
- Removed unsupported generated platform directories for iOS, Web, Windows, Linux, and macOS.
- Removed residual Flutter demonstration code from `main.dart`.
- Disabled iOS launcher-icon generation.

### Fixed

- Reset the attempt counter when advancing to a new mathematical problem.
- Corrected timer behavior after an incorrect answer so elapsed-time measurement continues during subsequent attempts.
- Improved offline response recording so Firestore writes can remain pending while connectivity is unavailable.
- Removed obsolete Firebase iOS configuration from the Android-focused release.

### Data compatibility

The Firestore interaction field:

```text
attemps
```

is intentionally retained in version 2.0.0 for compatibility with the existing mobile application, web analytics application, and stored research data.

The field represents the number of attempts required to reach the correct answer.

A future schema migration may rename this field to:

```text
attempts
```

### Known limitations

Calcula UAT Mobile v2.0.0 is a research software prototype.

The current release uses a prototype institutional access mechanism and should not be considered a production-grade identity-management system.

Offline operation depends on Cloud Firestore local persistence. Educational content that has never previously been retrieved by a device cannot be obtained from the cloud while the device is offline.

The release has not been validated as a supported deployment for platforms other than Android.
