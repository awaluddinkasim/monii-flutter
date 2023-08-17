import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:monii/shared/providers/auth.dart';
import 'package:monii/shared/providers/expense.dart';
import 'package:monii/shared/providers/income.dart';
import 'package:monii/shared/providers/stats.dart';
import 'package:monii/shared/utils/dio.dart';
import 'package:monii/shared/utils/snackbar.dart';

class ConfirmPassword extends ConsumerStatefulWidget {
  final String category;
  const ConfirmPassword({super.key, required this.category});

  @override
  ConsumerState<ConfirmPassword> createState() => _ConfirmPasswordState();
}

class _ConfirmPasswordState extends ConsumerState<ConfirmPassword> {
  final _key = GlobalKey<FormState>();

  final _password = TextEditingController();

  bool _showPassword = false;

  void _delete() async {
    var token = ref.read(authProvider).token;
    String message = "";

    try {
      Response response = await dio(token: token).post("/${widget.category}/delete-all", data: {
        "password": _password.text,
      });
      if (response.statusCode == 200) {
        message = response.data['message'];
        ref.read(statsProvider.notifier).fetchData(token);
        if (widget.category == "income") {
          ref.read(incomeProvider.notifier).fetchData(token);
        } else {
          ref.read(expenseProvider.notifier).fetchData(token);
        }
      }
    } on DioException catch (e) {
      message = e.response!.data['message'];
    } finally {
      Navigator.pop(context);
      showSnackBar(context, message);
      context.loaderOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _key,
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 25,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Password",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  obscureText: !_showPassword,
                  controller: _password,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Masukkan password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                      icon: Icon(
                          !_showPassword ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Harap diisi";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                FilledButton(
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      context.loaderOverlay.show();
                      _delete();
                    }
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(Colors.redAccent),
                  ),
                  child: const Text("Reset"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
