import 'package:app/common/widgets/app_crud.dart';
import 'package:app/common/widgets/app_dialog.dart';
import 'package:app/common/widgets/app_field/app_input_field.dart';
import 'package:app/common/widgets/app_table.dart';
import 'package:app/features/departments/components/department_create_dialog.dart';
import 'package:app/features/departments/components/department_edit_dialog.dart';
import 'package:app/features/departments/models/department_model.dart';
import 'package:app/features/departments/providers/department_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Thin orchestration screen for the Departments domain.
///
/// Responsibilities:
///  - Watch [departmentNotifierProvider] and pass state to dumb widgets.
///  - Call notifier methods in response to user events.
///  - Render [AppCrud] + [AppTable] + dialogs.
///
/// No business logic here — everything is delegated to [DepartmentNotifier].
class DepartmentsScreen extends ConsumerStatefulWidget {
  const DepartmentsScreen({super.key});

  @override
  ConsumerState<DepartmentsScreen> createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends ConsumerState<DepartmentsScreen> {
  final _searchCtrl = TextEditingController();

  // Column definitions — analogous to tableHeader() in the Nuxt reference.
  static const _columns = [
    AppTableColumn(key: 'name', label: 'اسم القسم'),
    AppTableColumn(key: 'code', label: 'الرمز'),
    AppTableColumn(key: 'location', label: 'الموقع'),
    AppTableColumn(key: 'budget', label: 'الميزانية'),
    AppTableColumn(key: 'contactEmail', label: 'البريد الإلكتروني'),
    AppTableColumn(key: 'actions', label: 'الإجراءات', width: 120),
  ];

  @override
  void initState() {
    super.initState();
    // Initial data fetch on first mount.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(departmentNotifierProvider.notifier).fetch(),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Widget _buildCell(DepartmentModel dept, String key) {
    final notifier = ref.read(departmentNotifierProvider.notifier);
    switch (key) {
      case 'name':
        return Text(dept.name, style: const TextStyle(fontWeight: FontWeight.w500));
      case 'code':
        return Text(dept.code ?? '—');
      case 'location':
        return Text(dept.location ?? '—');
      case 'budget':
        return Text(dept.budget != null ? dept.budget!.toStringAsFixed(0) : '—');
      case 'contactEmail':
        return Text(dept.contactEmail ?? '—');
      case 'actions':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 18),
              tooltip: 'تعديل',
              onPressed: () {
                notifier.openEdit(dept);
                showDepartmentEditDialog(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              tooltip: 'حذف',
              color: Theme.of(context).colorScheme.error,
              onPressed: () => _confirmDelete(dept),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _confirmDelete(DepartmentModel dept) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'تأكيد الحذف',
      message: 'هل أنت متأكد أنك تريد حذف "${dept.name}"؟',
      confirmLabel: 'حذف',
      confirmColor: Theme.of(context).colorScheme.error,
    );
    if (confirmed == true && mounted) {
      await ref.read(departmentNotifierProvider.notifier).delete(dept.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(departmentNotifierProvider);
    final notifier = ref.read(departmentNotifierProvider.notifier);
    final totalPages = notifier.totalPages;

    return Scaffold(
      body: AppCrud(
        title: 'الأقسام',
        addButtonText: 'إضافة قسم',
        totalCount: state.totalCount,
        onAddPressed: () {
          notifier.openCreate();
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Dialog(child: DepartmentCreateDialog()),
          );
        },
        filters: AppInputField(
          controller: _searchCtrl,
          label: 'بحث باسم القسم',
          prefixIcon: const Icon(Icons.search, size: 18),
          onChanged: notifier.setNameFilter,
        ),
        currentPage: state.page,
        totalPages: totalPages,
        onPageChanged: notifier.setPage,
        child: AppTable<DepartmentModel>(
          columns: _columns,
          items: state.items,
          isLoading: state.isLoading,
          emptyMessage: 'لا توجد أقسام بعد',
          cellBuilder: _buildCell,
        ),
      ),
    );
  }
}
