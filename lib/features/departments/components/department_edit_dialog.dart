import 'package:app/common/widgets/app_dialog.dart';
import 'package:app/common/widgets/app_field/app_input_field.dart';
import 'package:app/features/departments/models/department_model.dart';
import 'package:app/features/departments/providers/department_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dialog for editing an existing [DepartmentModel].
///
/// Pre-fills all fields from [DepartmentState.selected] whenever
/// [DepartmentState.isEditOpen] transitions to `true`.
class DepartmentEditDialog extends ConsumerStatefulWidget {
  const DepartmentEditDialog({super.key});

  @override
  ConsumerState<DepartmentEditDialog> createState() =>
      _DepartmentEditDialogState();
}

class _DepartmentEditDialogState extends ConsumerState<DepartmentEditDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController();

  DepartmentModel? _prefilled;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _descCtrl.dispose();
    _locationCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _budgetCtrl.dispose();
    super.dispose();
  }

  void _fill(DepartmentModel dept) {
    _nameCtrl.text = dept.name;
    _codeCtrl.text = dept.code ?? '';
    _descCtrl.text = dept.description ?? '';
    _locationCtrl.text = dept.location ?? '';
    _emailCtrl.text = dept.contactEmail ?? '';
    _phoneCtrl.text = dept.contactPhone ?? '';
    _budgetCtrl.text = dept.budget?.toString() ?? '';
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final selected = ref.read(departmentNotifierProvider).selected;
    if (selected == null) return;
    try {
      await ref.read(departmentNotifierProvider.notifier).update(
        selected.id,
        {
          'name': _nameCtrl.text.trim(),
          if (_codeCtrl.text.trim().isNotEmpty) 'code': _codeCtrl.text.trim(),
          if (_descCtrl.text.trim().isNotEmpty) 'description': _descCtrl.text.trim(),
          if (_locationCtrl.text.trim().isNotEmpty) 'location': _locationCtrl.text.trim(),
          if (_emailCtrl.text.trim().isNotEmpty) 'contactEmail': _emailCtrl.text.trim(),
          if (_phoneCtrl.text.trim().isNotEmpty) 'contactPhone': _phoneCtrl.text.trim(),
          if (_budgetCtrl.text.trim().isNotEmpty)
            'budget': double.tryParse(_budgetCtrl.text.trim()),
        },
      );
    } catch (_) {
      // Interceptor already shows error toast.
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(departmentNotifierProvider);
    final notifier = ref.read(departmentNotifierProvider.notifier);

    // Pre-fill when a department is selected.
    if (state.isEditOpen && state.selected != null && _prefilled != state.selected) {
      _prefilled = state.selected;
      WidgetsBinding.instance.addPostFrameCallback((_) => _fill(state.selected!));
    }

    if (!state.isEditOpen) return const SizedBox.shrink();

    return AppDialogContent(
      title: 'تعديل القسم',
      isLoading: state.isLoading,
      actions: [
        TextButton(
          onPressed: notifier.closeEdit,
          child: const Text('إلغاء'),
        ),
        FilledButton(
          onPressed: state.isLoading ? null : _submit,
          child: const Text('حفظ التغييرات'),
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
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null,
            ),
            const SizedBox(height: 12),
            AppInputField(
              controller: _codeCtrl,
              label: 'رمز القسم',
            ),
            const SizedBox(height: 12),
            AppTextAreaField(
              controller: _descCtrl,
              label: 'الوصف',
              minLines: 2,
              maxLines: 4,
            ),
            const SizedBox(height: 12),
            AppInputField(
              controller: _locationCtrl,
              label: 'الموقع',
            ),
            const SizedBox(height: 12),
            AppInputField(
              controller: _budgetCtrl,
              label: 'الميزانية',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            AppInputField(
              controller: _emailCtrl,
              label: 'البريد الإلكتروني',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            AppInputField(
              controller: _phoneCtrl,
              label: 'رقم الهاتف',
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }
}

void showDepartmentEditDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Dialog(
      child: DepartmentEditDialog(),
    ),
  );
}
