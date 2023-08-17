import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterSuccessScreen extends StatelessWidget {
  final String email;
  const RegisterSuccessScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/success.svg",
                height: 300,
              ),
              const Text(
                "Berhasil mendaftar",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Email verifikasi telah dikirim ke",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Text(
                email,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Text("Kembali"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
