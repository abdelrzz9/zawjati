import 'package:flutter/material.dart';

extension AccessibilityExtensions on Widget {
  Widget withSemanticLabel(String label) {
    return Semantics(
      label: label,
      child: this,
    );
  }

  Widget withLiveRegion(bool isLive) {
    return Semantics(
      liveRegion: isLive,
      child: this,
    );
  }

  Widget asHeading(int level) {
    assert(level >= 1 && level <= 6);
    return Semantics(
      header: true,
      child: this,
    );
  }

  Widget asButton({required String label}) {
    return Semantics(
      label: label,
      button: true,
      child: this,
    );
  }

  Widget asImage({required String label}) {
    return Semantics(
      label: label,
      image: true,
      child: this,
    );
  }

  Widget asLink({required String label}) {
    return Semantics(
      label: label,
      link: true,
      child: this,
    );
  }

  Widget withExcludeSemantics({bool exclude = true}) {
    return ExcludeSemantics(
      excluding: exclude,
      child: this,
    );
  }
}

extension SemanticsOrderExtension on BuildContext {
  void sortSemantics(List<FocusNode> order) {
    for (final node in order) {
      node.requestFocus();
    }
  }
}
