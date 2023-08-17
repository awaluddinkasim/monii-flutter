import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:monii/module/auth/view/register_success.dart';
import 'package:monii/shared/utils/dio.dart';
import 'package:monii/shared/utils/email_validation.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _key = GlobalKey<FormState>();

  final TextEditingController _nama = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _showPassword = false;
  int _index = 0;

  String _errorMessage = "";

  void _register() async {
    final navigator = Navigator.of(context);

    Map data = {
      "nama": _nama.text,
      "email": _email.text,
      "password": _password.text,
      "tz": DateTime.now().timeZoneName,
    };

    try {
      Response response = await dio().post("/register", data: data);
      if (response.statusCode == 200) {
        navigator.pushReplacement(
          MaterialPageRoute(builder: (context) {
            return RegisterSuccessScreen(
              email: _email.text,
            );
          }),
        );
      }
    } on DioException catch (e) {
      context.loaderOverlay.hide();
      setState(() {
        _errorMessage = e.response!.data['message'];
      });
    } finally {
      context.loaderOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    List steps = [
      _dataForm(),
      _credsForm(),
    ];

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: SafeArea(
        top: false,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SvgPicture.asset(
                    "assets/images/form.svg",
                    height: 250,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Silahkan lengkapi data",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    color: Colors.white,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 25,
                        horizontal: 30,
                      ),
                      child: Form(
                        key: _key,
                        child: steps[_index],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Column _dataForm() {
    return Column(
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
              borderRadius: BorderRadius.circular(35),
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
          height: 25,
        ),
        _buttons(),
      ],
    );
  }

  Column _credsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
          keyboardType: TextInputType.emailAddress,
          textCapitalization: TextCapitalization.none,
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Masukkan Email',
            prefixIcon: const Icon(Icons.mail),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(35),
            ),
          ),
          validator: (value) {
            if (value == "" || value == null) {
              return "Harap diisi";
            }
            if (!isValidEmail(value)) {
              return "Email tidak valid";
            }
            return null;
          },
        ),
        const SizedBox(
          height: 15,
        ),
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
              icon: Icon(!_showPassword ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(35),
            ),
          ),
          validator: (value) {
            if (value == "" || value == null) {
              return "Harap diisi";
            }
            if (value.length < 6) {
              return "Jumlah karakter minimal 6";
            }
            return null;
          },
        ),
        if (_errorMessage.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(
          height: 25,
        ),
        _buttons(),
      ],
    );
  }

  Row _buttons() {
    if (_index != 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FilledButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() {
                _index--;
              });
            },
            style: ButtonStyle(
              visualDensity: VisualDensity.comfortable,
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.grey.shade700),
            ),
            child: const Text(
              "Kembali",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              if (_key.currentState!.validate()) {
                setState(() {
                  _errorMessage = "";
                });
                context.loaderOverlay.show();
                _register();
              }
            },
            style: const ButtonStyle(
              visualDensity: VisualDensity.comfortable,
            ),
            child: const Text(
              "Daftar",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(),
        FilledButton(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            if (_key.currentState!.validate()) {
              setState(() {
                _index++;
              });
            }
          },
          style: const ButtonStyle(
            visualDensity: VisualDensity.comfortable,
          ),
          child: const Text(
            "Berikutnya",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
