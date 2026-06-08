import 'package:app/features/departments/models/department_model.dart';
import 'package:app/features/departments/services/department_client.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'department_provider.freezed.dart';
part 'department_provider.g.dart';

// ── State ─────────────────────────────────────────────────────────────────────

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

// ── Notifier ──────────────────────────────────────────────────────────────────

@riverpod
class DepartmentNotifier extends _$DepartmentNotifier {
  @override
  DepartmentState build() => const DepartmentState();

  // ── Fetching ───────────────────────────────────────────────────────────────

  Future<void> fetch() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await ref.read(departmentClientProvider).getDepartments(
            state.page,
            state.pageSize,
            name: state.nameFilter.isEmpty ? null : state.nameFilter,
          );
      final paginated = response.data;
      state = state.copyWith(
        items: paginated.result,
        totalCount: paginated.count,
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  int get totalPages => state.totalCount == 0
      ? 1
      : (state.totalCount / state.pageSize).ceil();

  // ── Mutations ──────────────────────────────────────────────────────────────

  Future<void> create(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    try {
      await ref.read(departmentClientProvider).createDepartment(data);
      state = state.copyWith(isLoading: false, isCreateOpen: false);
      await fetch();
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> update(int id, Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    try {
      await ref.read(departmentClientProvider).updateDepartment(id, data);
      state = state.copyWith(isLoading: false, isEditOpen: false);
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
      state = state.copyWith(isLoading: false);
      await fetch();
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  // ── Dialog control ─────────────────────────────────────────────────────────

  void openCreate() => state = state.copyWith(isCreateOpen: true);

  void closeCreate() => state = state.copyWith(isCreateOpen: false);

  void openEdit(DepartmentModel dept) =>
      state = state.copyWith(isEditOpen: true, selected: dept);

  void closeEdit() => state = state.copyWith(isEditOpen: false, selected: null);

  // ── Filters & pagination ───────────────────────────────────────────────────

  void setPage(int page) {
    state = state.copyWith(page: page);
    fetch();
  }

  void setNameFilter(String value) {
    state = state.copyWith(nameFilter: value, page: 1);
    fetch();
  }

  void resetFilters() {
    state = state.copyWith(nameFilter: '', page: 1);
    fetch();
  }
}
