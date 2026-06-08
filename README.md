# Flutter MVVM Starter Kit

This document provides a comprehensive guide to the project's architectural structure, directories, and strict development rules. Please follow these guidelines carefully to maintain consistency and code quality.

---

## 💡 Mandatory AI Initiation Prompt

> [!IMPORTANT]
> **Strict Rule**: Before starting any task with an AI model, you **must** supply this exact prompt as the first message to ensure compliance with the repository's architecture.

### Prompt Example (Copy & Paste)
```text
I have read LLM.md and will follow its rules. I will respect the unidirectional flow (Screen -> Notifier -> Client -> API), leverage the automatic HTTP Interceptor, and write zero custom success/error toast UI or manual try-catch wrappers for toast display.
```

---

## 🏛️ Unidirectional Data Flow

The data flow in this application follows a strict unidirectional path:

**Screen ➔ Notifier ➔ Client ➔ API**

### Core Layer Responsibilities:
- **Screens (UI)**: Watch notifiers for state changes. Never call network services directly.
- **Notifiers (State)**: Manage business logic and state. Never access BuildContext or reference UI components.
- **Clients (API)**: Fetch data using Retrofit/Dio. Never modify state directly or display UI alerts.
- **Models**: Simple, immutable data representations. Never place logic or API requests here.

---

## 📁 Directory Structure

Below is the layout of the project, defining where each piece of code belongs:

```text
lib/
├── common/
│   └── widgets/                     (Re-usable UI elements shared across all features)
│
├── data/                            (Infrastructure layer shared across features)
│   ├── models/                      (Shared immutable data models)
│   ├── providers/                   (Global state providers like auth and settings)
│   └── services/                    (Dio configuration, HTTP interceptors, and clients)
│
├── features/                        (Domain-driven features containing all business logic)
│   └── <feature_name>/
│       ├── models/                  (Feature-specific freezed data models)
│       ├── services/                (Retrofit client definitions)
│       ├── providers/               (Riverpod notifier orchestrations)
│       ├── components/              (Local dialogs, forms, and widgets)
│       └── screens/                 (Feature entry point screens)
│
├── router/                          (Type-safe routing configurations)
│
├── src/                             (Legacy UI components)
│
├── theme/                           (Centralized color themes and text styles)
│
├── l10n/                            (Language localization files for English and Arabic)
│
└── utils/                           (Global constant files and helper utility classes)
```

---

## 🛡️ Automatic HTTP Interceptor

A global HTTP interceptor handles repetitive tasks automatically. Do not write manual code for:
- **Authorization**: Attaching Bearer tokens to outbound requests.
- **Locale Header**: Setting the language parameter dynamically.
- **Success Notifications**: Displaying success alerts on POST, PUT, and DELETE operations.
- **Error Handlers**: Catching network errors and showing error toasts.
- **Session Expiry**: Logging out and redirecting to the sign-in page on 401 statuses.
