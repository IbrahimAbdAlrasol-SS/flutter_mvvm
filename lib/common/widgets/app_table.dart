import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Column definition for [AppTable].
class AppTableColumn {
  const AppTableColumn({
    required this.key,
    required this.label,
    this.width,
    this.numeric = false,
  });

  final String key;
  final String label;
  final double? width;
  final bool numeric;
}

/// Generic, dumb data-table widget.
///
/// - Shows a shimmer skeleton while [isLoading] is `true`.
/// - Shows an empty-state illustration when [items] is empty.
/// - Delegates cell rendering entirely to [cellBuilder], keeping this widget
///   free of any business or domain knowledge.
///
/// Pagination is handled externally (see [BasePagination]).
class AppTable<T> extends StatelessWidget {
  const AppTable({
    super.key,
    required this.columns,
    required this.items,
    required this.cellBuilder,
    this.isLoading = false,
    this.emptyMessage,
    this.onRowTap,
    this.skeletonRowCount = 5,
  });

  final List<AppTableColumn> columns;
  final List<T> items;
  final Widget Function(T item, String columnKey) cellBuilder;
  final bool isLoading;
  final String? emptyMessage;
  final void Function(T item)? onRowTap;
  final int skeletonRowCount;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return _TableSkeleton(columns: columns, rowCount: skeletonRowCount);
    if (items.isEmpty) return _EmptyState(message: emptyMessage);
    return _DataBody(
      columns: columns,
      items: items,
      cellBuilder: cellBuilder,
      onRowTap: onRowTap,
    );
  }
}

// ── Internal widgets ──────────────────────────────────────────────────────────

class _DataBody<T> extends StatelessWidget {
  const _DataBody({
    required this.columns,
    required this.items,
    required this.cellBuilder,
    this.onRowTap,
  });

  final List<AppTableColumn> columns;
  final List<T> items;
  final Widget Function(T item, String columnKey) cellBuilder;
  final void Function(T item)? onRowTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            theme.colorScheme.surfaceContainerHighest,
          ),
          border: TableBorder(
            horizontalInside: BorderSide(
              color: theme.colorScheme.outlineVariant,
              width: 0.5,
            ),
          ),
          dataRowMinHeight: 48,
          dataRowMaxHeight: 64,
          columns: columns
              .map(
                (col) => DataColumn(
                  label: SizedBox(
                    width: col.width,
                    child: Text(
                      col.label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  numeric: col.numeric,
                ),
              )
              .toList(),
          showCheckboxColumn: false,
          rows: items
              .map(
                (item) => DataRow(
                  onSelectChanged: onRowTap != null ? (_) => onRowTap!(item) : null,
                  cells: columns
                      .map((col) => DataCell(cellBuilder(item, col.key)))
                      .toList(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _TableSkeleton extends StatelessWidget {
  const _TableSkeleton({required this.columns, required this.rowCount});

  final List<AppTableColumn> columns;
  final int rowCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerColor = theme.colorScheme.surfaceContainerHighest;
    final barColor = theme.colorScheme.onSurface.withValues(alpha: 0.12);
    return Column(
      children: [
        Container(
          height: 48,
          color: headerColor,
        ),
        ...List.generate(
          rowCount,
          (i) => _SkeletonRow(columns: columns, barColor: barColor, opacity: 1 - i * 0.1),
        ),
      ],
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow({required this.columns, required this.barColor, this.opacity = 1});

  final List<AppTableColumn> columns;
  final Color barColor;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.clamp(0.3, 1.0),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 0.5),
          ),
        ),
        child: Row(
          children: columns
              .map(
                (col) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _SkeletonBar(
                      width: (col.width ?? 100) * 0.6,
                      height: 12,
                      color: barColor,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _SkeletonBar extends StatelessWidget {
  const _SkeletonBar({required this.width, required this.height, required this.color});

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              message ?? AppLocalizations.of(context)!.noData,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
