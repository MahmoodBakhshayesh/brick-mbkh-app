import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../core/extensions/context_extension.dart';
import 'app_text_field.dart';
import 'time_picker/src/board_datetime_options.dart';
import 'time_picker/src/board_datetime_widget.dart';
import 'time_picker/src/utils/board_enum.dart';


class AppDatePicker extends StatefulWidget {
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool readOnly;
  final String? label;
  final TextEditingController? controller;
  final String? Function(String v)? validator;
  final double? fontSize;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool isPassword;
  final ValueChanged<String>? onSubmit;
  final String? placeholder;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Widget? suffix;
  final Widget? suffixIcon;
  final void Function(DateTime? dt) onChanged;
  final bool showClearButton;
  final bool locked;
  final bool required;
  final double height;
  final DateTime? value;
  final DateTime? min;
  final BorderSide? border;
  final DateTime? max;
  final DatePickerEntryMode mode;
  final Color? validationColor;
  final Color? backgroundColor;
  final Color? headerBgColor;
  final Color? bodyBgColor;
  final IconData? validationIcon;
  final List<int> rowLabelRatio;
  final DateFormat? valueFormat;
  final BorderRadius? radius;

  const AppDatePicker({
    super.key,
    this.label,
    this.value,
    this.valueFormat,
    this.bodyBgColor = Colors.white,
    this.headerBgColor,
    this.rowLabelRatio = const [12, 33],
    this.controller,
    this.focusNode,
    this.maxLength,
    this.validationColor,
    this.backgroundColor,
    this.placeholder,
    this.radius = const BorderRadius.all(Radius.circular(8)),
    this.height = 40,
    this.fontSize = 14,
    this.keyboardType,
    this.inputFormatters,
    this.onSubmit,
    this.textCapitalization = TextCapitalization.none,
    this.mode = DatePickerEntryMode.calendar,
    this.textInputAction,
    this.validationIcon,
    this.style,
    this.min,
    this.max,
    this.strutStyle,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.showClearButton = false,
    this.border = BorderSide.none,
    this.locked = false,
    this.required = false,
    this.validator,

    this.prefix,
    this.prefixIcon,
    this.suffixIcon,
    this.suffix,
    required this.onChanged,
    this.autofocus = false,
    this.isPassword = false,
    this.readOnly = false,
  });

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {
  bool obscureText = false;
  TextEditingController? controller;

  @override
  void didUpdateWidget(covariant AppDatePicker oldWidget) {
    if (widget.value != oldWidget.value) {
      controller?.text = widget.value == null ? '' : widget.valueFormat?.format(widget.value!) ?? widget.value?.formatYyMmDdSlash ?? '';
    }

    // setState(() {});

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    if (mounted) {
      if (widget.controller != null) {
        controller = widget.controller;
      } else {
        controller = TextEditingController();
      }
      controller?.text = widget.value == null ? '' : widget.valueFormat?.format(widget.value!) ?? widget.value.formatYyMmDdSlash;
      obscureText = widget.isPassword;
      super.initState();
    }
  }

  @override
  void dispose() {
    // if(mounted) {
    //   widget.controller?.removeListener(() { });
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (context.isDesktop) {
          showDatePicker(context: context, barrierDismissible: false, initialDate: widget.value ?? DateTime.now(), firstDate: widget.min ?? DateTime(1900), lastDate: widget.max ?? DateTime(3000)).then((v) {
            if (v == null) {
              log('v is null just return');
            }else{
              log('v is no null is $v');
            }
            widget.onChanged(v);
            controller?.text = v?.formatYyMmDdSlash ?? '';
          });
        } else {
          showBoardDateTimePicker(
            context: context,
            enableDrag: false,
            showDragHandle: false,
            isDismissible: false,
            initialDate: widget.value ?? DateTime.now(),
            pickerType: DateTimePickerType.date,
            maximumDate: widget.max ?? DateTime(3000),
            minimumDate: widget.min ?? DateTime(1900),
            // headerWidget: MyTextField(),
            options: BoardDateTimeOptions(boardTitle: ((widget.label ?? '').isEmpty) ? '${widget.placeholder}' : widget.label, boardTitleTextStyle: TextStyle(fontSize: 22)),
          ).then((v) {
            final picked = v ?? widget.value;
            widget.onChanged(picked);
            if (picked == null) return;
            controller?.text =
                widget.valueFormat?.format(picked) ?? picked.formatYyMmDdSlash;
          });
        }
        // showDatePicker(
        //   context: context,
        //
        //   firstDate:widget.min?? DateTime(1900),
        //   lastDate:widget.max?? DateTime(3000),
        //   currentDate: widget.value,
        //   initialEntryMode: widget.mode,
        //   keyboardType: const TextInputType.numberWithOptions(signed: true)
        // ).then((v) {
        //
        //   widget.onChanged(v);
        //   if(v == null) return;
        //   controller?.text = v?.formatYyMmDdSlash ?? '';
        // });
      },
      child: AppTextFieldNew(
          headerBgColor: widget.headerBgColor,
          bodyBgColor: widget.bodyBgColor,
          radius: widget.radius,
          disabled: true,
          textAlign: widget.textAlign,
          required: widget.required,
          showError: true,
          label: widget.label,
          rowLabelRatio: widget.rowLabelRatio,
          labelInRow: false,
          height: 70,
          backgroundColor: widget.backgroundColor,
          validationColor: widget.validationColor,
          validationIcon: widget.validationIcon,
          placeholder: widget.placeholder,
          style: const TextStyle(color: Colors.black, height: 1, fontSize: 12),
          validator: widget.validator,
          suffixIcon: widget.suffixIcon ?? SizedBox(height: 22),
          controller: controller,
        ),
    );
    // return SizedBox(
    //   height: widget.height,
    //   child: IntrinsicHeight(
    //     child: Stack(
    //       children: [
    //         TextFormField(
    //           enabled: !widget.locked,
    //           onFieldSubmitted: widget.onSubmit,
    //           inputFormatters: widget.inputFormatters,
    //           maxLength: widget.maxLength,
    //           controller: widget.controller,
    //           focusNode: widget.focusNode,
    //           style: TextStyle(fontSize: widget.fontSize),
    //           obscureText: obscureText,
    //           // onChanged: widget.onChanged,
    //           decoration: InputDecoration(
    //             fillColor: Colors.white,
    //             filled: true,
    //             hintText: widget.placeholder,
    //             prefixIcon: widget.prefixIcon,
    //             prefix: widget.prefix,
    //             suffix: widget.suffix,
    //             hintStyle: const TextStyle(color: Colors.black26, fontSize: 12),
    //             suffixIcon: widget.locked
    //                 ? const Icon(Icons.lock)
    //                 : Row(
    //                     mainAxisSize: MainAxisSize.min,
    //                     children: [
    //                       widget.isPassword
    //                           ? GestureDetector(
    //                               onTap: () {
    //                                 obscureText = !obscureText;
    //                                 setState(() {});
    //                               },
    //                               child: Icon(obscureText ? Ionicons.eye : Ionicons.eye_off, size: 20))
    //                           : const SizedBox(),
    //                       widget.suffixIcon ?? const SizedBox(),
    //                       widget.showClearButton
    //                           ? GestureDetector(
    //                               child: const Icon(Icons.clear),
    //                               onTap: () {
    //                                 widget.controller?.clear();
    //                               },
    //                             )
    //                           : const SizedBox()
    //                     ],
    //                   ),
    //             counterText: '',
    //             label: widget.label == null
    //                 ? null
    //                 : widget.required
    //                     ? Row(
    //                         mainAxisSize: MainAxisSize.min,
    //                         children: [
    //                           Text(widget.label ?? ''),
    //                           const SizedBox(width: 4),
    //                           const Icon(Icons.circle, color: Colors.red, size: 7.5),
    //                         ],
    //                       )
    //                     : Text(widget.label!),
    //             // hintText: widget.label,
    //             errorText: null,
    //             // border: OutlineInputBorder(),
    //             contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    //             border: MaterialStateOutlineInputBorder.resolveWith(
    //               (states) {
    //                 Color borderColor = MyColors.black;
    //                 double borderWidth = 1;
    //                 if (_errorMsg != null) {
    //                   borderColor = MyColors.red;
    //                   borderWidth = 2;
    //                   return OutlineInputBorder(borderSide: BorderSide(color: borderColor, width: borderWidth));
    //                 }
    //                 if (states.isEmpty) return const OutlineInputBorder(borderSide: BorderSide(color: Colors.black26));
    //                 if (states.contains(MaterialState.disabled)) {
    //                   borderColor = MyColors.greyBG;
    //                   borderWidth = 1;
    //                   return OutlineInputBorder(borderSide: BorderSide(color: borderColor, width: borderWidth));
    //                 }
    //                 if (states.contains(MaterialState.error) || _errorMsg != null) {
    //                   borderColor = MyColors.red;
    //                   borderWidth = 2;
    //                   return OutlineInputBorder(borderSide: BorderSide(color: borderColor, width: borderWidth));
    //                 }
    //                 if (states.contains(MaterialState.focused)) {
    //                   borderColor = MyColors.boardingBlue;
    //                   borderWidth = 2;
    //                   return OutlineInputBorder(borderSide: BorderSide(color: borderColor, width: borderWidth));
    //                 }
    //                 if (states.contains(MaterialState.hovered)) {
    //                   borderColor = MyColors.black1;
    //                   borderWidth = 1.5;
    //                   return OutlineInputBorder(borderSide: BorderSide(color: borderColor, width: borderWidth));
    //                 }
    //                 return OutlineInputBorder(borderSide: BorderSide(color: borderColor, width: borderWidth));
    //               },
    //             ),
    //           ),
    //         ),
    //         Align(
    //           alignment: Alignment.bottomRight,
    //           child: Padding(
    //             padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
    //             child: Text(
    //               _errorMsg ?? '',
    //               style: const TextStyle(color: Colors.red, fontSize: 12),
    //             ),
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}

extension DateTimeFormatting on DateTime? {
  String get formatYyMmDd {
    return this == null ? '' : DateFormat('yy-MM-dd').format(this!);
  }

  String get formatYyyyMmDd {
    return this == null ? '' : DateFormat('yyyy-MM-dd').format(this!);
  }

  String get formatYyMmDdSlash {
    return this == null ? '' : DateFormat('dd,MMM yyyy').format(this!);
  }

  String get formatYyMmDdSlashTrim {
    return this == null ? '' : DateFormat('dd,MMMyyyy').format(this!);
  }
}
