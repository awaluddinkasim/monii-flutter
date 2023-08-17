import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monii/module/account/view/view.dart';
import 'package:monii/shared/providers/auth.dart';

class HeaderWidget extends ConsumerWidget {
  final Color contentColor;
  final Widget? child;
  const HeaderWidget({super.key, required this.contentColor, this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(authProvider).user;

    return Transform(
      transform: Matrix4.translationValues(
        0,
        -MediaQuery.of(context).viewPadding.top,
        0,
      ),
      child: ClipPath(
        clipper: CustomClipPath(),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            10,
            MediaQuery.of(context).viewPadding.top + 20,
            10,
            50,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.85),
                Theme.of(context).primaryColor,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.menu,
                          color: contentColor,
                        ),
                      ),
                    ),
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return const AccountScreen();
                          }),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 200),
                              child: Text(
                                "${user?.nama}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: contentColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ClipOval(
                              child: Container(
                                color: Colors.white.withOpacity(0.3),
                                height: 30,
                                width: 30,
                                child: Icon(
                                  Icons.person,
                                  color: contentColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              child ?? Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    path.quadraticBezierTo(
      0,
      size.height - 30,
      30,
      size.height - 30,
    );
    path.lineTo(size.width - 30, size.height - 30);
    path.quadraticBezierTo(
      size.width,
      size.height - 30,
      size.width,
      size.height,
    );
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
