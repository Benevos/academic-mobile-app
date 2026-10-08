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

