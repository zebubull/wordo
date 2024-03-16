import 'package:flutter/material.dart';

class CenteredCard extends StatelessWidget {
  final List<Widget> children;
  final double? width;

  CenteredCard({required this.children, this.width});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
        child: Container(
            width: width,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: children))));
  }
}
