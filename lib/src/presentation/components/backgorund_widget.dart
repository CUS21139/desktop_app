import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        SizedBox(
          height: size.height,
          width: size.width,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemBuilder: (c, i) => SizedBox(
              width: size.width * 0.25,
              child: Image.asset(
                'assets/fondo-premio.jpeg',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
        Center(
          child: Image.asset(
            'assets/logo_pdo.png',
            height: size.height * 0.6,
          ),
        ),
        Container(
          child: child,
        ),
      ],
    );
  }
}
