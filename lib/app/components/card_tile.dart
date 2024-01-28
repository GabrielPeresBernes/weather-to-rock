import 'package:flutter/material.dart';

class CardTile extends StatelessWidget {
  const CardTile({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
    this.icon,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final hasSubtitle = subtitle != null;

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: icon,
        title: Text(title),
        subtitle: hasSubtitle ? Text(subtitle!) : null,
      ),
    );
  }
}
