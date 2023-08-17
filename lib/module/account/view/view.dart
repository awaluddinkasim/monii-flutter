import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:monii/model/user.dart';
import 'package:monii/module/account/view/edit.dart';
import 'package:monii/module/auth/view/login.dart';
import 'package:monii/module/settings/view.dart';
import 'package:monii/shared/providers/auth.dart';
import 'package:monii/shared/providers/expense.dart';
import 'package:monii/shared/providers/income.dart';
import 'package:monii/shared/providers/stats.dart';
import 'package:page_transition/page_transition.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    User? user = ref.read(authProvider).user;

    ref.listen(
      authProvider.select((value) => describeEnum(value.status)),
      (prev, next) {
        if (next == "unauthenticated") {
          context.loaderOverlay.hide();

          ref.read(statsProvider.notifier).resetState();
          ref.read(incomeProvider.notifier).resetState();
          ref.read(expenseProvider.notifier).resetState();

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
              return const LoginScreen();
            }),
            (route) => false,
          );
        }
      },
    );

    return Scaffold(
      body: SafeArea(
        top: false,
        child: ListView(
          children: [
            Stack(
              children: [
                Transform(
                  transform: Matrix4.translationValues(
                    0,
                    -MediaQuery.of(context).viewPadding.top,
                    0,
                  ),
                  child: ClipPath(
                    clipper: CustomClipPath2(),
                    child: Container(
                      color: Theme.of(context).primaryColor.withOpacity(0.4),
                      height: 370,
                    ),
                  ),
                ),
                Transform(
                  transform: Matrix4.translationValues(
                    0,
                    -MediaQuery.of(context).viewPadding.top,
                    0,
                  ),
                  child: ClipPath(
                    clipper: CustomClipPath(),
                    child: Container(
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                      height: 385,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Center(
                        child: ClipOval(
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: ClipOval(
                              child: SizedBox(
                                height: 180,
                                width: 180,
                                child: Image.asset(
                                  "assets/images/avatar.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${user?.nama}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${user?.email}",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: EditAccountScreen(
                                user: user!,
                              ),
                              type: PageTransitionType.rightToLeft,
                            ),
                          ).then((_) {
                            setState(() {
                              user = ref.read(authProvider).user;
                            });
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        leading: const Icon(Icons.person),
                        title: const Text("Edit Akun"),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: const SettingScreen(),
                              type: PageTransitionType.rightToLeft,
                            ),
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        leading: const Icon(Icons.settings),
                        title: const Text("Pengaturan"),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      ListTile(
                        onTap: () {
                          context.loaderOverlay.show();
                          ref.read(authProvider.notifier).logout();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        leading: const Icon(Icons.exit_to_app),
                        title: const Text("Logout"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 180);
    path.quadraticBezierTo(
      size.width / 4,
      size.height - 30,
      size.width,
      size.height - 80,
    );
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class CustomClipPath2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 100);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
