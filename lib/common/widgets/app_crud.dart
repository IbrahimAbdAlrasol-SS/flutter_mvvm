import 'package:app/common/widgets/base_pagination.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// CRUD page shell — mirrors the Nuxt `AppCrud` component.
///
/// Renders:
///  - A page header with [title] and an optional "Add" button.
///  - An optional [filters] widget row beneath the header.
///  - The main [child] (typically an [AppTable]).
///  - An optional [BasePagination] at the bottom.
///
/// All business logic stays outside this widget.
class AppCrud extends StatelessWidget {
  const AppCrud({
    super.key,
    this.title,
    this.addButtonText,
    this.onAddPressed,
    this.filters,
    required this.child,
    this.currentPage,
    this.totalPages,
    this.onPageChanged,
    this.totalCount,
  });

  final String? title;
  final String? addButtonText;
  final VoidCallback? onAddPressed;

  /// Optional filter widgets rendered in a scrollable row below the header.
  final Widget? filters;

  /// Main content — pass your [AppTable] here.
  final Widget child;

  final int? currentPage;
  final int? totalPages;
  final ValueChanged<int>? onPageChanged;

  /// Optional total count shown in the header.
  final int? totalCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final showPagination =
        totalPages != null && totalPages! > 1 && onPageChanged != null && currentPage != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Header bar ────────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              bottom: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
          ),
          child: Row(
            children: [
              if (title != null)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title!,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (totalCount != null)
                        Text(
                          l10n.totalItems(totalCount!),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
              if (onAddPressed != null)
                FilledButton.icon(
                  onPressed: onAddPressed,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(addButtonText ?? l10n.addNew),
                ),
            ],
          ),
        ),

        // ── Filters ───────────────────────────────────────────────────────
        if (filters != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLowest,
              border: Border(
                bottom: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
            ),
            child: filters!,
          ),

        // ── Main content ──────────────────────────────────────────────────
        Expanded(child: child),

        // ── Pagination ────────────────────────────────────────────────────
        if (showPagination)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: BasePagination(
              currentPage: currentPage!,
              totalPages: totalPages!,
              onPageChanged: onPageChanged!,
            ),
          ),
      ],
    );
  }
}
