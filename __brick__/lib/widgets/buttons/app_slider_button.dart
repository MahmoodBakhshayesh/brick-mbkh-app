
import 'package:action_slider/action_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Optional scope: Enter triggers [onActivate] when focus is anywhere INSIDE this subtree.
/// This is focus-scoped (not global): it only works if something in [child] has focus.

class AppSliderButton extends StatefulWidget {
  final double height;
  final double? width;
  final double? fontSize;
  final double? iconSize;
  final double radius;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final FontWeight? fontWeight;
  final bool autofocus;
  final WidgetStatesController? statesController;
  final Widget? child;
  final String label;
  final bool showLoading;
  final bool fade;
  final bool iconInRight;
  final bool disabled;
  final bool reverse;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final BorderSide? borderSide;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  /// When true, Enter/NumpadEnter will trigger the button **only if the button (or its subtree) has focus**.
  /// This avoids global conflicts with PrimaryAction/other handlers.
  final bool listenEnter;

  /// If true (default), button won't activate if it's not actually visible on screen.
  final bool requireVisibleToActivate;
  final PressController? controller;

  const AppSliderButton({
    super.key,
    this.height = 40,
    this.fontSize = 13,
    this.iconSize = 18,
    this.radius = 5,
    this.width,
    this.padding,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.textColor,
    this.focusNode,
    this.borderRadius,
    this.borderSide,
    this.autofocus = false,
    this.iconInRight = false,
    this.disabled = false,
    this.statesController,
    this.showLoading = true,
    this.child,
    this.controller,
    this.icon,
    required this.label,
    this.fade = false,
    this.reverse = false,
    this.color,
    this.fontWeight,
    this.listenEnter = false,
    this.requireVisibleToActivate = true,
  });

  @override
  State<AppSliderButton> createState() => AppSliderButtonState();
}

class AppSliderButtonState extends State<AppSliderButton> {
  bool _loading = false;
  final bool _isVisible = true; // updated by VisibilityDetector
  late final FocusNode _internalFocusNode;

  /// Programmatic trigger
  void triggerTap() => _onTap();

  void press() => _onTap();

  /// 👇 Call this from outside via the GlobalKey and `await` it
  Future<void> trigger() async {
    if (_loading) return; // avoid re-entry
    setState(() => _loading = true);
    final callback = widget.onPressed;
    if (callback == null) return;
    try {
      if (callback is AsyncCallback) {
        if (_loading) return;
        setState(() => _loading = true);
        callback().whenComplete(() {
          if (mounted) setState(() => _loading = false);
        });
      } else {
        callback();
      }
      // await widget.onPressed();
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _internalFocusNode = FocusNode(debugLabel: 'MyButtonFN');
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  void _onTap() {
    if (widget.disabled) return;
    if (widget.requireVisibleToActivate && !_isVisible) return;

    final callback = widget.onPressed;
    if (callback == null) return;

    // If the callback is async, show loading until it completes.
    if (callback is AsyncCallback) {
      if (_loading) return;
      setState(() => _loading = true);
      callback().whenComplete(() {
        if (mounted) setState(() => _loading = false);
      });
    } else {
      callback();
    }
  }

  @override
  Widget build(BuildContext context) {

    return ActionSlider.standard(
      boxShadow: [],
      icon: widget.icon==null?null:Icon(widget.icon!),
      backgroundColor: widget.color,
      rolling: true,
      onTap: onSlide,
      action: onAction,
      loadingIcon: SpinKitCircle(
        color: Colors.white,
        size: 40,
      ),
    );
  }

  Future<void> onSlide(ActionSliderController controller, double pos) async {
    if (widget.disabled) return;
    if (widget.requireVisibleToActivate && !_isVisible) return;

    final callback = widget.onPressed;
    if (callback == null) return;

    // If the callback is async, show loading until it completes.
    if (callback is AsyncCallback) {
      controller.loading();
      setState(() => _loading = true);
      callback().whenComplete(() {
        controller.success();
      });
    } else {
      callback();
    }
  }

  Future<void> onAction(ActionSliderController controller) async {
    // controller.loading(); //starts loading animation
    // await Future.delayed(const Duration(seconds: 3));
    // controller.success(); //starts success animation
    // await Future.delayed(const Duration(seconds: 1));
    // controller.reset(); //resets the slider
    if (widget.disabled) return;
    if (widget.requireVisibleToActivate && !_isVisible) return;

    final callback = widget.onPressed;
    if (callback == null) return;

    // If the callback is async, show loading until it completes.
    if (callback is AsyncCallback) {
      controller.loading();
      setState(() => _loading = true);
      callback().whenComplete(() {
        controller.success();
        controller.reset();
        // Future.delayed(Duration(seconds: 1),(){});
      });
    } else {
      callback();
    }
  }
}

class PressController {
  Function? _press;

  void bind(Function press) {
    _press = press;
  }

  Future<void> press() async {
    await _press?.call();
  }
}
