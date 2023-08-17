import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({Key? key, required this.title, this.button}) : super(key: key);

  final String title;
  final Widget? button;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 35,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                )
              ],
            ),
          ),
          if (button != null) button!,
        ],
      ),
    );
  }
}
