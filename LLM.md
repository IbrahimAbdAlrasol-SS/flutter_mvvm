# LLM.md — Flutter Admin Starter Kit

> Read this file completely before writing a single line of code.  
> Every architectural decision is documented here. Following these rules is non-negotiable.

---

## Tech Stack

| Concern | Package / Approach |
|---|---|
| State management | `flutter_riverpod` + `riverpod_annotation` (code-gen `@riverpod`) |
| HTTP client | `dio` + `retrofit` (code-gen `@RestApi`) |
| Models | `freezed` + `json_annotation` (code-gen `@freezed` + `@JsonSerializable`) |
| Routing | `go_router` + `go_router_builder` (code-gen `@TypedGoRoute`) |
| Localization | Flutter ARB files (`lib/l10n/`) — English + Arabic |
| Storage | `shared_preferences` (no secure storage) |
| Pagination | `infinite_scroll_pagination` (available) + custom `BasePagination` widget |
| UI base | Material 3, seed color `0xFF113D80`, defined in `lib/theme/` |
| Forms | Built-in Flutter `Form` + `TextFormField` |
| Responsive | `responsive_framework`: MOBILE (≤450), TABLET (≤800), DESKTOP (≤1920) |

---

## Architecture: Data Flow

```
DepartmentsScreen (thin orchestration)
  └─> ref.watch(departmentNotifierProvider)       ← Riverpod notifier
       └─> ref.read(departmentClientProvider)     ← Retrofit client
            └─> Dio (with interceptors)           ← HTTP + auth + toasts
                 └─> REST API
```

**Never skip a layer.** Screens never call clients directly. Clients never touch state.

---

## Project Structure

```
lib/
├── common/                        ← Cross-feature shared code
│   └── widgets/
│       ├── app_table.dart         ← Generic data table
│       ├── app_crud.dart          ← CRUD page shell (header + filters + pagination)
│       ├── app_dialog.dart        ← Modal/dialog wrapper
│       ├── base_pagination.dart   ← Page-based pagination control
│       ├── stat_card.dart         ← Dashboard metric card
│       └── app_field/
│           ├── app_input_field.dart        ← Text + textarea
│           ├── app_auto_complete_field.dart ← API-backed autocomplete
│           └── app_multi_lang_field.dart   ← Arabic + English dual input
│
├── data/                          ← Cross-feature data layer (existing, do not move)
│   ├── models/                    ← Shared Freezed models (AuthenticationModel, etc.)
│   ├── providers/                 ← Cross-feature providers (authentication, settings)
│   └── services/
│       ├── http/dio_module.dart   ← Dio + all interceptors (single source of truth)
│       ├── interceptors/          ← Authenticator interceptor
│       └── clients/               ← Type aliases, converters, shared client infra
│
├── features/                      ← One folder per business domain
│   └── <feature>/
│       ├── models/                ← Freezed domain models (@freezed)
│       ├── services/              ← Retrofit client (@RestApi) — HTTP ONLY
│       ├── providers/             ← Riverpod notifier (@riverpod) — state + orchestration
│       ├── components/            ← Feature-specific widgets (dialogs, forms)
│       └── screens/               ← Thin orchestration screens (wire state → UI)
│
├── router/                        ← Go Router (typed routes, auth guard)
├── src/                           ← Legacy UI (auth, home) — migrate to features/ for new work
├── theme/                         ← Material 3 tokens, colors, text styles
├── l10n/                          ← ARB localization files (en + ar)
└── utils/                         ← Shared utilities, validators, extensions, widgets
```

---

## Feature Module: Exact File Roles

Use `lib/features/departments/` as the canonical example.

### `models/department_model.dart`
- **Purpose**: Define the domain data shape.
- **Rules**: `@freezed` + `@jsonSerializable`. One model file per entity. `fromJson` + `toJson`. No business logic.
- **Pattern**:
```dart
@freezed
abstract class DepartmentModel with _$DepartmentModel {
  const DepartmentModel._();
  @jsonSerializable
  const factory DepartmentModel({required int id, required String name, ...}) = _DepartmentModel;
  factory DepartmentModel.fromJson(Map<String, dynamic> json) => _$DepartmentModelFromJson(json);
}
```

### `services/department_client.dart`
- **Purpose**: HTTP calls ONLY. No state, no toasts, no business logic.
- **Rules**: `@RestApi()` + `@riverpod`. Import `_clients.dart`. Use `FuturePaginatedResponse<T>`, `FutureApiResponse<T>` type aliases.
- **Pattern**:
```dart
@riverpod
DepartmentClient departmentClient(Ref ref) => DepartmentClient(ref.dio);

@RestApi()
abstract class DepartmentClient {
  factory DepartmentClient(Dio dio, {String baseUrl}) = _DepartmentClient;
  @GET('/departments')
  FuturePaginatedResponse<DepartmentModel> getDepartments(
    @Query('pageNumber') int pageNumber,
    @Query('pageSize') int pageSize,
  );
  @POST('/departments')
  FutureApiResponse<DepartmentModel> createDepartment(@Body() Map<String, dynamic> body);
}
```

### `providers/department_provider.dart`
- **Purpose**: Manage reactive state. Call service methods. Own dialog open/close flags.
- **Rules**: `@riverpod class XNotifier extends _$XNotifier`. State is a `@freezed` data class. Re-throw errors from mutations (for form-level handling). Refetch list after every mutation.
- **Pattern**:
```dart
@freezed
abstract class DepartmentState with _$DepartmentState {
  const factory DepartmentState({
    @Default([]) List<DepartmentModel> items,
    @Default(false) bool isLoading,
    @Default(1) int page,
    @Default(10) int pageSize,
    @Default(0) int totalCount,
    @Default(false) bool isCreateOpen,
    @Default(false) bool isEditOpen,
    DepartmentModel? selected,
    @Default('') String nameFilter,
  }) = _DepartmentState;
}

@riverpod
class DepartmentNotifier extends _$DepartmentNotifier {
  @override DepartmentState build() => const DepartmentState();
  Future<void> fetch() async { ... }
  Future<void> create(Map<String, dynamic> data) async { ... rethrow on error ... }
}
```

### `components/department_create_dialog.dart`
- **Purpose**: The create form. Owns validation via Flutter's `Form` + `GlobalKey<FormState>`.
- **Rules**: Opens/closes in sync with `state.isCreateOpen`. Calls `notifier.create()`. Catches errors (interceptor handles toast; form stays open for correction).
- **Never**: Call the Retrofit client directly. Show toasts manually (interceptor does it).

### `screens/departments_screen.dart`
- **Purpose**: Wire state to UI. Zero business logic.
- **Rules**: `ConsumerStatefulWidget`. Watch `departmentNotifierProvider`. Call `initState` → `notifier.fetch()`. Pass `isLoading`, `items`, `totalPages` down to `AppCrud` / `AppTable`.

---

## HTTP Interceptors — Single Source of Truth

**File**: `lib/data/services/http/dio_module.dart`

The Dio instance has three interceptors, applied in this order:

### 1. `Authenticator` (`lib/data/services/interceptors/authenticator.dart`)
- Adds `Authorization: Bearer <token>` header to every request when signed in.
- Reads token from `authenticationProvider.build()?.token`.

### 2. `InterceptorsWrapper` (inline in `dio_module.dart`)
- **`onRequest`**: Injects `Accept-Language: <locale>` header from `settingsProvider`.
- **`onResponse`**: 
  - Normalises list responses to `{data: [...], message, statusCode}`.
  - Shows **success toast** automatically for `POST`, `PUT`, `PATCH`, `DELETE` (2xx).
  - **Never add success toasts in service or screen files** — this is handled here.
- **`onError`**: 
  - Handles `401` → calls `authenticationProvider.logout()` → redirects to sign-in.
  - Extracts error message from response body and shows **error toast** via `Utils.showErrorSnackBar()`.
  - **Never add error toasts in service or screen files** — this is handled here.

### 3. `AwesomeDioInterceptor` (debug only)
- Logs all HTTP traffic in debug mode.

**CRITICAL**: These interceptors mean you must NEVER:
- Call `Utils.showSuccessSnackBar()` or `Utils.showErrorSnackBar()` inside a service method.
- Call `Utils.showSuccessSnackBar()` or `Utils.showErrorSnackBar()` inside a notifier `create/update/delete` method.
- Manually handle 401 in any file other than `dio_module.dart`.

---

## Shared Widgets — When to Use Each

### `AppTable<T>` (`lib/common/widgets/app_table.dart`)
Generic data table. Handles loading skeleton, empty state, and data rendering.

```dart
AppTable<DepartmentModel>(
  columns: [
    const AppTableColumn(key: 'name', label: 'الاسم'),
    const AppTableColumn(key: 'actions', label: 'إجراءات', width: 120),
  ],
  items: state.items,
  isLoading: state.isLoading,
  emptyMessage: 'لا توجد أقسام',
  cellBuilder: (dept, key) {
    if (key == 'name') return Text(dept.name);
    if (key == 'actions') return _ActionButtons(dept: dept);
    return const SizedBox.shrink();
  },
)
```

### `AppCrud` (`lib/common/widgets/app_crud.dart`)
Page shell: header with Add button, optional filter row, content slot, pagination.

```dart
AppCrud(
  title: 'الأقسام',
  addButtonText: 'إضافة قسم',
  totalCount: state.totalCount,
  onAddPressed: () => notifier.openCreate(),
  filters: AppInputField(label: 'بحث', onChanged: notifier.setNameFilter),
  currentPage: state.page,
  totalPages: notifier.totalPages,
  onPageChanged: notifier.setPage,
  child: AppTable(...),
)
```

### `AppDialog` + `AppDialogContent` (`lib/common/widgets/app_dialog.dart`)
Use `AppDialogContent` as the shell inside `showDialog(builder: (_) => Dialog(child: MyDialogContent()))`.

```dart
class MyCreateDialog extends ConsumerStatefulWidget { ... }
class _MyCreateDialogState extends ConsumerState<MyCreateDialog> {
  @override
  Widget build(BuildContext context) {
    return AppDialogContent(
      title: 'إنشاء جديد',
      actions: [TextButton(...), FilledButton(...)],
      child: Form(key: _formKey, child: Column(children: [...])),
    );
  }
}
```

For a simple confirmation:
```dart
final confirmed = await showConfirmDialog(context, title: 'تأكيد الحذف', message: '...');
```

### `AppInputField` / `AppTextAreaField` (`lib/common/widgets/app_field/app_input_field.dart`)
Use inside `Form` widgets. Supports `controller`, `label`, `validator`, `onChanged`.

### `AppAutoCompleteField` (`lib/common/widgets/app_field/app_auto_complete_field.dart`)
For fields that fetch options from an API.

```dart
AppAutoCompleteField(
  label: 'المدير',
  optionsLoader: (query) async {
    final response = await ref.read(userClientProvider).searchUsers(query);
    return response.data.result.map((u) => AppSelectOption(id: u.id, label: u.name)).toList();
  },
  onChanged: (id) => setState(() => _managerId = id as int?),
)
```

### `AppMultiLangField` (`lib/common/widgets/app_field/app_multi_lang_field.dart`)
Arabic + English dual input producing a `MultiLangValue`.

```dart
AppMultiLangField(
  label: 'الاسم',
  value: _nameValue,
  onChanged: (val) => setState(() => _nameValue = val),
)
```

### `StatCard` (`lib/common/widgets/stat_card.dart`)
Dashboard metric cards.

```dart
StatCard(title: 'المستخدمون', value: '1,240', icon: Icons.people, trend: 0.05, trendLabel: '+5%')
```

### `BasePagination` (`lib/common/widgets/base_pagination.dart`)
Standalone page navigation. Embedded in `AppCrud` automatically.

---

## Routing

All typed route declarations are in `lib/router/routes/app_routes.dart`.  
Generated file: `lib/router/routes/app_routes.g.dart`.

```dart
// Adding a new route:
@TypedGoRoute<MyFeatureRoute>(path: '/my-feature')
class MyFeatureRoute extends GoRouteData with $MyFeatureRoute {
  const MyFeatureRoute();
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) => const MyFeatureScreen();
}
```

**Navigate from a widget**: `const DepartmentsRoute().go(context)` or `.push(context)`.  
**Navigate from a notifier**: `ref.read(routerProvider).go(const SignInRoute().location)`.

Auth guard lives in `lib/router/router_configuration.dart` — it checks `authenticationProvider.isSignedIn()` on every navigation change.

---

## Auth System

- **Storage**: `shared_preferences` (JSON-serialised `AuthenticationModel`).
- **Provider**: `authenticationProvider` (`lib/data/providers/authentication_provider.dart`).
- **Sign in**: Call `ref.read(authClientProvider).login(body)`, then `ref.read(authenticationProvider.notifier).state = result`.
- **Sign out**: `ref.read(authenticationProvider.notifier).logout()` — clears storage and navigates to `/sign-in`.
- **Check**: `ref.read(authenticationProvider.notifier).isSignedIn()`.
- **Auto-guard**: The router listens to `authenticationProvider` via `RouterRefreshNotifier` and redirects to `/sign-in` when the user is not authenticated.
- **401 handling**: The Dio interceptor calls `logout()` automatically on 401 responses.

---

## Localization

- **Files**: `lib/l10n/app_en.arb` (English) and `lib/l10n/app_ar.arb` (Arabic).
- **Access**: `context.l10n.save`, `context.l10n.noData`, etc.
- **Add a new key**: Add to both ARB files, then the build system generates `app_localizations.dart`.
- **RTL**: The app follows `MaterialApp.locale` automatically. Never infer direction from string content.
- **Common keys available**: `save`, `cancel`, `delete`, `confirm`, `loading`, `noData`, `edit`, `create`, `update`, `search`, `filters`, `actions`, `addNew`, `error`, `unexpectedError`, `networkError`, `sessionExpired`, `successCreate`, `successUpdate`, `successDelete`, `confirmDelete`, `confirmDeleteMessage`.

---

## Code Generation

Run after **any** change to `@freezed`, `@RestApi`, `@riverpod`, or `@TypedGoRoute`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Order is enforced by `build.yaml`: **Freezed → JSON Serializable → Retrofit → Riverpod → GoRouter**.

Generated files are excluded from the analyzer (`analysis_options.yaml`) but required at compile time.

---

## What Is Forbidden

| Rule | Reason |
|---|---|
| No HTTP calls in widgets or screens | Breaks layer separation; makes testing impossible |
| No state management in services | Services are stateless HTTP adapters |
| No business logic in screens | Screens are thin orchestration layers |
| No success/error toasts in services or notifiers | Interceptor handles all toasts; duplicates would show twice |
| No manual 401 handling outside `dio_module.dart` | Interceptor handles it; duplicates cause loops |
| No providers in `lib/src/<feature>/` | Feature providers live in `lib/features/<feature>/providers/` |
| No raw `Colors.*` or `TextStyle(...)` in widget files | Use `Theme.of(context).colorScheme.*` and `theme.textTheme.*` |
| No `print()` | Use `logger` from `lib/logger/logger.dart` |
| No `TextEditingController.text =` from external state | Use `setTextSafely()` extension from `lib/utils/extensions.dart` |
| No hardcoded base URL strings anywhere | Base URL lives only in `lib/utils/constants/api_document.dart` |
| No `lib/data/repositories/` | Deleted by design; provider → client is the only path |
| No `usecases/`, `viewmodels/`, `managers/` folders | These patterns are not used here |

---

## Scaffolding a New Feature (8-step checklist)

1. Create `lib/features/<name>/models/<name>_model.dart` — Freezed model.
2. Create `lib/features/<name>/services/<name>_client.dart` — Retrofit client.
3. Create `lib/features/<name>/providers/<name>_provider.dart` — Riverpod notifier + state.
4. Run `dart run build_runner build --delete-conflicting-outputs`.
5. Create `lib/features/<name>/components/<name>_create_dialog.dart` — Create form dialog.
6. Create `lib/features/<name>/components/<name>_edit_dialog.dart` — Edit form dialog.
7. Create `lib/features/<name>/screens/<name>_screen.dart` — Thin screen using `AppCrud` + `AppTable`.
8. Add `@TypedGoRoute<NameRoute>` to `lib/router/routes/app_routes.dart` and re-run build_runner.

---

## Environment Configuration

- **API base URL**: `lib/utils/constants/api_document.dart` → `ApiDocument.baseUrl`
- **Current value**: `http://67.217.62.164:6001/api`
- To change for a new project: edit only `api_document.dart`.
- All clients inherit this URL through Dio's `options.baseUrl`.

---

## Example Feature: Departments

The `lib/features/departments/` folder is the canonical reference implementation. Read it before building any new feature.

- `models/department_model.dart` — Freezed model with 12 fields.
- `services/department_client.dart` — CRUD + list Retrofit client.
- `providers/department_provider.dart` — Full state: list, loading, pagination, filter, dialog flags.
- `components/department_create_dialog.dart` — Create form with Flutter Form validation.
- `components/department_edit_dialog.dart` — Edit form with pre-fill from `state.selected`.
- `screens/departments_screen.dart` — `AppCrud` + `AppTable` wired to notifier.
- Route: `DepartmentsRoute` at `/departments` in `app_routes.dart`.
