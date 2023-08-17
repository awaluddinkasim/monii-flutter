import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:monii/model/user.dart';
import 'package:monii/shared/providers/auth.dart';
import 'package:monii/shared/utils/dio.dart';
import 'package:monii/shared/utils/snackbar.dart';
import 'package:monii/shared/widgets/custom_title.dart';

class EditAccountScreen extends ConsumerStatefulWidget {
  final User user;
  const EditAccountScreen({super.key, required this.user});

  @override
  ConsumerState<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends ConsumerState<EditAccountScreen> {
  final _key = GlobalKey<FormState>();

  final TextEditingController _nama = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _showPassword = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    initialValue();
  }

  void initialValue() {
    _nama.text = widget.user.nama!;
    _email.text = widget.user.email!;
  }

  void _update() async {
    var token = ref.read(authProvider).token;
    var navigator = Navigator.of(context);
    Map data = {
      "nama": _nama.text,
      "password": _password.text,
    };
    try {
      Response response = await dio(token: token).put("/user/update", data: data);
      if (response.statusCode == 200) {
        ref.read(authProvider.notifier).updateUser(response.data['user']);
        navigator.pop();
      }
    } on DioException catch (e) {
      setState(() {
        _errorMessage = e.response!.data['message'];
      });
    } finally {
      context.loaderOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage.isNotEmpty) {
      showSnackBar(context, _errorMessage);
    }

    return Scaffold(
      body: SafeArea(
        top: false,
        child: ListView(
          children: [
            const CustomTitle(title: "Edit Akun"),
            SvgPicture.asset(
              "assets/images/account.svg",
              height: 320,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Nama Lengkap",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: _nama,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Masukkan Nama',
                        prefixIcon: const Icon(Icons.badge),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == "" || value == null) {
                          return "Harap diisi";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: _email,
                      readOnly: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        isDense: true,
                        hintText: 'Masukkan Email',
                        prefixIcon: const Icon(Icons.mail),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Password Baru",
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          icon: Icon(!_showPassword
                              ? CupertinoIcons.eye_fill
                              : CupertinoIcons.eye_slash_fill),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value != "") {
                          if (value!.length < 6) {
                            return "Jumlah karakter minimal 6";
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Kosongkan jika tidak ingin mengganti password",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    FilledButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_key.currentState!.validate()) {
                          context.loaderOverlay.show();
                          _update();
                        }
                      },
                      style: const ButtonStyle(
                        visualDensity: VisualDensity.comfortable,
                      ),
                      child: const Text(
                        "Simpan",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        visualDensity: VisualDensity.comfortable,
                        backgroundColor: MaterialStatePropertyAll<Color>(Colors.grey.shade700),
                      ),
                      child: const Text(
                        "Batal",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
