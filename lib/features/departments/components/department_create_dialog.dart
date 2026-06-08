import 'package:app/common/widgets/app_dialog.dart';
import 'package:app/common/widgets/app_field/app_input_field.dart';
import 'package:app/features/departments/providers/department_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dialog for creating a new department.
///
/// Opens/closes in sync with [DepartmentState.isCreateOpen].
/// Uses a [GlobalKey<FormState>] for validation — no external validator
/// library needed for this straightforward form.
class DepartmentCreateDialog extends ConsumerStatefulWidget {
  const DepartmentCreateDialog({super.key});

  @override
  ConsumerState<DepartmentCreateDialog> createState() =>
      _DepartmentCreateDialogState();
}

class _DepartmentCreateDialogState
    extends ConsumerState<DepartmentCreateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController();

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

  void _resetForm() {
    _nameCtrl.clear();
    _codeCtrl.clear();
    _descCtrl.clear();
    _locationCtrl.clear();
    _emailCtrl.clear();
    _phoneCtrl.clear();
    _budgetCtrl.clear();
    _formKey.currentState?.reset();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final notifier = ref.read(departmentNotifierProvider.notifier);
    try {
      await notifier.create({
        'name': _nameCtrl.text.trim(),
        if (_codeCtrl.text.trim().isNotEmpty) 'code': _codeCtrl.text.trim(),
        if (_descCtrl.text.trim().isNotEmpty) 'description': _descCtrl.text.trim(),
        if (_locationCtrl.text.trim().isNotEmpty) 'location': _locationCtrl.text.trim(),
        if (_emailCtrl.text.trim().isNotEmpty) 'contactEmail': _emailCtrl.text.trim(),
        if (_phoneCtrl.text.trim().isNotEmpty) 'contactPhone': _phoneCtrl.text.trim(),
        if (_budgetCtrl.text.trim().isNotEmpty)
          'budget': double.tryParse(_budgetCtrl.text.trim()),
      });
      _resetForm();
    } catch (_) {
      // Interceptor already shows error toast; form stays open so user can fix.
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(departmentNotifierProvider);
    final notifier = ref.read(departmentNotifierProvider.notifier);

    if (!state.isCreateOpen) return const SizedBox.shrink();

    return AppDialogContent(
      title: 'إضافة قسم جديد',
      isLoading: state.isLoading,
      actions: [
        TextButton(
          onPressed: () {
            notifier.closeCreate();
            _resetForm();
          },
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

/// Utility to open the create dialog imperatively via `showDialog`.
/// The dialog is driven by [DepartmentState.isCreateOpen] but rendered inside
/// a standard [Dialog] shell so it appears correctly on all screen sizes.
void showDepartmentCreateDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Dialog(
      child: Padding(
        padding: EdgeInsets.all(0),
        child: DepartmentCreateDialog(),
      ),
    ),
  );
}
