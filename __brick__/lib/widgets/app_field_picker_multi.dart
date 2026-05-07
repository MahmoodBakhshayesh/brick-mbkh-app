import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import '../core/extensions/context_extension.dart';
import '../core/theme/app_colors.dart';
import 'app_text_field.dart';
import 'buttons/app_button.dart';
import 'scrollableList/item_positions_listener.dart';
import 'scrollableList/scrollable_positioned_list.dart';

class AppMultiFieldPicker<T> extends StatefulWidget {
  final String Function(T)? itemToString;
  final String Function(T)? valueToString;
  final String Function(T)? searchBuilder;
  final Color Function(T)? itemToColor;
  final Widget Function(T)? itemToWidget;
  final List<T> items;
  final List<T> suggestion;
  final ValueChanged<List<T>>? onChange;
  final List<T> values;
  final String? label;
  final String? placeholder;
  final bool showClearButton;
  final bool supportNull;
  final bool locked;
  final Widget? prefix;
  final Widget? prefixIcon;
  final bool hasSearch;
  final bool required;
  final bool labelInRow;
  final bool searchAutoFocus;
  final TextStyle? style;
  final Color? backgroundColor ;
  final Color? headerBgColor;
  final Color? bodyBgColor;
  final TextStyle? labelStyle;
  final List<int> rowLabelRatio;
  final Widget? suffixIcon;

  const AppMultiFieldPicker({
    super.key,
    this.itemToString,
    this.valueToString,
    this.searchBuilder,
    this.suffixIcon,
    this.headerBgColor,
    this.bodyBgColor = Colors.white,
    this.locked = false,
    this.required = false,
    this.labelInRow = false,
    this.style,
    this.backgroundColor,
    this.itemToColor,
    required this.label,
    this.placeholder,
    required this.items,
    this.onChange,
    this.suggestion = const [],
    this.labelStyle,
    this.hasSearch = true,
    this.searchAutoFocus = false,
    required this.values,
    this.showClearButton = true,
    this.supportNull = true,
    this.itemToWidget,
    this.prefix,
    this.prefixIcon,
    this.rowLabelRatio = const [12, 33],
  });

  @override
  State<AppMultiFieldPicker<T>> createState() => _AppMultiFieldPickerState<T>();
}

class _AppMultiFieldPickerState<T> extends State<AppMultiFieldPicker<T>> {
  TextEditingController controller = TextEditingController();
  late ValueNotifier<List<T>> value = ValueNotifier<List<T>>(widget.values);

  @override
  void initState() {
    controller = TextEditingController(text: widget.values.map((a) => a?.toString()).join(", ") ?? '');
    value.addListener(() {
      Future(() {
        controller.text = value.value.map((a)=>a.toString()).join(", ");
        widget.onChange?.call(value.value);
        setState(() {});
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    value.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AppMultiFieldPicker<T> oldWidget) {
    if (widget.values != oldWidget.values && mounted) {
      controller.text = widget.values.map((v) => widget.valueToString?.call(v) ?? v.toString()).join(", ");
      value.value = widget.values;
      setState(() {});
    }
    // controller.dropDownValue =widget.value==null?null: DropDownValueModel(name: widget.value?.toString()??'', value: widget.value, builder: widget.builder);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ValueListenableBuilder<List<T>>(
      valueListenable: value,
      builder: (context, v, _) {
        return GestureDetector(
          onTap: widget.locked
              ? null
              : () {
                  dev.log("pick item");
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                        // This moves content above the keyboard
                        // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        padding: EdgeInsets.only(top: 0),
                        child: MultiPickerSheetWidget(
                          suggestion: widget.suggestion,
                          values: widget.values,
                          searchAutoFocus: widget.searchAutoFocus,
                          hasClear: widget.showClearButton,
                          searchBuilder: widget.searchBuilder,
                          items: widget.items,
                          label: widget.placeholder ?? widget.label ?? '',
                          itemToWidget: widget.itemToWidget,
                          hasSearch: widget.hasSearch,
                        ),
                      );
                      // return PickerSheetWidget(items: widget.items, label: widget.placeholder ?? widget.label ?? '', itemToWidget: widget.itemToWidget, hasSearch: widget.hasSearch);
                    },
                    elevation: 2,
                  ).then((v) {
                    if (v == Null) {
                      dev.log("should null value");
                      value.value = [];
                      widget.onChange?.call([]);
                      setState(() {});
                    } else if (v != null) {
                      dev.log(v.toString());
                      value.value = v;
                      controller.text = v.map((v) => widget.valueToString?.call(v) ?? v.toString()).join(", ");
                      widget.onChange?.call(v);
                      setState(() {});
                    }
                  });
                },
          child: AppTextFieldNew(
            showError: false,
            headerBgColor: widget.headerBgColor,
            bodyBgColor: widget.bodyBgColor,
            disabled: true,
            backgroundColor: widget.backgroundColor,
            labelStyle: widget.labelStyle,
            required: widget.required,
            prefix: widget.prefix,
            prefixIcon: widget.prefixIcon,
            rowLabelRatio: widget.rowLabelRatio,
            labelInRow: widget.labelInRow,
            controller: controller,
            // borderSide: BorderSide(color: Colors.white, width: 1),
            radius: BorderRadius.circular(8),
            label: widget.label,
            fontSize: 14,
            placeholder: widget.placeholder,
            suffixIcon: widget.suffixIcon ?? SizedBox(height: 25, child: Icon(Icons.arrow_drop_down, size: 20)),
          ),
        );
      },
    );
  }
}

class MultiPickerSheetWidget<T> extends StatefulWidget {
  final List<T> items;
  final List<T> suggestion;
  final String label;
  final bool hasSearch;
  final bool hasClear;
  final bool searchAutoFocus;
  final List<T> values;
  final Widget? headerWidget;
  final Widget Function(T)? itemToWidget;
  final String Function(T)? searchBuilder;

  const MultiPickerSheetWidget({
    super.key,
    required this.items,
    this.headerWidget,
    required this.suggestion,
    required this.label,
    required this.hasClear,
    this.itemToWidget,
    required this.values,
    required this.searchAutoFocus,
    this.searchBuilder,
    required this.hasSearch,
  });

  @override
  State<MultiPickerSheetWidget<T>> createState() => _MultiPickerSheetWidgetState<T>();
}

class _MultiPickerSheetWidgetState<T> extends State<MultiPickerSheetWidget<T>> {
  final TextEditingController searchC = TextEditingController();
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _positionsListener = ItemPositionsListener.create();
  bool autoPop = false;
  List<T> selected = [];

  @override
  void initState() {
    selected = [...widget.values];
    super.initState();
    searchC.addListener(() {
      if (searchC.text.isNotEmpty) {
        _scrollToTop();
      }
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  @override
  void didUpdateWidget(covariant MultiPickerSheetWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.values != widget.values || oldWidget.items != widget.items) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
    }
  }

  @override
  void dispose() {
    searchC.dispose();
    super.dispose();
  }

  List<T> _filteredSorted() {
    final query = searchC.text.toLowerCase();
    // dev.log(widget.items.first.toString());
    // dev.log(widget.searchBuilder!(widget.items.first));
    // dev.log((widget.searchBuilder?.call(widget.items.first) ?? widget.items.first.toString()).toLowerCase().indexOf(query).toString());

    final filtered = widget.items.where((a) => query.isEmpty || (widget.searchBuilder?.call(a) ?? a.toString()).toLowerCase().split(' ').any((sp) => sp.startsWith(query))).toList();

    // same sort rule you had: by match position
    if (query.isNotEmpty) {
      filtered.sort((a, b) {
        var comp = (widget.searchBuilder?.call(a) ?? a.toString()).toLowerCase().indexOf(query).compareTo((widget.searchBuilder?.call(b) ?? b.toString()).toLowerCase().indexOf(query));
        if (comp == 0) {
          return (widget.searchBuilder?.call(a) ?? a.toString()).compareTo((widget.searchBuilder?.call(b) ?? b.toString()));
        }
        return comp;
      });
    }
    // dev.log(filtered.first.toString());
    // dev.log(widget.searchBuilder!(filtered.first));
    // dev.log((widget.searchBuilder?.call(filtered.first) ?? filtered.first.toString()).toLowerCase().indexOf(query).toString());
    return filtered.where((a) => !widget.suggestion.contains(a)).toList();
    return filtered;
  }

  void _scrollToSelected() {
    return;
    // if (!mounted || widget.value == null) return;
    //
    // final items = _filteredSorted(); // <- your filtered list
    // final idx = items.indexOf(widget.value as T);
    // if (idx < 0) return;
    //
    // // Defer until laid out so positions are available
    // if (!_itemScrollController.isAttached || _positionsListener.itemPositions.value.isEmpty) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
    //   return;
    // }
    //
    // // If everything fits, don't scroll
    // if (_listFitsInViewport(items.length)) {
    //   return;
    // }
    //
    // // If already fully visible, don't scroll
    // if (_isIndexFullyVisible(idx)) {
    //   return;
    // }
    //
    // _itemScrollController.scrollTo(index: idx, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut, alignment: 0.1);
  }

  void _scrollToTop() {
    // if (!mounted || widget.value == null) return;
    //
    // final items = _filteredSorted(); // <- your filtered list
    // final idx = 0;
    // // Defer until laid out so positions are available
    // if (!_itemScrollController.isAttached || _positionsListener.itemPositions.value.isEmpty) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
    //   return;
    // }
    //
    // // If everything fits, don't scroll
    // if (_listFitsInViewport(items.length)) {
    //   return;
    // }
    //
    // // If already fully visible, don't scroll
    // if (_isIndexFullyVisible(idx)) {
    //   return;
    // }
    //
    // _itemScrollController.scrollTo(index: idx, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut, alignment: 0.1);
  }

  bool _listFitsInViewport(int itemCount) {
    final positions = _positionsListener.itemPositions.value;
    if (positions.isEmpty) return false; // not laid out yet

    // Is the first item fully visible?
    final first = positions.where((p) => p.index == 0).toList();
    // Is the last item fully visible?
    final last = positions.where((p) => p.index == itemCount - 1).toList();

    if (first.isNotEmpty && last.isNotEmpty) {
      final firstFullyVisible = first.any((p) => p.itemLeadingEdge >= 0 && p.itemTrailingEdge <= 1);
      final lastFullyVisible = last.any((p) => p.itemLeadingEdge >= 0 && p.itemTrailingEdge <= 1);
      return firstFullyVisible && lastFullyVisible;
    }
    return false;
  }

  bool _isIndexFullyVisible(int index) {
    final positions = _positionsListener.itemPositions.value;
    if (positions.isEmpty) return false;
    return positions.any((p) => p.index == index && p.itemLeadingEdge >= 0 && p.itemTrailingEdge <= 1);
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredSorted();
    // if (items.length == 1 && !autoPop) {
    //   autoPop = true;
    //   Future.delayed(Duration(milliseconds: 300), () {
    //     Navigator.of(context).pop(items.first);
    //   });
    // }
    // if (widget.suggestion.isNotEmpty &&
    //     items.isEmpty &&
    //     widget.suggestion.where((a) => searchC.text.toLowerCase().isEmpty || (widget.searchBuilder?.call(a) ?? a.toString()).toLowerCase().split(' ').any((sp) => sp.startsWith(searchC.text.toLowerCase()))).toList().length == 1 &&
    //     !autoPop) {
    //   autoPop = true;
    //   Future.delayed(Duration(milliseconds: 300), () {
    //     Navigator.of(context).pop(widget.suggestion.first);
    //   });
    // }
    return SafeArea(
      child: BottomSheet(
        backgroundColor: const Color(0xffEAECF2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        constraints: BoxConstraints(maxHeight: context.height * 0.9),
        onClosing: () {},
        builder: (BuildContext context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                padding: const EdgeInsets.only(left: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text("Pick ${widget.label}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    if (widget.hasClear) AppButton(label: "Clear", reverse: true, color: Colors.blueAccent, onPressed: () => Navigator.of(context).pop(Null)),
                    const CloseButton(),
                  ],
                ),
              ),
              ?widget.headerWidget,
              // Search
              if (widget.hasSearch)
                CupertinoTextField(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  controller: searchC,
                  autofocus: widget.searchAutoFocus,
                  prefix: const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.search)),
                ),

              // List
              Column(
                children: widget.suggestion.map((s) {
                  return InkWell(
                    onTap: () => Navigator.of(context).pop(s),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.mainGreen.withOpacity(0.18),
                        border: const Border(bottom: BorderSide(color: Colors.white)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(child: widget.itemToWidget?.call(s) ?? Text(s.toString())),
                          Text("Suggestion", style: TextStyle(color: Colors.black45, fontSize: 10)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              Expanded(
                child: ListView.builder(
                  // itemScrollController: _itemScrollController,
                  // itemPositionsListener: _positionsListener,
                  itemCount: items.length,
                  itemBuilder: (c, i) {
                    final item = items[i];
                    final isSelected = selected.contains(item);
                    return InkWell(
                      onTap: () {
                        if (isSelected) {
                          selected.remove(item);
                        } else {
                          selected.add(item);
                        }
                        setState(() {});
                        // Navigator.of(context).pop(item);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blueAccent.withOpacity(0.3) : const Color(0xffF2F3F6),
                          border: const Border(bottom: BorderSide(color: Colors.white)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                        child: Row(children: [
                          IgnorePointer(child: SizedBox(
                              width:20,
                              height: 20,
                              child: Checkbox(value: isSelected, onChanged: (v){}))),
                          const SizedBox(width: 8),
                          Expanded(child: widget.itemToWidget?.call(item) ?? Text(item.toString()))]),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      child: AppButton(
                        label: "Cancel",
                        radius: 12,
                        color: AppColors.headlineColor,
                        reverse: true,
                        textColor: Colors.black,
                        borderSide: BorderSide(color: Colors.grey),
                        onPressed: () {
                          Navigator.pop(context, widget.values);
                        },
                      ),
                    ),
                    Expanded(
                      child: AppButton(
                        label: "Confirm",
                        radius: 12,
                        onPressed: () {
                          Navigator.pop(context, selected);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
