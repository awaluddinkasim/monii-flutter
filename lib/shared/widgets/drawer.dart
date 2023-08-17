import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monii/module/expense/view.dart';
import 'package:monii/module/home/view.dart';
import 'package:monii/module/income/view.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DrawerWidget extends StatelessWidget {
  final String selectedMenu;
  const DrawerWidget({super.key, required this.selectedMenu});

  @override
  Widget build(BuildContext context) {
    String? version;
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version = packageInfo.version;
    });

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.7),
            ),
            child: SvgPicture.asset(
              "assets/images/savings.svg",
              fit: BoxFit.cover,
            ),
          ),
          ListTile(
            selected: selectedMenu == "home",
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              if (selectedMenu == "home") return;
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                return const HomeScreen();
              }));
            },
          ),
          ListTile(
            selected: selectedMenu == "income",
            leading: const Icon(Icons.trending_up_rounded),
            title: const Text('Income'),
            onTap: () {
              if (selectedMenu == "income") return;
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                return const IncomeScreen();
              }));
            },
          ),
          ListTile(
            selected: selectedMenu == "expense",
            leading: const Icon(Icons.trending_down_rounded),
            title: const Text('Expense'),
            onTap: () {
              if (selectedMenu == "expense") return;
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                return const ExpenseScreen();
              }));
            },
          ),
          ListTile(
            selected: selectedMenu == "about",
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('About'),
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Tentang"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                            "Monii adalah sebuah aplikasi yang dirancang untuk membantu pengguna dalam mengelola keuangan pribadi dengan cara yang efisien dan mudah. Aplikasi ini memungkinkan pengguna untuk mencatat pengeluaran dan pemasukan keuangan mereka sehari-hari dengan cepat, serta memberikan visualisasi grafik harian atau bulanan untuk memberikan gambaran yang lebih jelas tentang pola pengeluaran dan pemasukan mereka."),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Design Illustration",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text("Freepik Storyset"),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "App Version",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(version!),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Contact Developer",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text("awaluddinkasim7@gmail.com"),
                      ],
                    ),
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('Tutup'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
