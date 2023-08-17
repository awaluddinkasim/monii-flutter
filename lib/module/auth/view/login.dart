import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:monii/module/auth/view/register.dart';
import 'package:monii/module/home/view.dart';
import 'package:monii/shared/providers/auth.dart';
import 'package:page_transition/page_transition.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _showPassword = false;

  void _login() {
    context.loaderOverlay.show();
    Map data = {
      "email": _email.text,
      "password": _password.text,
      "timezone": DateTime.now().timeZoneName,
    };
    ref.read(authProvider.notifier).login(creds: data);
  }

  @override
  Widget build(BuildContext context) {
    var authState = ref.watch(authProvider);

    ref.listen(
      authProvider.select((value) => describeEnum(value.status)),
      (prev, next) {
        if (next == "authenticated") {
          context.loaderOverlay.hide();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
              return const HomeScreen();
            }),
            (route) => false,
          );
        }
      },
    );

    ref.listen(
      authProvider.select((value) => value.errorMessage),
      (prev, next) {
        if (next != "") {
          context.loaderOverlay.hide();
        }
      },
    );

    return Scaffold(
      body: SafeArea(
        top: false,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 90,
                horizontal: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: "main",
                    child: SvgPicture.asset(
                      "assets/images/money.svg",
                      height: 300,
                    ),
                  ),
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Email',
                      hintText: 'Masukkan Email',
                      prefixIcon: const Icon(Icons.mail),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 30,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    obscureText: !_showPassword,
                    controller: _password,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Password',
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
                        vertical: 5,
                        horizontal: 30,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                  ),
                  if (authState.errorMessage.toString().isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 15,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            authState.errorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 15,
                  ),
                  FilledButton(
                    onPressed: () {
                      _login();
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageTransition(
                          child: const RegisterScreen(),
                          type: PageTransitionType.bottomToTop,
                        ),
                      );
                    },
                    child: Text(
                      "Buat akun",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
