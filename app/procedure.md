# Agrotani App - Development Procedure & Architecture Guide

This document serves as the primary guideline for any developer or AI agent working on the `Agrotani` app. It outlines the folder structure, architectural patterns, design philosophy, and the procedure for making changes.

## 🎯 Design Philosophy & Intent

The primary goal of this application is to serve Indonesian farmers (e.g., "Pak Harto, 52 tahun"). 
The UI/UX must be:
- **Functional over Flashy:** Less "tech/AI" aesthetic, more practical and accessible.
- **Highly Legible:** Large fonts (minimum 16sp, ideally 18sp for body text), high contrast.
- **Easy to Target:** Large touch targets (minimum 56dp for main buttons) for coarse interaction.
- **Clear Language:** Use simple, everyday Indonesian (e.g., "Foto tanaman" instead of "Upload citra").
- **State Aware:** Always provide clear loading, empty, and error states so the user is never left guessing.

## 📁 Folder Structure (`app/lib/`)

The project follows a **feature-driven Clean Architecture** using Riverpod for state management.

```text
app/lib/
├── core/                   # Core utilities shared across the app
│   ├── constants/          # App constants (strings, durations, mock data)
│   ├── error/              # Error handling classes (Failures, Exceptions)
│   ├── network/            # Dio interceptors, network providers
│   ├── router/             # GoRouter configuration (app_router.dart)
│   ├── services/           # Core services (e.g., StorageService)
│   ├── theme/              # Colors, Typography, ThemeData
│   ├── utils/              # Helper functions
│   └── widgets/            # Shared/dumb UI widgets
│
└── features/               # Feature modules
    ├── auth/               # Authentication (Login, Register, Splash)
    ├── chat/               # FarmerBot AI Chat
    ├── home/               # Dashboard / Home screen
    ├── profile/            # User profile and settings
    └── scan/               # AI Image Scanning and Diagnosis Result
```

### Anatomy of a Feature Directory
Each feature (e.g., `features/scan/`) is organized as follows:
- `data/` : Models, Repositories, Data Sources. Contains the interface and implementations (Mock vs. API).
- `providers/` : Riverpod Notifiers/Providers bridging UI and Data.
- `screens/` : Flutter UI screens.
- `widgets/` : Feature-specific UI components.

## ⚙️ How to Interact with the Codebase (For AI & Developers)

### 1. State Management (Riverpod)
- **Always use `ConsumerWidget` or `ConsumerStatefulWidget`.**
- Access state using `ref.watch()` in `build()` and `ref.read()` in callbacks.
- Async operations should be managed using `AsyncNotifier`. Example: `ChatNotifier` or `ScanHistoryNotifier`.

### 2. Navigation (GoRouter)
- All routes are defined in `core/router/app_router.dart`.
- Use `context.push(AppRoutes.routeName)` for pushing a new screen.
- Use `context.go(AppRoutes.routeName)` for changing bottom navigation tabs or root screens.
- Use `context.pop()` to go back.

### 3. Styling & Theming
- **Never hardcode colors or text styles.** 
- Colors must be accessed via `AppColors` (`core/theme/app_colors.dart`).
- Text styles must be accessed via `AppTextStyles` (`core/theme/app_text_styles.dart`).
- If you need a new style, define it in the respective core theme file first.

### 4. API & Mocking
- Most repositories have a `Mock` implementation and an `Api` implementation.
- The active implementation is toggled via Riverpod providers (e.g., `scanRepositoryProvider` in `scan_repository.dart`). 
- When developing UI, ensure the Mock repository provides realistic data that matches the final API schema.

## 🛠️ Step-by-Step Procedure for Making Changes

When requested to add a feature or modify the design, follow this workflow:

1. **Understand Context:** Read this `procedure.md` and check the relevant feature directory. 
2. **Modify Theme (If UI Task):** If changing colors/fonts to match the new "farmer-friendly" UX, update `AppColors` and `AppTextStyles` first.
3. **Update Data/Models:** If the data structure changes, update the models and repository in `data/`.
4. **Update Providers:** Modify the `Notifier` classes in `providers/` to handle the new logic or state.
5. **Implement UI:** Update the `screens/` and `widgets/`. Apply the new design system (larger fonts, bigger touch targets).
6. **Verify:** Ensure no build errors and that navigation still works seamlessly.

## 🚀 Immediate Next Steps (Planned Modernization)

Based on the design review, the following architectural and UI changes are prioritized:
1. **Authentication Rewrite:** Move from Email/Password to Phone Number logic to simplify access for farmers.
2. **Typography Scale-Up:** Increase base font sizes across `AppTextStyles`.
3. **Touch Target Enlargement:** Update standard button sizes and padding.
4. **Scan Flow Overhaul:** Add visual camera guides, remove confusing "% confidence" metrics, and make diagnosis actionable.
5. **Home Screen Revamp:** Provide prominent call-to-actions (Scan & Chat) instead of generic statistics.

*Note to AI agents: When executing tasks, strictly adhere to the boundaries of the `app/` folder.*
