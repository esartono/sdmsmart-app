import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Toast extends EasyLoadingAnimation {
  Toast();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return Opacity(
      opacity: controller.value,
      child: RotationTransition(
        turns: controller,
        child: child,
      ),
    );
  }
}
