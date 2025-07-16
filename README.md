# Countdown

This repository contains a simple SwiftUI countdown application with an optional home screen widget. The project is organized as a Swift Package so that it can be opened directly in Xcode.

## Features

- Manage multiple countdown events.
- Add a title and target date for each countdown.
- Persistent storage shared with the home screen widget via an app group.
- Widget displays the next countdown.

## Getting Started

1. Clone the repository and open `Package.swift` in Xcode.
2. Create an App Group with the identifier `group.countdown` and enable it for both the app and the widget targets.
3. Build and run on a device or simulator running iOS 16 or later.

Use the `+` button in the app to create countdowns. Long‑press the home screen, tap the `+` button and add the *Countdown* widget to view your next countdown.
