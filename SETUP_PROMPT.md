# SETUP_PROMPT.md

Copy and paste this prompt into your AI assistant to start a new client project based on this Flutter Admin Starter Kit.

---

## Prompt

```
You are setting up a new Flutter admin panel using the Flutter Admin Starter Kit.

Before writing any code, read LLM.md completely. It defines all architectural rules,
the exact folder structure, the shared widget APIs, and the forbidden patterns.
Do not deviate from LLM.md.

Here is the project configuration:

1. App name: [APP_NAME]
2. Primary brand color (hex): [e.g. #1A73E8]
3. API base URL: [e.g. https://api.example.com/api]
4. Default language: [ar | en]
5. Features to scaffold: [e.g. users, products, orders, categories]

Please do the following in order:

STEP 1 — Branding
- Update `lib/utils/constants/api_document.dart` → set `baseUrl` to [API_BASE_URL]
- Update `lib/theme/app_colors.dart` → change the seed color to [PRIMARY_COLOR]
- Update `lib/l10n/app_en.arb` and `app_ar.arb` → change the `appName` key to "[APP_NAME]"

STEP 2 — Default locale
- Update `lib/data/providers/settings_provider.dart` → in `AppSettings`, change the
  `@Default(null) String? localeCode` default to `@Default('[LANGUAGE_CODE]') String? localeCode`

STEP 3 — For each feature in the features list, follow the 8-step checklist from LLM.md:
  a. Create `lib/features/<name>/models/<name>_model.dart`
     - Define all fields based on the API contract
     - Use `@freezed` + `@jsonSerializable`
     - Match field names to the API JSON exactly
  b. Create `lib/features/<name>/services/<name>_client.dart`
     - GET list: `FuturePaginatedResponse<Model>` with `pageNumber`, `pageSize`, and any filter params
     - GET by ID: `FutureApiResponse<Model>`
     - POST create: `FutureApiResponse<Model>` with `@Body() Map<String, dynamic>`
     - PUT update: `FutureApiResponse<Model>` with path ID + `@Body() Map<String, dynamic>`
     - DELETE: `Future<void>` with path ID
  c. Create `lib/features/<name>/providers/<name>_provider.dart`
     - State: `@freezed` class with `items`, `isLoading`, `page`, `pageSize`, `totalCount`,
       `isCreateOpen`, `isEditOpen`, `selected`, and any filter fields
     - Notifier: `fetch()`, `create()`, `update()`, `delete()`, `openCreate()`, `closeCreate()`,
       `openEdit(item)`, `closeEdit()`, `setPage()`, filter setters
  d. Run `dart run build_runner build --delete-conflicting-outputs`
  e. Create `lib/features/<name>/components/<name>_create_dialog.dart`
     - Use `AppDialogContent` as shell
     - Use `AppInputField` / `AppTextAreaField` / `AppAutoCompleteField` for form fields
     - Use Flutter `Form` + `GlobalKey<FormState>` for validation
     - Call `notifier.create(data)`, catch errors (interceptor already shows toast)
  f. Create `lib/features/<name>/components/<name>_edit_dialog.dart`
     - Same as create but pre-fill from `state.selected`
     - Call `notifier.update(id, data)`
  g. Create `lib/features/<name>/screens/<name>_screen.dart`
     - `ConsumerStatefulWidget`
     - `initState` → `notifier.fetch()`
     - Use `AppCrud` with `title`, `addButtonText`, `onAddPressed`, `filters`, `currentPage`,
       `totalPages`, `onPageChanged`
     - Use `AppTable<Model>` with column definitions and `cellBuilder`
     - Include `showConfirmDialog` for delete confirmation
     - Mount dialogs via `showDialog(builder: (_) => Dialog(child: NameCreateDialog()))`
  h. Add `@TypedGoRoute<NameRoute>(path: '/name')` to `lib/router/routes/app_routes.dart`
     - Follow the exact pattern from `DepartmentsRoute`
     - Re-run `dart run build_runner build --delete-conflicting-outputs`

STEP 4 — Navigation
- Update `lib/src/home/home_page.dart` to add navigation buttons for each feature

STEP 5 — Verification
- Run `flutter analyze` and fix any issues
- Confirm no HTTP calls exist in widgets or screens
- Confirm no toasts are shown manually in services or notifiers
- Confirm every new route has `$parentNavigatorKey = rootNavigatorKey`

Architecture rules to follow (from LLM.md):
- Provider → Client is the ONLY data path. No skipping layers.
- Interceptor handles all toasts and 401. Never duplicate this logic.
- All screens are thin. No business logic in UI.
- All colors from `Theme.of(context).colorScheme.*`. No hardcoded colors.
- All navigation via typed route classes. No raw path strings.
```

---

## Variables Reference

| Variable | Description | Example |
|---|---|---|
| `[APP_NAME]` | Display name for the app | `Toseel Admin` |
| `[PRIMARY_COLOR]` | Hex color for Material 3 seed | `#1A73E8` |
| `[API_BASE_URL]` | Full base URL including `/api` path | `https://api.toseel.com/api` |
| `[LANGUAGE_CODE]` | Default locale | `ar` or `en` |
| `[FEATURES]` | Comma-separated list of domain names | `users, products, orders` |

---

## Quick Reference: Common Patterns

### Adding a field that references another entity (FK dropdown)

Use `AppAutoCompleteField` with an `optionsLoader` that calls the related entity's client:

```dart
AppAutoCompleteField(
  label: 'المدير',
  optionsLoader: (query) async {
    // Call the users client to search
    final resp = await ref.read(userClientProvider).getUsers(1, 20, name: query.isEmpty ? null : query);
    return resp.data.result
        .map((u) => AppSelectOption(id: u.id, label: u.fullName ?? u.username))
        .toList();
  },
  onChanged: (id) => setState(() => _managerId = id as int?),
)
```

### Arabic + English name fields

Use `AppMultiLangField`:

```dart
AppMultiLangField(
  label: 'الاسم',
  value: _nameValue,
  onChanged: (val) => setState(() => _nameValue = val),
)
// In submit: 'nameAr': _nameValue.ar, 'nameEn': _nameValue.en
```

### Dashboard page with stat cards

```dart
GridView.count(
  crossAxisCount: ResponsiveBreakpoints.of(context).isDesktop ? 4 : 2,
  children: [
    StatCard(title: 'الأقسام', value: '24', icon: Icons.business, trend: 0.1, trendLabel: '+10%'),
    StatCard(title: 'الموظفون', value: '148', icon: Icons.people),
  ],
)
```

### Confirm before deleting

```dart
final confirmed = await showConfirmDialog(
  context,
  title: context.l10n.confirmDelete,
  message: context.l10n.confirmDeleteMessage,
  confirmLabel: context.l10n.delete,
  confirmColor: Theme.of(context).colorScheme.error,
);
if (confirmed == true && mounted) {
  await notifier.delete(item.id);
}
```
