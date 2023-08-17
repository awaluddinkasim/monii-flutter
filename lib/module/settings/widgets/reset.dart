import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monii/module/settings/widgets/confirm_password.dart';

class ResetDataSection extends ConsumerWidget {
  const ResetDataSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Reset Data",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        Row(
          children: [
            const Expanded(
              child: Text(
                "Data pemasukan",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            FilledButton.icon(
              onPressed: () {
                _confirm(context, "income");
              },
              icon: const Icon(
                Icons.delete,
                size: 18,
              ),
              label: const Text("Reset"),
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.redAccent),
                visualDensity: VisualDensity.comfortable,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(
              child: Text(
                "Data pengeluaran",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            FilledButton.icon(
              onPressed: () {
                _confirm(context, "expense");
              },
              icon: const Icon(
                Icons.delete,
                size: 18,
              ),
              label: const Text("Reset"),
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.redAccent),
                visualDensity: VisualDensity.comfortable,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<dynamic> _confirm(context, category) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Peringatan"),
          content: const Text("Data yang telah terhapus tidak dapat dikembalikan"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  context: context,
                  builder: (context) {
                    return ConfirmPassword(category: category);
                  },
                );
              },
              child: const Text("Saya mengerti"),
            ),
          ],
        );
      },
    );
  }
}
