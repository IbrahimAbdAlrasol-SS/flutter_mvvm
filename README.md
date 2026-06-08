# Flutter Admin Starter Kit
### كيت بداية Flutter للوحات التحكم الإدارية | AI-Ready MVVM Architecture

A production-grade Flutter starter kit for building **admin dashboards and back-office applications**. Designed as an **AI-first template** — every file, folder, and pattern is structured so that AI (Claude, GPT, Cursor, Copilot) generates correct code on the first try.

> **Built for Vibe Coders**: Describe a feature in plain language. The AI reads `LLM.md`, understands the exact architecture, and generates production-ready code — with zero back-and-forth.

---

## Why This Exists

Most Flutter starters generate working code for the happy path. When you ask an AI to add a feature, it:
- Puts HTTP calls inside widgets
- Scatters state across random files
- Duplicates toast logic everywhere
- Ignores the existing architecture

This kit solves that. `LLM.md` is a contract — every AI reads it before writing a single line, and every generated file lands in exactly the right place.

---

## Tech Stack

| Concern | Package | Version |
|---|---|---|
| State management | `flutter_riverpod` + `riverpod_annotation` | ^3.0.3 / ^4.0.2 |
| HTTP client | `dio` + `retrofit` | ^5.0.1 / ^4.9.2 |
| Models | `freezed` + `json_annotation` | ^3.0.4 / ^4.7.0 |
| Routing | `go_router` + `go_router_builder` | ^17.2.3 / ^4.3.0 |
| Local storage | `shared_preferences` | ^2.0.15 |
| Localization | Flutter ARB (built-in) | — |
| Responsive UI | `responsive_framework` | ^1.0.0 |
| Pagination | `infinite_scroll_pagination` | ^5.1.1 |
| Fonts | `google_fonts` | ^8.1.0 |
| Animations | `lottie` + `animated_text_kit` | ^3.3.3 / ^4.2.2 |

**Flutter SDK**: `>=3.9.0 <4.0.0` · **Dart SDK**: `>=3.9.0 <4.0.0`

---

## Architecture — The One Rule

```
Screen  →  Notifier  →  Client  →  API
```

**Never skip a layer. Never add a layer.**

| Layer | Responsibility | Location |
|---|---|---|
| **Screen** | Watch state, call notifier, render widgets | `lib/features/*/screens/` |
| **Notifier** | Orchestrate state, call client, handle errors | `lib/features/*/providers/` |
| **Client** | HTTP calls only, zero side effects | `lib/features/*/services/` |
| **Model** | Data shape (Freezed + JSON) | `lib/features/*/models/` |

No repositories. No use-cases. No blocs. Just four layers, each with exactly one job.

---

## Project Structure

```
lib/
│
├── common/                         ← Shared widgets (no feature-specific code)
│   └── widgets/
│       ├── app_table.dart          ← Generic data table (loading + empty + data states)
│       ├── app_crud.dart           ← CRUD page shell (header + filters + table + pagination)
│       ├── app_dialog.dart         ← Modal dialog wrapper + confirm dialog
│       ├── base_pagination.dart    ← Page-based navigation (RTL-aware)
│       ├── stat_card.dart          ← Dashboard metric card with trend indicator
│       └── app_field/
│           ├── app_input_field.dart         ← Text input + AppTextAreaField
│           ├── app_auto_complete_field.dart ← API-backed async dropdown
│           └── app_multi_lang_field.dart    ← Arabic + English dual input
│
├── data/                           ← Cross-feature infrastructure
│   ├── models/                     ← Shared models (AuthenticationModel, PaginatedResponse, MultiLangValue)
│   ├── providers/                  ← authentication_provider, settings_provider
│   └── services/
│       ├── http/
│       │   └── dio_module.dart     ← Single Dio instance + all interceptors
│       ├── interceptors/
│       │   └── authenticator.dart  ← Adds Bearer token to every request
│       └── clients/
│           ├── _clients.dart       ← Re-exports: dio, retrofit, riverpod_annotation, freezed_annotation
│           └── callback.dart       ← Type aliases: FutureApiResponse<T>, FuturePaginatedResponse<T>
│
├── features/                       ← One folder per business domain
│   └── <feature>/
│       ├── models/                 ← Freezed domain model
│       ├── services/               ← Retrofit client (HTTP only)
│       ├── providers/              ← Riverpod notifier + state
│       ├── components/             ← Create/edit dialogs
│       └── screens/                ← Thin orchestration screen
│
├── router/
│   ├── routes/app_routes.dart      ← All typed route declarations
│   ├── routes/app_routes.g.dart    ← Generated
│   ├── router_configuration.dart   ← Auth guard
│   └── app_router.dart             ← Single export for all routes
│
├── theme/
│   ├── app_colors.dart             ← Seed color + ColorScheme (light/dark)
│   └── app_theme.dart              ← AppTheme.light, AppTheme.dark
│
├── l10n/
│   ├── app_en.arb                  ← English strings
│   └── app_ar.arb                  ← Arabic strings (default locale)
│
├── utils/
│   ├── constants/api_document.dart ← ApiDocument.baseUrl — change API here only
│   ├── snackbar.dart               ← Utils.showSuccessSnackBar(), Utils.showErrorSnackBar()
│   └── extensions.dart             ← context.l10n, context.theme, context.colorScheme
│
└── common_lib.dart                 ← Single import barrel for all shared widgets
```

---

## Getting Started

### 1. Prerequisites

```bash
flutter --version   # must be >= 3.9.0
dart --version      # must be >= 3.9.0
```

### 2. Clone and install

```bash
git clone https://github.com/IbrahimAbdAlrasol-SS/flutter_mvvm.git
cd flutter_mvvm
flutter pub get
```

### 3. Configure API base URL

Open `lib/utils/constants/api_document.dart` and change:

```dart
class ApiDocument {
  static const String baseUrl = 'http://your-api-url/api';
}
```

### 4. Run code generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

> Run this after **any** change to `@freezed`, `@RestApi`, `@riverpod`, or `@TypedGoRoute`.

### 5. Run the app

```bash
flutter run
```

---

## Initial Setup Checklist

- [ ] Change `ApiDocument.baseUrl` in `lib/utils/constants/api_document.dart`
- [ ] Change `android:label` in `AndroidManifest.xml`
- [ ] Update deep-link host name in `AndroidManifest.xml` and `ios/Runner/Info.plist`
- [ ] Run `flutter pub run change_app_package_name:main <your.package.name>`
- [ ] In pubspec.yaml change `name: app` to your app name, then replace all `package:app` imports
- [ ] Update seed color in `lib/theme/app_colors.dart` if needed
- [ ] Add `<uses-permission android:name="android.permission.INTERNET"/>` to `AndroidManifest.xml`
- [ ] Run `dart run build_runner build --delete-conflicting-outputs`

---

## Automatic Behaviors (HTTP Interceptor)

The Dio instance in `lib/data/services/http/dio_module.dart` handles all of these **automatically**. You never replicate them anywhere else.

| Event | Behavior |
|---|---|
| Every request | Adds `Authorization: Bearer <token>` if signed in |
| Every request | Adds `Accept-Language: ar` or `en` from app settings |
| POST / PUT / DELETE — 2xx | Shows localized success toast |
| Any 4xx / 5xx error | Extracts message from response body, shows error toast |
| 401 Unauthorized | Calls `logout()` → navigates to `/sign-in` |

---

## Shared Widgets API

All widgets are available via one import:

```dart
import 'package:app/common_lib.dart';
```

### `AppTable<T>`

```dart
AppTable<UserModel>(
  columns: [
    const AppTableColumn(key: 'name', label: 'الاسم'),
    const AppTableColumn(key: 'email', label: 'البريد', width: 200),
    const AppTableColumn(key: 'actions', label: '', width: 80),
  ],
  items: state.items,
  isLoading: state.isLoading,     // shows skeleton rows while loading
  emptyMessage: 'لا يوجد مستخدمون',
  cellBuilder: (item, key) => switch (key) {
    'name'    => Text(item.name),
    'email'   => Text(item.email),
    'actions' => IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
    _         => const SizedBox.shrink(),
  },
)
```

### `AppCrud`

```dart
Scaffold(
  body: AppCrud(
    title: 'المستخدمون',
    addButtonText: 'إضافة مستخدم',
    totalCount: state.totalCount,
    onAddPressed: () {
      notifier.openCreate();    // ← MUST call BEFORE showDialog
      showDialog(context: context, barrierDismissible: false,
        builder: (_) => const Dialog(child: UserCreateDialog()));
    },
    filters: AppInputField(
      controller: _searchCtrl,
      label: 'بحث',
      prefixIcon: const Icon(Icons.search, size: 18),
      onChanged: notifier.setNameFilter,
    ),
    currentPage: state.page,
    totalPages: notifier.totalPages,
    onPageChanged: notifier.setPage,
    child: AppTable<UserModel>(...),
  ),
)
```

### `AppDialogContent` (for form dialogs)

```dart
AppDialogContent(
  title: 'إضافة مستخدم',
  isLoading: state.isLoading,
  actions: [
    TextButton(onPressed: notifier.closeCreate, child: const Text('إلغاء')),
    FilledButton(onPressed: state.isLoading ? null : _submit, child: const Text('حفظ')),
  ],
  child: Form(key: _formKey, child: Column(children: [...])),
)
```

### `showConfirmDialog`

```dart
final confirmed = await showConfirmDialog(
  context,
  title: context.l10n.confirmDelete,
  message: context.l10n.confirmDeleteMessage,
  confirmLabel: context.l10n.delete,
  confirmColor: Theme.of(context).colorScheme.error,
);
if (confirmed == true && mounted) notifier.delete(item.id);
```

### `AppInputField` / `AppTextAreaField`

```dart
AppInputField(
  controller: _nameCtrl,
  label: 'الاسم',
  validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
  keyboardType: TextInputType.emailAddress,
  prefixIcon: const Icon(Icons.email_outlined),
)

AppTextAreaField(controller: _descCtrl, label: 'الوصف', minLines: 3, maxLines: 6)
```

### `AppAutoCompleteField` (API-backed dropdown)

```dart
AppAutoCompleteField(
  label: 'المدير',
  optionsLoader: (query) async {
    final r = await ref.read(userClientProvider).getUsers(1, 20, name: query);
    return r.data.result
        .map((u) => AppSelectOption(id: u.id, label: u.fullName ?? u.username))
        .toList();
  },
  onChanged: (id) => setState(() => _managerId = id as int?),
  initialValue: _selectedManager,   // AppSelectOption? — for pre-filling edit forms
  validator: (opt) => opt == null ? 'مطلوب' : null,
)
```

`AppSelectOption` fields: `id` (dynamic), `label` (String).  
Participates in `Form.validate()` via its internal `TextFormField`.

### `AppMultiLangField` (Arabic + English)

```dart
AppMultiLangField(
  label: 'الاسم',
  value: _nameValue,                // MultiLangValue(ar: '', en: '')
  onChanged: (val) => setState(() => _nameValue = val),
)
// In submit: 'nameAr': _nameValue.ar, 'nameEn': _nameValue.en
```

### `StatCard` (dashboard metrics)

```dart
StatCard(
  title: 'إجمالي الأقسام',
  value: '24',
  icon: Icons.business_outlined,
  iconColor: Theme.of(context).colorScheme.primary,  // never use Colors.*
  trend: 0.05,          // > 0 = green ↑,  < 0 = red ↓,  0/null = hidden
  trendLabel: '+5% هذا الشهر',
  subtitle: 'آخر تحديث: اليوم',
)
```

### `BasePagination` (standalone)

Embedded automatically inside `AppCrud`. Use standalone only when you need pagination without `AppCrud`:

```dart
BasePagination(
  currentPage: state.page,
  totalPages: notifier.totalPages,
  onPageChanged: notifier.setPage,
)
```

---

## Adding a New Feature (8 Steps)

> **For AI**: Read `LLM.md` for complete copy-paste templates for each step.

**Step 1 — Model**: `lib/features/<name>/models/<name>_model.dart`  
Freezed class with `fromJson`. Add `const ClassName._()` when you need computed getters.

**Step 2 — Client**: `lib/features/<name>/services/<name>_client.dart`  
Retrofit endpoints (GET list, GET by ID, POST, PUT, DELETE). Import `_clients.dart` and `callback.dart`.

**Step 3 — Generate**:
```bash
dart run build_runner build --delete-conflicting-outputs
```

**Step 4 — Provider**: `lib/features/<name>/providers/<name>_provider.dart`  
Freezed state: `items`, `isLoading`, `page`, `pageSize`, `totalCount`, `isCreateOpen`, `isEditOpen`, `selected`, filters.  
Notifier: `fetch`, `create`, `update`, `delete`, `openCreate`, `closeCreate`, `openEdit`, `closeEdit`, `setPage`, `setNameFilter`.

**Step 5 — Generate again** after the provider.

**Step 6 — Create dialog**: `lib/features/<name>/components/<name>_create_dialog.dart`  
`AppDialogContent` + `Form` + controllers. Visibility: `if (!state.isCreateOpen) return const SizedBox.shrink()`.

**Step 7 — Edit dialog**: `lib/features/<name>/components/<name>_edit_dialog.dart`  
Same as create. Pre-fill from `state.selected` using `_ctrl.setTextSafely(value)` — never `_ctrl.text = value`.

**Step 8 — Screen + Route**:
- `lib/features/<name>/screens/<name>_screen.dart` using `Scaffold` + `AppCrud` + `AppTable`
- Add `@TypedGoRoute<NameRoute>(path: '/<name>')` to `lib/router/routes/app_routes.dart`
- Export from `lib/router/app_router.dart`
- Run build_runner (or manually update `app_routes.g.dart`)
- Add navigation button to `lib/src/home/home_page.dart`

### Reference Implementation

The complete working example lives in `lib/features/departments/`. Read every file in it before writing a new feature.

| File | Role |
|---|---|
| `models/department_model.dart` | 12-field Freezed model |
| `services/department_client.dart` | 5 Retrofit endpoints |
| `providers/department_provider.dart` | Full state + notifier |
| `components/department_create_dialog.dart` | Create form |
| `components/department_edit_dialog.dart` | Edit form with pre-fill guard |
| `screens/departments_screen.dart` | Thin orchestration screen |

---

## Routing

```dart
// Navigate (from a widget):
const DepartmentsRoute().go(context);         // replace current
const DepartmentsRoute().push(context);       // push on stack
const DepartmentsRoute().pushReplacement(context);

// Navigate (from a notifier — no BuildContext needed):
ref.read(routerProvider).go(const SignInRoute().location);

// Current routes:
//  /            → HomeRoute        → HomePage
//  /sign-in     → SignInRoute      → SignInPage
//  /departments → DepartmentsRoute → DepartmentsScreen
```

Auth guard is in `lib/router/router_configuration.dart`. Redirects to `/sign-in` if not authenticated.

---

## Theme

**Seed color**: `0xFF113D80` (Material 3, supports light and dark mode)

```dart
// Always use theme tokens — never raw Colors.*
Theme.of(context).colorScheme.primary
Theme.of(context).colorScheme.error
Theme.of(context).colorScheme.surface
Theme.of(context).textTheme.bodyLarge

// Shorthand extensions (lib/utils/extensions.dart):
context.colorScheme.primary
context.textTheme.headlineMedium
context.l10n.save

// Semantic colors (AdditionalColors extension on ColorScheme):
context.colorScheme.successText    // green — positive trends, success states
context.colorScheme.dangerColor    // red — danger states
context.colorScheme.primaryText    // blue — primary text
context.colorScheme.secondaryText  // grey — secondary text
```

---

## Localization

Default locale: **Arabic (ar)**. Also supports English (en). RTL/LTR switches automatically.

```dart
context.l10n.save             // حفظ / Save
context.l10n.cancel           // إلغاء / Cancel
context.l10n.delete           // حذف / Delete
context.l10n.confirmDelete    // تأكيد الحذف / Confirm Delete
context.l10n.noData           // لا توجد بيانات / No data
context.l10n.totalItems(24)   // الإجمالي: 24 / Total: 24
```

Add new keys to both `lib/l10n/app_en.arb` and `lib/l10n/app_ar.arb`. Flutter regenerates `AppLocalizations` on next build.

---

## Forbidden Patterns

```dart
// ❌ HTTP call outside a service file
final response = await Dio().get('/users');             // in a screen or notifier

// ❌ Toast inside a service or notifier
Utils.showSuccessSnackBar('تمت الإضافة');               // interceptor already does this

// ❌ Business logic in a screen
if (user.role == 'admin') { ... }                       // belongs in the notifier

// ❌ Hardcoded API base URL
Dio()..options.baseUrl = 'http://67.217.62.164:6001';  // use ApiDocument.baseUrl

// ❌ Repository layer
lib/data/repositories/                                  // does not exist, do not create

// ❌ Raw path strings for navigation
context.go('/departments');                             // use const DepartmentsRoute().go(context)

// ❌ Raw colors or hardcoded TextStyle
color: Colors.blue                                      // use context.colorScheme.primary
style: TextStyle(color: Colors.grey, fontSize: 14)     // use context.textTheme.bodySmall

// ❌ Direct text assignment in edit dialogs
_ctrl.text = item.name;                                 // crashes on Android (cursor OOB)
_ctrl.setTextSafely(item.name);                         // ✅ always use this
```

---

## Development Commands

```bash
# Install dependencies
flutter pub get

# Code generation (run after any @freezed / @riverpod / @RestApi / @TypedGoRoute change)
dart run build_runner build --delete-conflicting-outputs

# Static analysis
flutter analyze

# Tests
flutter test

# Rename package (initial setup)
flutter pub run change_app_package_name:main com.yourcompany.yourapp
flutter pub global run rename --appname "Your App Name"
```

---

## For AI Assistants

This project has a dedicated instruction file at `LLM.md`. It contains:
- Exact copy-paste templates for every layer (Model, Client, Provider, Dialog, Screen)
- Complete shared widget API with all parameters
- Forbidden patterns with wrong vs. right examples
- The 8-step checklist for adding any new feature
- All naming conventions and file placement rules

**Before writing any code, read `LLM.md` completely, then say:**
> *"I have read LLM.md and will follow its rules."*

---

## License

MIT
