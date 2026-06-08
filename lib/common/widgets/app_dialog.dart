import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// A standardised modal dialog wrapper.
///
/// Use the static [AppDialog.show] helper to open it, or embed [AppDialogContent]
/// directly inside a custom [showDialog] call.
///
/// ```dart
/// await AppDialog.show(
///   context,
///   title: 'Create Department',
///   content: DepartmentForm(onSaved: ...),
///   actions: [
///     TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
///     FilledButton(onPressed: submit, child: Text('Save')),
///   ],
/// );
/// ```
class AppDialog {
  AppDialog._();

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required Widget content,
    List<Widget>? actions,
    bool barrierDismissible = true,
    bool isLoading = false,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => AppDialogContent(
        title: title,
        isLoading: isLoading,
        actions: actions,
        child: content,
      ),
    );
  }
}

/// The visual shell of the dialog.  Can be used standalone if you need a
/// [StatefulWidget] context inside the dialog (e.g., for a form with
/// reactive validation state).
class AppDialogContent extends StatelessWidget {
  const AppDialogContent({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.isLoading = false,
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: MaterialLocalizations.of(context).closeButtonLabel,
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 560,
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: isLoading
            ? const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              )
            : SingleChildScrollView(child: child),
      ),
      actions: actions,
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
    );
  }
}

/// Simple confirmation dialog — resolves `true` on confirm, `null`/`false` on cancel.
Future<bool?> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? confirmLabel,
  String? cancelLabel,
  Color? confirmColor,
}) {
  final l10n = AppLocalizations.of(context)!;
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(cancelLabel ?? l10n.cancel),
        ),
        FilledButton(
          style: confirmColor != null
              ? FilledButton.styleFrom(backgroundColor: confirmColor)
              : null,
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(confirmLabel ?? l10n.confirm),
        ),
      ],
    ),
  );
}
