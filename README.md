# README
# Calcula UAT Mobile Application

Calcula UAT is an educational software platform designed to support structured mental calculation practice. This repository contains the Android mobile client used by learners to access mathematical exercises created through the Calcula UAT web platform.

The mobile application is developed with Flutter and Dart and uses Firebase Cloud Firestore as its cloud data layer.

## Main features

- Institutional access through a scholar key and password.
- Selection of academic level.
- Navigation by category and subcategory.
- Four difficulty levels: easy, normal, hard, and expert.
- Multiple-choice mathematical exercises.
- Immediate feedback after each response.
- Recording of the number of attempts required to solve each problem.
- Recording of elapsed response time.
- Local Firestore persistence for operation under intermittent connectivity.
- Synchronization of locally stored interactions when connectivity becomes available.

## Technology

- Flutter
- Dart
- Firebase Core
- Cloud Firestore
- Flutter TeX / mathematical expression rendering

## Requirements

The project requires:

- Flutter SDK compatible with Dart >= 3.0.6 < 4.0.0
- Android SDK
- Android API level 21 or higher
- A Firebase project with Cloud Firestore enabled

## Installation

Clone the repository:

```bash
git clone https://github.com/Benevos/academic-mobile-app.git
```

Enter the project directory:

```bash
cd academic-mobile-app
```

Install the Flutter dependencies:

```bash
flutter pub get
```

Run the application on an Android device or emulator:

```bash
flutter run
```

## Firebase configuration

The application uses Firebase Cloud Firestore.

A Firebase project must contain the collections required by the Calcula UAT platform. The Android application identifier is:

```text
uat.uamm.calculauat
```

The Firebase initialization parameters are defined in:

```text
lib/firebase_options.dart
```

Detailed information about the Firestore data model and configuration will be provided in the project documentation.

## Offline behavior

The application explicitly enables Cloud Firestore local persistence.

Previously retrieved educational content can remain available when connectivity is temporarily unavailable. Responses generated while offline are stored locally by Firestore and synchronized when network connectivity is restored.

Offline availability therefore depends on the required content having been retrieved previously by the device.

## Recorded interaction data

For each completed mathematical problem, the application records information including:

- institutional key;
- problem identifier;
- number of attempts required to reach the correct answer;
- elapsed response time;
- interaction date.

These records are subsequently used by the Calcula UAT web application to generate descriptive learning-analytics indicators.

## Current status

Calcula UAT v2.0.0 is a research software prototype intended for educational experimentation and research.

The current release focuses on Android deployment. Authentication and access control are designed for controlled research deployments and should be strengthened before production-scale use.

## Related repository

The web application used for content management and interaction analytics is available at:

https://github.com/Benevos/academic-web-app-v2

## License

Calcula UAT is released under the MIT License. See the `LICENSE` file for details.

## Citation

Citation information for the SoftwareX publication will be added after publication.

## Contact

For questions about the software:

Ángel Mario Lerma-Sánchez  
Universidad Autónoma de Tamaulipas  
amlerma@docentes.uat.edu.mx
