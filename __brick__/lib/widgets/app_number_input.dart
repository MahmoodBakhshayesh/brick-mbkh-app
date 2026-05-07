import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';

import '../core/theme/app_colors.dart';

class AppDoubleInput extends StatefulWidget {
  final String label;
  final double? max;
  final double value;
  final num steps;
  final void Function(double v) onChange;
  const AppDoubleInput({super.key, required this.label, this.max, required this.value, required this.onChange, this.steps = 1.0});

  @override
  State<AppDoubleInput> createState() => _AppDoubleInputState();
}

class _AppDoubleInputState extends State<AppDoubleInput> {
  @override
  Widget build(BuildContext context) {
      return Container(
        height: 70,
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          const SizedBox(height: 2),
          Text(widget.label),
          Expanded(
            child: InputQty.double(
              steps: widget.steps,
              isIntrinsicWidth: false,
              maxVal: widget.max??double.maxFinite,
              initVal: widget.value,
              onQtyChanged: (a){
                widget.onChange(double.parse(a.toString()));
              },
              decoration: QtyDecorationProps(
                // qtyStyle: QtyStyle0,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                fillColor: Colors.white,
                isCollapsed: false,
                isBordered: false,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
