import 'package:flutter/material.dart';

/// Page-based pagination control.  Renders Previous / numbered pages / Next.
/// Emits [onPageChanged] when the user selects a new page (1-indexed).
class BasePagination extends StatelessWidget {
  const BasePagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.maxLinksShown = 5,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  /// Maximum numbered page links visible (excluding prev/next).
  final int maxLinksShown;

  List<int?> _buildPageLinks() {
    if (totalPages <= maxLinksShown) {
      return List.generate(totalPages, (i) => i + 1);
    }
    final half = maxLinksShown ~/ 2;
    int start = (currentPage - half).clamp(1, totalPages - maxLinksShown + 1);
    int end = (start + maxLinksShown - 1).clamp(1, totalPages);

    final links = <int?>[];
    if (start > 1) {
      links.add(1);
      if (start > 2) links.add(null); // ellipsis
    }
    for (int p = start; p <= end; p++) {
      links.add(p);
    }
    if (end < totalPages) {
      if (end < totalPages - 1) links.add(null); // ellipsis
      links.add(totalPages);
    }
    return links;
  }

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;
    final links = _buildPageLinks();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _NavButton(
          icon: Icons.arrow_back_ios,
          onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
        ),
        const SizedBox(width: 4),
        ...links.map((page) {
          if (page == null) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text('…'),
            );
          }
          final isActive = page == currentPage;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: FilledButton.tonal(
              style: FilledButton.styleFrom(
                minimumSize: const Size(36, 36),
                padding: EdgeInsets.zero,
                backgroundColor: isActive ? scheme.primary : null,
                foregroundColor: isActive ? scheme.onPrimary : null,
              ),
              onPressed: isActive ? null : () => onPageChanged(page),
              child: Text('$page'),
            ),
          );
        }),
        const SizedBox(width: 4),
        _NavButton(
          icon: Icons.arrow_forward_ios,
          onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      icon: Icon(icon, size: 18),
      onPressed: onPressed,
      style: IconButton.styleFrom(minimumSize: const Size(36, 36)),
    );
  }
}
