import 'package:flutter/material.dart';

import '../shared/constants/components_constants.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({
    super.key,
    required this.onRetry,
  });

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(ComponentsConstants.errorMessageTitle),
        const Text(ComponentsConstants.errorMessageSubtitle),
        ElevatedButton(
          onPressed: onRetry,
          child: const Text(ComponentsConstants.errorMessageButton),
        ),
      ],
    );
  }
}
