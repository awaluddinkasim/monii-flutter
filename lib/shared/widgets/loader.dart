import 'package:flutter/material.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 30,
        width: 30,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
