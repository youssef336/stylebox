import 'package:flutter/material.dart';

/// A titled group of settings rows inside one rounded card, separated by
/// inset hairlines.
class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key, this.title, required this.children});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        rows.add(
          Divider(
            height: 1,
            indent: 64,
            endIndent: 16,
            color: Theme.of(context).dividerColor,
          ),
        );
      }
      rows.add(children[i]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 6, bottom: 10),
            child: Text(
              title!.toUpperCase(),
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.4,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        Material(
          color: scheme.surface,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: BorderSide(color: Theme.of(context).dividerColor),
          ),
          child: Column(children: rows),
        ),
      ],
    );
  }
}

/// One settings row: tinted square icon, label, optional value / control.
class ProfileViewItem extends StatelessWidget {
  const ProfileViewItem({
    super.key,
    required this.headText,
    required this.icon,
    required this.onPressed,
    this.trailingText,
    this.trailing,
    this.destructive = false,
  });
  final String headText;
  final IconData icon;
  final void Function()? onPressed;
  final String? trailingText;
  final Widget? trailing;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tint = destructive ? scheme.error : scheme.primary;

    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: tint, size: 19),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  headText,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: destructive ? scheme.error : scheme.onSurface,
                  ),
                ),
              ),
              if (trailingText != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 6),
                  child: Text(
                    trailingText!,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              if (trailing != null)
                trailing!
              else if (!destructive)
                Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.chevron_left_rounded
                      : Icons.chevron_right_rounded,
                  size: 22,
                  color: scheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
