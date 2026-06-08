import 'package:app/utils/extensions.dart';
import 'package:flutter/material.dart';

/// Dashboard metric card — mirrors the Nuxt `StatCard` component.
///
/// Shows [title], a large [value], an optional [subtitle], and an [icon].
/// [trend] > 0 shows a green up arrow; < 0 shows a red down arrow.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.trend,
    this.trendLabel,
  });

  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;

  /// Positive = up (green), negative = down (red), null = hidden.
  final double? trend;
  final String? trendLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final hasTrend = trend != null && trend != 0.0;
    final trendColor = !hasTrend ? null : trend! > 0 ? scheme.successText : scheme.error;
    final trendIcon =
        !hasTrend ? null : trend! > 0 ? Icons.trending_up : Icons.trending_down;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (icon != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (iconColor ?? scheme.primary).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 20, color: iconColor ?? scheme.primary),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle != null || trend != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  if (trendIcon != null && trendColor != null)
                    Icon(trendIcon, size: 16, color: trendColor),
                  if (trendLabel != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      trendLabel!,
                      style: theme.textTheme.bodySmall?.copyWith(color: trendColor),
                    ),
                  ],
                  if (subtitle != null) ...[
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
