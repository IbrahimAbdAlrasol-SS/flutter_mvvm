# LLM.md — Flutter Admin Starter Kit

> **INSTRUCTION FOR AI**: Read this file completely before making any changes.
> Start every task by saying "I have read LLM.md and will follow its rules."
> This file is your contract. Deviate from it and you will break the project.

---

## The Problem This File Solves

Without this file, AI generates:
- HTTP calls inside widgets
- State scattered across random files
- Duplicate toast logic everywhere
- Business logic in screens
- No clear ownership of anything

With this file, every piece of code has exactly one correct home.

---

## Project Identity

- **Package**: `app` (see `pubspec.yaml`)
- **Flutter SDK**: 3.9.0+
- **API base URL**: defined in `lib/utils/constants/api_document.dart` → `ApiDocument.baseUrl`
- **Current API**: `http://67.217.62.164:6001/api`
- **Default locale**: Arabic (`ar`), also supports English (`en`)
- **Theme**: Material 3, seed color `0xFF113D80`

---

## Tech Stack — Know Every Tool

| What | Package | Where used |
|---|---|---|
| State management | `flutter_riverpod` + `riverpod_annotation` | `lib/features/*/providers/` and `lib/data/providers/` |
| HTTP client | `dio` + `retrofit` | `lib/features/*/services/` and `lib/data/services/clients/` |
| Models | `freezed` + `json_annotation` | `lib/features/*/models/` and `lib/data/models/` |
| Routing | `go_router` + `go_router_builder` | `lib/router/routes/app_routes.dart` |
| Storage | `shared_preferences` | `lib/data/providers/` via `ObjectPreferenceProvider` mixin |
| Localization | Flutter ARB files | `lib/l10n/app_en.arb`, `lib/l10n/app_ar.arb` |
| Forms | Flutter `Form` + `GlobalKey<FormState>` | Feature dialog components |
| Pagination | `infinite_scroll_pagination` (available) + `BasePagination` widget | Screens |
| Responsive | `responsive_framework` | `app.dart` — MOBILE ≤450, TABLET ≤800, DESKTOP ≤1920 |

---

## The Single Rule That Governs Everything

```
Screen → watches Notifier → calls Client → calls API
```

**Never skip a layer. Never add a layer.**

- A screen never calls a Retrofit client directly.
- A Retrofit client never touches state or shows toasts.
- A notifier never touches UI or BuildContext.
- Business logic never lives in a widget.

Violations of this rule will cascade into a mess that is impossible to fix.

---

## Project Folder Structure

```
lib/
│
├── common/                         ← Shared across ALL features (no feature-specific code here)
│   └── widgets/
│       ├── app_table.dart          ← Generic data table (loading + empty + data)
│       ├── app_crud.dart           ← CRUD page shell (header + filters + pagination)
│       ├── app_dialog.dart         ← Modal dialog wrapper
│       ├── base_pagination.dart    ← Page-based navigation widget
│       ├── stat_card.dart          ← Dashboard metric card
│       └── app_field/
│           ├── app_input_field.dart         ← Text input, textarea
│           ├── app_auto_complete_field.dart ← Async API-backed dropdown
│           └── app_multi_lang_field.dart    ← Arabic + English dual input
│
├── data/                           ← Cross-feature infrastructure (auth, settings, HTTP)
│   ├── models/                     ← Shared Freezed models (AuthenticationModel, PaginatedResponse, etc.)
│   ├── providers/                  ← authentication_provider, settings_provider (cross-feature only)
│   └── services/
│       ├── http/
│       │   └── dio_module.dart     ← THE ONLY PLACE that configures Dio + interceptors
│       ├── interceptors/
│       │   └── authenticator.dart  ← Adds Bearer token to every request
│       └── clients/
│           ├── _clients.dart       ← Re-exports: dio, retrofit, riverpod_annotation, freezed_annotation
│           └── callback.dart       ← Type aliases: FutureApiResponse<T>, FuturePaginatedResponse<T>
│
├── features/                       ← ONE FOLDER PER BUSINESS DOMAIN
│   └── <feature_name>/
│       ├── models/                 ← Freezed domain model
│       ├── services/               ← Retrofit client (HTTP ONLY, zero side effects)
│       ├── providers/              ← Riverpod notifier + state (orchestration)
│       ├── components/             ← Feature-specific dialogs and forms
│       └── screens/                ← Thin orchestration screen
│
├── router/
│   ├── routes/app_routes.dart      ← ALL typed route declarations live here
│   ├── routes/app_routes.g.dart    ← Generated — update manually if no build_runner
│   ├── router_configuration.dart   ← Auth guard logic
│   └── app_router.dart             ← Exports: HomeRoute, SignInRoute, DepartmentsRoute, ...
│
├── src/                            ← Legacy UI layer (auth, home) — migrate to features/ for new work
│   ├── auth/signin_page.dart
│   └── home/home_page.dart
│
├── theme/                          ← ALL colors and text styles defined here, nowhere else
│   ├── app_colors.dart             ← Seed color, light/dark ColorScheme
│   └── app_theme.dart              ← AppTheme.light, AppTheme.dark
│
├── l10n/                           ← Localization (English + Arabic)
│   ├── app_en.arb
│   └── app_ar.arb
│
└── utils/
    ├── constants/
    │   └── api_document.dart       ← ApiDocument.baseUrl — change API here and ONLY here
    ├── snackbar.dart               ← Utils.showSuccessSnackBar(), Utils.showErrorSnackBar()
    └── extensions.dart             ← context.l10n, context.theme, context.colorScheme, etc.
```

---

## Code Generation

Run this after **any** change to `@freezed`, `@RestApi`, `@riverpod`, or `@TypedGoRoute`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Generator order (enforced by `build.yaml`): **Freezed → json_serializable → retrofit_generator → riverpod_generator → go_router_builder**

Generated files end in `.g.dart` or `.freezed.dart`. They are gitignored from the analyzer but required at compile time. If you cannot run build_runner, **write the generated files manually** following the exact pattern of existing `.g.dart` files in this repo.

---

## Layer 1: Models — How to Write Them

**Location**: `lib/features/<name>/models/<name>_model.dart`

**Template** (copy this exactly):

```dart
import 'package:app/data/models/_models.dart';

part '<name>_model.freezed.dart';
part '<name>_model.g.dart';

@freezed
abstract class DepartmentModel with _$DepartmentModel {
  const DepartmentModel._();   // ← required for custom getters

  @jsonSerializable              // ← custom alias = @JsonSerializable(explicitToJson: true)
  const factory DepartmentModel({
    required int id,
    required String name,
    String? description,
    String? code,
    int? managerId,
    double? budget,
  }) = _DepartmentModel;

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentModelFromJson(json);
}
```

**Rules**:
- Import `package:app/data/models/_models.dart` (gives you `@freezed`, `@jsonSerializable`, and type aliases).
- Use `@jsonSerializable` (not raw `@JsonSerializable()`) on the factory constructor.
- Add `const ClassName._()` when you need computed getters.
- Field names must match the JSON key names from the API exactly.
- Never put business logic, HTTP calls, or UI code in a model file.

---

## Layer 2: Services (Retrofit Clients) — How to Write Them

**Location**: `lib/features/<name>/services/<name>_client.dart`

**Template** (copy this exactly):

```dart
import 'package:app/data/services/clients/_clients.dart';
import 'package:app/data/services/clients/callback.dart';
import 'package:app/features/departments/models/department_model.dart';

part 'department_client.g.dart';

@riverpod
DepartmentClient departmentClient(Ref ref) => DepartmentClient(ref.dio);

@RestApi()
abstract class DepartmentClient {
  factory DepartmentClient(Dio dio, {String baseUrl}) = _DepartmentClient;

  @GET('/departments')
  FuturePaginatedResponse<DepartmentModel> getDepartments(
    @Query('pageNumber') int pageNumber,
    @Query('pageSize') int pageSize, {
    @Query('name') String? name,   // ← optional filters as named params
  });

  @GET('/departments/{id}')
  FutureApiResponse<DepartmentModel> getDepartmentById(@Path('id') int id);

  @POST('/departments')
  FutureApiResponse<DepartmentModel> createDepartment(@Body() Map<String, dynamic> body);

  @PUT('/departments/{id}')
  FutureApiResponse<DepartmentModel> updateDepartment(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/departments/{id}')
  Future<void> deleteDepartment(@Path('id') int id);
}
```

**Type aliases** (from `callback.dart`):
- `FutureApiResponse<T>` = `Future<HttpResponse<T>>` — single object response
- `FuturePaginatedResponse<T>` = `Future<HttpResponse<PaginatedResponse<T>>>` — paginated list

**`PaginatedResponse<T>`** (from `lib/data/models/paginated_response.dart`):
```
result: List<T>   ← the items
count: int        ← total count (all pages)
message: String
statusCode: int
```

**Non-negotiable rules for services**:
- Import `_clients.dart` (provides `@riverpod`, `Ref`, `Dio`, `@RestApi`, etc.).
- Import `callback.dart` (provides `FutureApiResponse`, `FuturePaginatedResponse`).
- `ref.dio` extension is available via `_clients.dart` → `http_lib.dart` → `dio_module.dart`.
- **NEVER** call `Utils.showSuccessSnackBar()` or `Utils.showErrorSnackBar()` here.
- **NEVER** read or write Riverpod state here.
- **NEVER** use `BuildContext` here.
- **NEVER** add `try/catch` for toast display here — the interceptor handles it.
- Return types are always typed. Never return `dynamic`.

---

## Layer 3: Providers (Notifiers) — How to Write Them

**Location**: `lib/features/<name>/providers/<name>_provider.dart`

**State template**:

```dart
import 'package:app/features/departments/models/department_model.dart';
import 'package:app/features/departments/services/department_client.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'department_provider.freezed.dart';
part 'department_provider.g.dart';

@freezed
abstract class DepartmentState with _$DepartmentState {
  const DepartmentState._();              // ← REQUIRED: enables custom getters on the class
  const factory DepartmentState({
    @Default([]) List<DepartmentModel> items,
    @Default(false) bool isLoading,
    @Default(1) int page,
    @Default(10) int pageSize,
    @Default(0) int totalCount,
    @Default(false) bool isCreateOpen,   // ← dialog flags live in state
    @Default(false) bool isEditOpen,
    DepartmentModel? selected,            // ← item being edited
    @Default('') String nameFilter,
  }) = _DepartmentState;
}

@riverpod
class DepartmentNotifier extends _$DepartmentNotifier {
  @override
  DepartmentState build() => const DepartmentState();

  int get totalPages =>
      state.totalCount == 0 ? 1 : (state.totalCount / state.pageSize).ceil();

  Future<void> fetch() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await ref.read(departmentClientProvider).getDepartments(
            state.page,
            state.pageSize,
            name: state.nameFilter.isEmpty ? null : state.nameFilter,
          );
      state = state.copyWith(
        items: response.data.result,
        totalCount: response.data.count,
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
      // Interceptor already showed the error toast. Do NOT add another one here.
    }
  }

  Future<void> create(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    try {
      await ref.read(departmentClientProvider).createDepartment(data);
      state = state.copyWith(isCreateOpen: false);  // ← do NOT set isLoading: false here
      await fetch();  // ← fetch() sets isLoading: false when done (no flicker)
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;        // ← rethrow so the form component can handle field-level errors
    }
  }

  Future<void> update(int id, Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    try {
      await ref.read(departmentClientProvider).updateDepartment(id, data);
      state = state.copyWith(isEditOpen: false, selected: null);
      await fetch();
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> delete(int id) async {
    state = state.copyWith(isLoading: true);
    try {
      await ref.read(departmentClientProvider).deleteDepartment(id);
      state = state.copyWith(selected: null);  // ← clear selected to avoid stale reference
      await fetch();
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  void openCreate() => state = state.copyWith(isCreateOpen: true);
  void closeCreate() => state = state.copyWith(isCreateOpen: false);
  void openEdit(DepartmentModel item) =>
      state = state.copyWith(isEditOpen: true, selected: item);
  void closeEdit() => state = state.copyWith(isEditOpen: false, selected: null);

  void setPage(int page) {
    state = state.copyWith(page: page);
    fetch();
  }

  void setNameFilter(String value) {
    state = state.copyWith(nameFilter: value, page: 1);
    fetch();
  }
}
```

**Non-negotiable rules for notifiers**:
- State is always a `@freezed` data class. No mutable fields.
- Dialog open/close flags (`isCreateOpen`, `isEditOpen`) live in state, not in widgets.
- The currently-edited item (`selected`) lives in state.
- Always `await fetch()` after every successful mutation.
- **NEVER** call `Utils.showSuccessSnackBar()` or `Utils.showErrorSnackBar()` here.
- **NEVER** use `BuildContext` here.
- Rethrow errors from mutations — the calling component decides how to display field-level validation failures.
- Catch errors from `fetch()` silently (interceptor handled the toast already).

---

## Layer 4: Components (Dialogs) — How to Write Them

**Location**: `lib/features/<name>/components/<name>_create_dialog.dart`

> **Import shortcut**: `import 'package:app/common_lib.dart';` gives you ALL shared widgets (`AppCrud`, `AppTable`, `AppDialog`, `AppInputField`, `AppAutoCompleteField`, `AppMultiLangField`, `BasePagination`, `StatCard`), Riverpod, l10n, router, extensions — everything in one line.

**Template**:

```dart
import 'package:app/common_lib.dart';
import 'package:app/features/departments/providers/department_provider.dart';

class DepartmentCreateDialog extends ConsumerStatefulWidget {
  const DepartmentCreateDialog({super.key});
  @override
  ConsumerState<DepartmentCreateDialog> createState() => _State();
}

class _State extends ConsumerState<DepartmentCreateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    try {
      await ref.read(departmentNotifierProvider.notifier).create({
        'name': _nameCtrl.text.trim(),
        if (_codeCtrl.text.trim().isNotEmpty) 'code': _codeCtrl.text.trim(),
      });
      // Dialog closes automatically — notifier sets isCreateOpen = false on success
    } catch (_) {
      // Interceptor already showed the error toast.
      // Form stays open so the user can fix the input.
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(departmentNotifierProvider);
    if (!state.isCreateOpen) return const SizedBox.shrink();

    return AppDialogContent(
      title: 'إضافة قسم جديد',
      isLoading: state.isLoading,
      actions: [
        TextButton(
          onPressed: ref.read(departmentNotifierProvider.notifier).closeCreate,
          child: const Text('إلغاء'),
        ),
        FilledButton(
          onPressed: state.isLoading ? null : _submit,
          child: const Text('حفظ'),
        ),
      ],
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppInputField(
              controller: _nameCtrl,
              label: 'اسم القسم',
              validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
            ),
            const SizedBox(height: 12),
            AppInputField(controller: _codeCtrl, label: 'الرمز'),
          ],
        ),
      ),
    );
  }
}

// Open like this from the screen:
// showDialog(
//   context: context,
//   barrierDismissible: false,
//   builder: (_) => const Dialog(child: DepartmentCreateDialog()),
// );
```

**Rules for dialog components**:
- Use `AppDialogContent` as the visual shell.
- Use Flutter's `Form` + `GlobalKey<FormState>` for validation.
- Watch state to determine visibility (`if (!state.isCreateOpen) return const SizedBox.shrink()`).
- **NEVER** call `Utils.showSuccessSnackBar()` or `Utils.showErrorSnackBar()` here.
- Catch errors silently — the interceptor already showed a toast.
- Let the notifier control open/close state.

---

## Layer 5: Screens — How to Write Them

**Location**: `lib/features/<name>/screens/<name>_screen.dart`

**Template**:

```dart
import 'package:app/common_lib.dart';
import 'package:app/features/departments/components/department_create_dialog.dart';
import 'package:app/features/departments/components/department_edit_dialog.dart';
import 'package:app/features/departments/models/department_model.dart';
import 'package:app/features/departments/providers/department_provider.dart';

class DepartmentsScreen extends ConsumerStatefulWidget {
  const DepartmentsScreen({super.key});
  @override
  ConsumerState<DepartmentsScreen> createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends ConsumerState<DepartmentsScreen> {
  final _searchCtrl = TextEditingController();

  static const _columns = [
    AppTableColumn(key: 'name', label: 'اسم القسم'),
    AppTableColumn(key: 'code', label: 'الرمز'),
    AppTableColumn(key: 'actions', label: 'إجراءات', width: 100),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(departmentNotifierProvider.notifier).fetch(),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Widget _cell(DepartmentModel item, String key) {
    final notifier = ref.read(departmentNotifierProvider.notifier);
    return switch (key) {
      'name' => Text(item.name, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
      'code' => Text(item.code ?? '—'),
      'actions' => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 18),
              onPressed: () {
                notifier.openEdit(item);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Dialog(child: DepartmentEditDialog()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              color: Theme.of(context).colorScheme.error,
              onPressed: () => _confirmDelete(item),
            ),
          ],
        ),
      _ => const SizedBox.shrink(),
    };
  }

  Future<void> _confirmDelete(DepartmentModel item) async {
    final confirmed = await showConfirmDialog(
      context,
      title: context.l10n.confirmDelete,
      message: context.l10n.confirmDeleteMessage,
      confirmLabel: context.l10n.delete,
      confirmColor: Theme.of(context).colorScheme.error,
    );
    if (confirmed == true && mounted) {
      await ref.read(departmentNotifierProvider.notifier).delete(item.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(departmentNotifierProvider);
    final notifier = ref.read(departmentNotifierProvider.notifier);

    return Scaffold(
      body: AppCrud(
        title: 'الأقسام',
        addButtonText: 'إضافة قسم',
        totalCount: state.totalCount,
        onAddPressed: () {
          notifier.openCreate();  // ← MUST call this BEFORE showDialog
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Dialog(child: DepartmentCreateDialog()),
          );
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
        child: AppTable<DepartmentModel>(
          columns: _columns,
          items: state.items,
          isLoading: state.isLoading,
          emptyMessage: 'لا توجد أقسام',
          cellBuilder: _cell,
        ),
      ),
    );
  }
}
```

**Non-negotiable rules for screens**:
- Only `ref.watch()` for reading state (triggers rebuild). Use `ref.read()` for calling notifier methods.
- Call `notifier.fetch()` in `initState` via `addPostFrameCallback`.
- Use `AppCrud` + `AppTable` — do not build the layout from scratch.
- Use `showDialog(builder: (_) => Dialog(child: XCreateDialog()))` to open dialogs.
- Use `showConfirmDialog()` for delete confirmation.
- **Zero business logic here.** If you're writing an `if` that decides what to do with data, move it to the notifier.

---

## The HTTP Interceptor — Read This Before Every Task

**File**: `lib/data/services/http/dio_module.dart`

The Dio instance auto-handles all of these. **You must never replicate any of these behaviors anywhere else.**

### What the interceptor does automatically:

| Event | Automatic behavior | Where defined |
|---|---|---|
| Every request | Adds `Authorization: Bearer <token>` if signed in | `Authenticator` interceptor |
| Every request | Adds `Accept-Language: ar` or `Accept-Language: en` from settings | `onRequest` in `InterceptorsWrapper` |
| POST/PUT/PATCH/DELETE 2xx | Shows a success toast (Arabic message matching the HTTP method) | `onResponse` in `InterceptorsWrapper` |
| Any error response | Extracts message from response body, shows error toast | `onError` in `InterceptorsWrapper` |
| 401 response | Calls `authenticationProvider.logout()` → navigates to `/sign-in` | `onError` in `InterceptorsWrapper` |

### Direct consequence for every file you write:

```dart
// ✅ CORRECT — service method. Just HTTP, nothing else.
Future<void> createDepartment(Map<String, dynamic> body) async {
  await ref.read(departmentClientProvider).createDepartment(body);
  await fetch();
}

// ❌ WRONG — do not add toasts. The interceptor already did it.
Future<void> createDepartment(Map<String, dynamic> body) async {
  await ref.read(departmentClientProvider).createDepartment(body);
  Utils.showSuccessSnackBar('تم الإنشاء بنجاح'); // ← DELETE THIS
  await fetch();
}

// ❌ WRONG — do not add 401 checks anywhere else.
onError: (e) {
  if (e.response?.statusCode == 401) { // ← DELETE THIS, interceptor handles it
    ref.read(authenticationProvider.notifier).logout();
  }
}
```

---

## Shared Widgets — Full API Reference

### `AppTable<T>` — `lib/common/widgets/app_table.dart`

```dart
AppTable<DepartmentModel>(
  columns: [
    const AppTableColumn(key: 'name', label: 'الاسم'),
    const AppTableColumn(key: 'code', label: 'الرمز', width: 120),
    const AppTableColumn(key: 'actions', label: '', width: 80),
  ],
  items: state.items,           // List<T>
  isLoading: state.isLoading,   // shows skeleton rows when true
  emptyMessage: 'لا توجد بيانات',  // shown when items is empty
  cellBuilder: (item, key) {    // you control every cell
    return switch (key) {
      'name' => Text(item.name),
      'actions' => IconButton(...),
      _ => const SizedBox.shrink(),
    };
  },
  onRowTap: (item) => ...,      // optional row tap
)
```

`AppTableColumn` fields: `key` (String, required), `label` (String, required), `width` (double?, optional), `numeric` (bool, default false).

### `AppCrud` — `lib/common/widgets/app_crud.dart`

```dart
AppCrud(
  title: 'الأقسام',
  addButtonText: 'إضافة قسم',       // text on the add button
  totalCount: state.totalCount,     // shows "الإجمالي: N" under title
  onAddPressed: () => ...,          // called when add button tapped
  filters: AppInputField(...),      // any widget — shown in filter bar
  currentPage: state.page,
  totalPages: notifier.totalPages,
  onPageChanged: notifier.setPage,
  child: AppTable(...),             // main content
)
```

`AppCrud` uses `Column` layout with `Expanded` for the child. Wrap it in a `Scaffold(body: AppCrud(...))`. Pagination is only visible when `totalPages > 1` — if there is only one page it hides automatically.

> **Warning**: `AppCrud` requires a bounded-height parent (the `Expanded` inside it needs a `Column`/`Flex` parent). `Scaffold(body: AppCrud(...))` works. `AppCrud` inside another `Column` without `Expanded` wrapping will overflow.

### `AppDialog` + `AppDialogContent` — `lib/common/widgets/app_dialog.dart`

For dialogs that need their own state (forms):
```dart
// In the screen:
showDialog(
  context: context,
  barrierDismissible: false,
  builder: (_) => const Dialog(child: MyCreateDialog()),
);

// MyCreateDialog extends ConsumerStatefulWidget and returns:
return AppDialogContent(
  title: 'إنشاء جديد',
  isLoading: state.isLoading,   // replaces body with spinner
  actions: [
    TextButton(onPressed: ..., child: const Text('إلغاء')),
    FilledButton(onPressed: ..., child: const Text('حفظ')),
  ],
  child: Form(key: _formKey, child: Column(...)),
);
```

For simple confirmations (no state needed):
```dart
final confirmed = await showConfirmDialog(
  context,
  title: 'تأكيد الحذف',
  message: 'هل تريد حذف هذا العنصر؟',
  confirmLabel: 'حذف',
  confirmColor: Theme.of(context).colorScheme.error,
);
if (confirmed == true) { ... }
```

For fully static content (AppDialog.show):
```dart
await AppDialog.show(
  context,
  title: 'تفاصيل',
  content: Text('...'),
  actions: [FilledButton(...)],
);
```

### `AppInputField` — `lib/common/widgets/app_field/app_input_field.dart`

```dart
AppInputField(
  controller: _nameCtrl,           // TextEditingController
  label: 'اسم القسم',
  hint: 'ادخل اسم القسم',          // optional, defaults to label
  validator: (v) => v == null || v.trim().isEmpty ? 'مطلوب' : null,
  onChanged: (value) => ...,
  onSaved: (value) => ...,
  keyboardType: TextInputType.emailAddress,  // optional
  obscureText: false,
  readOnly: false,
  maxLines: 1,                     // for textarea set maxLines > 1
  prefixIcon: const Icon(Icons.search),
  suffixIcon: const Icon(Icons.clear),
)
```

For multi-line text, use `AppTextAreaField` (same API, different defaults):
```dart
AppTextAreaField(controller: _descCtrl, label: 'الوصف', minLines: 3, maxLines: 6)
```

### `AppAutoCompleteField` — `lib/common/widgets/app_field/app_auto_complete_field.dart`

For fields that need to search from an API:
```dart
AppAutoCompleteField(
  label: 'المدير',
  optionsLoader: (query) async {
    final resp = await ref.read(userClientProvider).getUsers(1, 20, name: query);
    return resp.data.result
        .map((u) => AppSelectOption(id: u.id, label: u.fullName ?? u.username))
        .toList();
  },
  onChanged: (id) => setState(() => _managerId = id as int?),
  initialValue: _selectedManager,   // AppSelectOption? for pre-fill
  validator: (opt) => opt == null ? 'مطلوب' : null,
)
```

`AppSelectOption` has: `id` (dynamic), `label` (String).

> **Important**: `AppAutoCompleteField` participates in `Form.validate()` via its internal `TextFormField`. The `validator` callback receives the selected `AppSelectOption?`. Call `_formKey.currentState?.validate()` as normal — it will trigger the validator.

### `AppMultiLangField` — `lib/common/widgets/app_field/app_multi_lang_field.dart`

For name/description fields that need Arabic + English:
```dart
AppMultiLangField(
  label: 'الاسم',
  value: _nameValue,              // MultiLangValue(ar: '...', en: '...')
  onChanged: (val) => setState(() => _nameValue = val),
)
// In submit: 'nameAr': _nameValue.ar, 'nameEn': _nameValue.en
```

`MultiLangValue` has: `ar` (String), `en` (String), `toJson()` → `{'ar': ..., 'en': ...}`.

### `StatCard` — `lib/common/widgets/stat_card.dart`

```dart
StatCard(
  title: 'إجمالي الأقسام',
  value: '24',
  icon: Icons.business_outlined,
  iconColor: Theme.of(context).colorScheme.primary,  // ← NEVER use Colors.*, always from theme
  trend: 0.05,    // > 0 = green up arrow, < 0 = red down arrow, 0 or null = hidden
  trendLabel: '+5% هذا الشهر',
  subtitle: 'آخر تحديث: اليوم',
)
```

Use in a `GridView.count` or `Wrap` on the dashboard page.

### `BasePagination` — `lib/common/widgets/base_pagination.dart`

Embedded automatically inside `AppCrud`. Use standalone only if you need pagination without `AppCrud`:
```dart
BasePagination(
  currentPage: state.page,
  totalPages: notifier.totalPages,
  onPageChanged: notifier.setPage,
)
```

---

## Routing — Complete Rules

All typed routes live in `lib/router/routes/app_routes.dart`. Current routes:
- `/` → `HomeRoute` → `HomePage`
- `/sign-in` → `SignInRoute` → `SignInPage`
- `/departments` → `DepartmentsRoute` → `DepartmentsScreen`

**Adding a new route**:

```dart
// 1. In app_routes.dart, add:
@TypedGoRoute<UsersRoute>(path: '/users')
class UsersRoute extends GoRouteData with $UsersRoute {
  const UsersRoute();
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;
  @override
  Widget build(BuildContext context, GoRouterState state) => const UsersScreen();
}

// 2. In app_router.dart, add to the export show list:
export 'routes/app_routes.dart' show HomeRoute, SignInRoute, DepartmentsRoute, UsersRoute;

// 3. Run build_runner (preferred):
// dart run build_runner build --delete-conflicting-outputs
//
// OR manually add to app_routes.g.dart:
//   a. Add the mixin:
//      mixin $UsersRoute on GoRouteData {
//        static const String _path = '/users';
//        @override String get location => _path;
//      }
//   b. Add the getter:
//      RouteBase get $usersRoute => GoRoute(
//        path: '/users',
//        parentNavigatorKey: UsersRoute.$parentNavigatorKey,
//        builder: (context, state) => const UsersRoute().build(context, state),
//      );
//   c. Update $appRoutes:
//      List<RouteBase> get $appRoutes => [$homeRoute, $signInRoute, $departmentsRoute, $usersRoute];
```

**Navigation from a widget**: `const DepartmentsRoute().go(context)` or `.push(context)` or `.pushReplacement(context)`.

**Navigation from a notifier**: `ref.read(routerProvider).go(const SignInRoute().location)`.

**Auth guard**: Lives in `lib/router/router_configuration.dart`. It reads `authenticationProvider.isSignedIn()`. If false and the route is not `/sign-in`, it redirects to `/sign-in`. The guard is triggered automatically on every navigation via `RouterRefreshNotifier`.

---

## Auth System

```dart
// Check if signed in:
ref.read(authenticationProvider.notifier).isSignedIn() // → bool

// Token is at:
ref.read(authenticationProvider).token // → String?

// Sign out (from anywhere):
ref.read(authenticationProvider.notifier).logout()
// This clears storage AND navigates to /sign-in automatically

// Token is stored in SharedPreferences as JSON (not secure storage).
// The Authenticator interceptor reads it and adds it to every HTTP request.
```

---

## Localization

ARB files: `lib/l10n/app_en.arb`, `lib/l10n/app_ar.arb`.

Access in widgets: `context.l10n.save`, `context.l10n.noData`, etc.

**Available common keys** (both languages already translated):
`save`, `cancel`, `delete`, `confirm`, `create`, `edit`, `update`, `search`, `filters`, `actions`, `addNew`, `loading`, `noData`, `error`, `unexpectedError`, `networkError`, `sessionExpired`, `successCreate`, `successUpdate`, `successDelete`, `confirmDelete`, `confirmDeleteMessage`, `totalItems`, `page`, `of`, `name`, `description`, `arabicLabel`, `englishLabel`.

**Adding a new key**:
1. Add to `lib/l10n/app_en.arb`
2. Add to `lib/l10n/app_ar.arb`
3. Flutter regenerates `AppLocalizations` on next build.

RTL/LTR switches automatically with locale. Never hard-code text direction.

---

## Theme Tokens — Use These, Nothing Else

```dart
// Colors — always from context:
Theme.of(context).colorScheme.primary
Theme.of(context).colorScheme.onPrimary
Theme.of(context).colorScheme.surface
Theme.of(context).colorScheme.onSurface
Theme.of(context).colorScheme.error
Theme.of(context).colorScheme.outline
Theme.of(context).colorScheme.outlineVariant
Theme.of(context).colorScheme.surfaceContainerHighest
Theme.of(context).colorScheme.onSurfaceVariant

// Text styles — always from context:
Theme.of(context).textTheme.headlineMedium
Theme.of(context).textTheme.titleLarge
Theme.of(context).textTheme.bodyLarge
Theme.of(context).textTheme.bodySmall
Theme.of(context).textTheme.labelLarge
Theme.of(context).textTheme.labelMedium

// Shorthand extensions (from lib/utils/extensions.dart):
context.theme          // = Theme.of(context)
context.colorScheme    // = Theme.of(context).colorScheme
context.textTheme      // = Theme.of(context).textTheme
context.l10n           // = AppLocalizations.of(context)

// Extra semantic colors (from AdditionalColors extension on ColorScheme):
context.colorScheme.successText   // = green for positive trends / success states
context.colorScheme.dangerColor   // = red for danger states
context.colorScheme.primaryText   // = blue for primary text
context.colorScheme.secondaryText // = grey for secondary text

// Safe text controller update (prevents Android crash when new text is shorter):
_ctrl.setTextSafely(newValue);    // ← ALWAYS use this when setting from external state
// NEVER: _ctrl.text = newValue;  // crashes on Android when cursor > new text length
```

**Never use**: `Colors.blue`, `Color(0xFF...)`, `TextStyle(fontSize: 16, color: Colors.grey)`, `Directionality(...)`.

---

## Forbidden Patterns — Memorise These

### 1. HTTP call outside a service file
```dart
// ❌ In a screen or notifier:
final response = await Dio().get('/departments');

// ✅ Only through the notifier which calls the client:
await ref.read(departmentNotifierProvider.notifier).fetch();
```

### 2. Toast inside a service or notifier
```dart
// ❌ Never do this anywhere except the interceptor:
Utils.showSuccessSnackBar('تمت الإضافة');
Utils.showErrorSnackBar('حدث خطأ');

// ✅ Interceptor handles it. Just let the exception propagate.
```

### 3. Business logic in a screen
```dart
// ❌ In build() or _submit():
if (department.budget > 100000) {
  // do something special
}

// ✅ In the notifier:
Future<void> create(Map<String, dynamic> data) async {
  if ((data['budget'] as double?) != null && (data['budget'] as double) > 100000) {
    // handle here
  }
}
```

### 4. Hardcoded API base URL
```dart
// ❌ Never:
final dio = Dio()..options.baseUrl = 'http://67.217.62.164:6001/api';

// ✅ Always from ApiDocument:
// Configured once in lib/utils/constants/api_document.dart
// Injected into Dio in lib/data/services/http/dio_module.dart
```

### 5. Repository layer
There is no repository layer. It was deleted on purpose.
```
// ❌ DO NOT create:
lib/data/repositories/
lib/features/*/repositories/

// ✅ The path is: Provider → Client → API. That is all.
```

### 6. Provider files inside feature screen folders
```dart
// ❌ Wrong location:
lib/features/departments/screens/department_state.dart

// ✅ Correct location:
lib/features/departments/providers/department_provider.dart
```

### 7. `Colors.*` or hardcoded `TextStyle` in widget files
```dart
// ❌:
color: Colors.blue
style: TextStyle(fontSize: 16, color: Colors.grey)

// ✅:
color: Theme.of(context).colorScheme.primary
style: Theme.of(context).textTheme.bodyLarge
```

### 8. Raw path strings for navigation
```dart
// ❌:
context.go('/departments');

// ✅:
const DepartmentsRoute().go(context);
```

---

## 8-Step Checklist for Every New Feature

When asked to add a new feature called `<name>` (e.g., users, products, orders):

**Step 1** — Model:
Create `lib/features/<name>/models/<name>_model.dart`.
Follow the template in "Layer 1: Models" above exactly.

**Step 2** — Client:
Create `lib/features/<name>/services/<name>_client.dart`.
Follow the template in "Layer 2: Services" above exactly.
Add endpoints: GET list, GET by ID, POST, PUT, DELETE.

**Step 3** — Generate:
Run `dart run build_runner build --delete-conflicting-outputs`.
If build_runner unavailable, manually write `.g.dart` and `.freezed.dart` files following the patterns in `lib/features/departments/`.

**Step 4** — Provider:
Create `lib/features/<name>/providers/<name>_provider.dart`.
Follow the template in "Layer 3: Providers" above.
State must include: `items`, `isLoading`, `page`, `pageSize`, `totalCount`, `isCreateOpen`, `isEditOpen`, `selected`, and any feature-specific filters.

**Step 5** — Generate again after provider:
`dart run build_runner build --delete-conflicting-outputs`

**Step 6** — Create dialog:
Create `lib/features/<name>/components/<name>_create_dialog.dart`.
Use `AppDialogContent` + `Form` + `AppInputField`.
Follow the template in "Layer 4: Components" above.

**Step 7** — Edit dialog:
Create `lib/features/<name>/components/<name>_edit_dialog.dart`.
Same structure as create, but pre-fill controllers from `state.selected`.

**Critical pre-fill pattern** (copy this exactly — naive `addPostFrameCallback` re-fills on every rebuild):
```dart
NameModel? _prefilled;

@override
Widget build(BuildContext context) {
  final state = ref.watch(nameNotifierProvider);
  if (!state.isEditOpen) return const SizedBox.shrink();

  // Guard: only fill once per selected item, not on every rebuild
  if (state.selected != null && _prefilled != state.selected) {
    _prefilled = state.selected;
    WidgetsBinding.instance.addPostFrameCallback((_) => _fill(state.selected!));
  }
  // ...
}

void _fill(NameModel item) {
  _nameCtrl.setTextSafely(item.name);  // ← use setTextSafely, never .text =
}
```

Call `notifier.update(id, data)` instead of `notifier.create(data)`.

**Step 8** — Screen + route:
Create `lib/features/<name>/screens/<name>_screen.dart`. Follow "Layer 5: Screens" template.
Add `@TypedGoRoute<NameRoute>(path: '/<name>')` to `lib/router/routes/app_routes.dart`.
Add to export in `lib/router/app_router.dart`.
Update `app_routes.g.dart` to include the new route.
Add navigation button to `lib/src/home/home_page.dart`.

---

## Reference Feature: Departments

The canonical complete example is at `lib/features/departments/`. Read every file in it before writing a new feature.

| File | Role |
|---|---|
| `models/department_model.dart` | 12-field Freezed model |
| `models/department_model.freezed.dart` | Generated — do not edit |
| `models/department_model.g.dart` | Generated — do not edit |
| `services/department_client.dart` | 5 Retrofit endpoints |
| `services/department_client.g.dart` | Generated — do not edit |
| `providers/department_provider.dart` | Full state + notifier |
| `providers/department_provider.freezed.dart` | Generated — do not edit |
| `providers/department_provider.g.dart` | Generated — do not edit |
| `components/department_create_dialog.dart` | Create form |
| `components/department_edit_dialog.dart` | Edit form with pre-fill |
| `screens/departments_screen.dart` | Thin orchestration screen |

Route: `DepartmentsRoute` at `/departments` in `app_routes.dart`.
