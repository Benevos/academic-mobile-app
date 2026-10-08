# Calcula UAT Mobile Architecture

This document describes the software architecture and principal execution flow of the Calcula UAT mobile application v2.0.0.

Calcula UAT Mobile is the Android client of the Calcula UAT educational platform. It is implemented with Flutter and Dart and communicates directly with Cloud Firestore through the Firebase Flutter SDK.

---

## 1. Architectural overview

The mobile application follows a client-oriented architecture in which the Flutter application communicates directly with Cloud Firestore.

```text
Calcula UAT Web
      |
      | creates and manages
      v
Cloud Firestore
      ^
      | retrieves educational content
      | stores interaction records
      |
Calcula UAT Mobile
```

No custom REST API or dedicated application server is required by the current implementation.

The web and mobile applications share the same Firestore database.

---

## 2. Main mobile components

The principal source-code structure is located under:

```text
lib/
```

The application contains the following main components:

```text
lib/
├── main.dart
├── firebase_options.dart
├── services/
├── utils/
└── pages/
```

### `main.dart`

Responsible for:

- Flutter application initialization;
- Firebase initialization;
- explicit activation of Cloud Firestore local persistence;
- application routes;
- general application theme and startup configuration.

### `firebase_options.dart`

Contains the Firebase configuration required by the Android client.

For independent deployments, this file should be generated for the Firebase project used by the installation.

### `services/`

Contains functions used to communicate with Firebase and Cloud Firestore.

These functions support operations such as:

- reading collections;
- filtering Firestore documents;
- creating documents;
- retrieving educational content;
- storing interaction records.

### `utils/`

Contains shared utility functions used by different application screens.

This includes connectivity-related support used to provide user feedback when network connectivity is unavailable.

---

## 3. Principal application screens

The mobile workflow is organized around several screens.

### Login

The user enters the institutional access information associated with a `scholarKey`.

The current access mechanism belongs to the research prototype and is not intended to represent production-grade authentication.

### Academic-level selection

After institutional access is validated, the application obtains the academic levels enabled for the institution.

Supported internal academic-level values include:

```text
elementary
middle
high
college
```

### Category and subcategory selection

The application retrieves categories associated with the institution.

Each institution may define its own categories and subcategories through the Calcula UAT web application.

### Difficulty selection

The current implementation supports four difficulty levels:

```text
easy
normal
hard
expert
```

### Problem interaction

Problems matching the selected parameters are retrieved from Cloud Firestore.

The filtering dimensions include:

- institutional key;
- academic level;
- category;
- subcategory;
- difficulty.

Problems are displayed individually using a multiple-choice interaction model.

---

## 4. Exercise interaction flow

The principal exercise flow is:

```text
Problem retrieved
      |
      v
Problem displayed
      |
      v
User selects an answer
      |
      +----------------------+
      |                      |
      | incorrect            | correct
      v                      v
Attempts + 1           Stop elapsed-time measurement
      |                      |
Immediate feedback           v
      |                Create response record
      |                      |
Continue timing              v
      |                Store response in Firestore
      +-------> retry         |
                             v
                       Next problem
```

When an incorrect answer is selected:

- immediate feedback is displayed;
- the attempt counter is incremented;
- elapsed-time measurement continues;
- the user can try again.

When the correct answer is selected:

- elapsed-time measurement is stopped;
- an interaction record is generated;
- the record is written to the `responses` collection;
- the application proceeds to the next available problem;
- the attempt counter is reset for the new problem.

---

## 5. Interaction data

For each completed problem, the mobile application creates a Firestore record containing information such as:

```text
scholarKey
problemId
attemps
elapsedTime
date
```

The field `attemps` is retained in v2.0.0 for compatibility with the existing web and mobile implementations.

It represents the number of attempts required to reach the correct answer.

The complete Firestore schema is documented in the web repository:

```text
https://github.com/Benevos/academic-web-app-v2/blob/master/docs/DATA_MODEL.md
```

---

## 6. Timing mechanism

Elapsed response time is measured for each problem.

The timer starts when the problem interaction begins.

If an incorrect answer is selected, timing continues while the user attempts the problem again.

When the correct answer is selected, the final elapsed time is stored with the interaction record.

The timer is reset before the next problem is presented.

---

## 7. Offline-capable behavior

Calcula UAT Mobile explicitly enables Cloud Firestore local persistence.

The application configuration includes:

```dart
FirebaseFirestore.instance.settings = const Settings(
  persistenceEnabled: true,
);
```

This allows previously retrieved Firestore content to remain available locally during temporary loss of network connectivity.

Writes created while offline may be queued by the Firestore client and synchronized when connectivity returns.

The mobile application therefore supports **intermittent connectivity**.

It does not guarantee unrestricted offline access to educational content that has never previously been retrieved by the device.

---

## 8. Connectivity checking

The application includes an auxiliary connectivity check against:

```text
firestore.googleapis.com
```

with a timeout.

This mechanism is used to provide user feedback about connectivity status.

It should not be interpreted as the synchronization mechanism itself.

Offline storage and synchronization are handled by the Cloud Firestore client infrastructure.

---

## 9. Relationship with the web application

The mobile application does not provide authoring or analytics-management functionality.

These responsibilities belong to the Calcula UAT web application.

The responsibilities are divided as follows:

### Web application

- create categories;
- create subcategories;
- create and edit mathematical problems;
- classify problems;
- inspect interaction statistics.

### Mobile application

- select educational content;
- retrieve mathematical problems;
- present exercises;
- provide immediate feedback;
- record attempts;
- measure elapsed time;
- store interaction records.

Both components communicate with the same Cloud Firestore database.

---

## 10. Supported platform

Calcula UAT Mobile v2.0.0 supports:

```text
Android
```

The current release does not claim tested support for:

```text
iOS
Web
Windows
Linux
macOS
```

---

## 11. Current architectural limitations

Calcula UAT v2.0.0 should be considered a research software prototype.

Current limitations include:

- prototype-level institutional authentication;
- dependence on Cloud Firestore as the shared data layer;
- limited accessibility validation;
- limited testing across heterogeneous Android devices;
- absence of a custom synchronization engine;
- absence of production-grade identity and authorization management.

These limitations are documented to distinguish the current research implementation from a production educational information system.

---

## 12. Version

This document describes the architecture of:

```text
Calcula UAT Mobile v2.0.0
```
