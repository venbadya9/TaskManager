# Task Manager App

## Overview
Task Manager is a SwiftUI 5 application for iOS 18 that helps users efficiently manage their tasks. It features an intuitive UI, Core Data integration for persistence, and extensive customization options, including dynamic themes and accessibility support.

## Features
- **Task Management**: Add, delete, and mark tasks as completed.
- **Undo Actions**: Ability to undo task deletions or completions.
- **Filtering & Sorting**: Sort tasks by priority, due date, or completion status.
- **Customizable UI**:
  - Dynamic light/dark mode with user selection.
  - Accent color customization via a color picker.
  - Shimmer loading effect for smooth UX.
- **Accessibility Support**:
  - VoiceOver-friendly UI elements.
  - Dynamic Type support for text scaling.
  - High-contrast mode compatibility.
  - Keyboard navigation support.
- **Swipe Gestures**:
  - Swipe-to-complete/unmark tasks.
  - Swipe-to-delete tasks with undo option.

## Technologies Used
- **SwiftUI 5**: Declarative UI framework for building modern iOS apps.
- **Core Data**: Persistent storage for tasks.
- **MVVM Architecture**: Clean code organization for scalability and maintainability.
- **Haptic Feedback**: Enhances user interaction.

## Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/your-repo/task-manager-ios.git
   ```
2. Open `TaskManager.xcodeproj` in Xcode 15.
3. Run the project on an iOS 18 simulator or device.

## Usage
1. Launch the app and create a new task using the `+` button.
2. Swipe left to delete a task or swipe right to complete it.
3. Customize the theme in the Settings view (gear icon).
4. Filter and sort tasks using the control options at the top.

