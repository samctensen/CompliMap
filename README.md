# CompliMap

A SwiftUI iOS app for sharing location-based posts and exploring user profiles on a map.

Built in 2022 with SwiftUI, MapKit, and Firebase. The app includes authentication, posts, comments, profiles, and location-aware map views.

## Open

Open `CompliMap.xcodeproj` in Xcode and allow Swift Package Manager to resolve the Firebase dependencies. Select the `CompliMap` scheme and an iOS simulator or device. The project targets iOS 15.4 and later.

Running against a backend requires a Firebase project and configuration for Authentication, Firestore, and Storage. Device builds also require your own signing team.

## Project

- `CompliMap.xcodeproj/` — Xcode project and dependency configuration.
- `CompliMap/` — SwiftUI views, view models, services, repositories, models, and resources.

The project file beside the app source folder is the standard Xcode layout. Existing contributor history is preserved.
