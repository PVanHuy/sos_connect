import 'package:flutter/material.dart';
import 'package:sos_connect/gen/assets.gen.dart';

class ImageBgWidget extends StatelessWidget {
  const ImageBgWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(Assets.images.bgSignIn.path), fit: .cover),
        ),
        child: child,
      ),
    );
  }
}
