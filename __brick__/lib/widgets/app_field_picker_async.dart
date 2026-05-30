import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:developer' as dev;

import '../core/extensions/context_extension.dart';
import 'app_filed_picker_desktop.dart';
import 'app_text_field.dart';
import 'buttons/app_button.dart';
import 'scrollableList/item_positions_listener.dart';
import 'scrollableList/scrollable_positioned_list.dart';

class AppFieldPickerAsync<T> extends StatefulWidget {
  final String Function(T)? itemToString;
  final String Function(T)? valueToString;
  final String Function(T)? searchBuilder;
  final Color Function(T)? itemToColor;
  final Widget Function(T)? itemToWidget;
  final Future<List<T>> Function() itemLoader;
  final List<T> suggestion;
  final ValueChanged<T?>? onChange;
  final T? value;
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
  final bool showPickerForDesktop;
  final TextStyle? style;
  final Color? backgroundColor;
  final Color? headerBgColor;
  final Color? bodyBgColor;
  final double? height;
  final TextStyle? labelStyle;
  final List<int> rowLabelRatio;
  final Widget? suffixIcon;
  final BorderRadius? radius;
  final BoxBorder? borderSide;

  const AppFieldPickerAsync({
    super.key,
    this.itemToString,
    this.valueToString,
    this.searchBuilder,
    this.suffixIcon,
    this.headerBgColor,
    this.bodyBgColor = Colors.white,
    this.height = 70,
    this.radius,
    this.borderSide,
    this.locked = false,
    this.required = false,
    this.labelInRow = false,
    this.showPickerForDesktop = true,
    this.style,
    this.backgroundColor = Colors.white,
    this.itemToColor,
    required this.label,
    this.placeholder,
    required this.itemLoader,
    this.onChange,
    this.suggestion = const [],
    this.labelStyle,
    this.hasSearch = true,
    this.searchAutoFocus = false,
    this.value,
    this.showClearButton = true,
    this.supportNull = true,
    this.itemToWidget,
    this.prefix,
    this.prefixIcon,
    this.rowLabelRatio = const [12, 33],
  });

  @override
  State<AppFieldPickerAsync<T>> createState() => _AppFieldPickerAsyncState<T>();
}

class _AppFieldPickerAsyncState<T> extends State<AppFieldPickerAsync<T>> {
  TextEditingController controller = TextEditingController();
  late ValueNotifier<T?> value = ValueNotifier<T?>(widget.value);
  List<T> items = [];
  bool loading = false;

  @override
  void initState() {
    controller = TextEditingController(text: widget.value?.toString() ?? '');
    value.addListener(() {
      Future(() {
        controller.text = value.value?.toString() ?? '';
        widget.onChange?.call(value.value);
        setState(() {});
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadItems();
    });
    super.initState();
  }

  @override
  void dispose() {
    value.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    setState(() {
      loading = true;
    });
    items = await widget.itemLoader();
    setState(() {
      loading = true;
    });
  }

  @override
  void didUpdateWidget(covariant AppFieldPickerAsync<T> oldWidget) {
    if (widget.value != oldWidget.value && mounted) {
      controller.text = widget.value == null ? '' : widget.valueToString?.call(widget.value as T) ?? widget.value.toString();
      value.value = widget.value;
      setState(() {});
    }
    // controller.dropDownValue =widget.value==null?null: DropDownValueModel(name: widget.value?.toString()??'', value: widget.value, builder: widget.builder);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop) {
      return ValueListenableBuilder<T?>(
        valueListenable: value,
        builder: (context, v, _) {
          return GestureDetector(
            onTap: () async {
              if (loading) {
                return;
              }
              if (widget.showPickerForDesktop) {
                if (!widget.locked) {
                  dev.log('pick item');
                  await _loadItems();
                  if (!context.mounted) return;
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                        // This moves content above the keyboard
                        // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        padding: EdgeInsets.only(top: 0),
                        child: PickerSheetWidget(
                          suggestion: widget.suggestion,
                          value: widget.value,
                          searchAutoFocus: widget.searchAutoFocus,
                          hasClear: widget.showClearButton,
                          searchBuilder: widget.searchBuilder,
                          items: items,
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
                      dev.log('should null value');
                      value.value = null;
                      widget.onChange?.call(null);
                      setState(() {});
                    } else if (v != null) {
                      dev.log(v.toString());
                      value.value = v;
                      setState(() {});
                    }
                  });
                }
                // dev.log("press");
              }
            },
            child: Row(
              children: [
                Expanded(
                  child: AbsorbPointer(
                    absorbing: false,
                    child: Stack(
                      children: [
                        AppFieldPickerDesktop(
                          suggestionColor: Colors.greenAccent,
                          headerBgColor: widget.headerBgColor,
                          bodyBgColor: widget.bodyBgColor,
                          labelInRow: widget.labelInRow,
                          rowLabelRatio: widget.rowLabelRatio,
                          items: items,
                          supportNull: false,
                          absorbing: true,
                          labelStyle: widget.labelStyle,
                          value: widget.value,
                          borderSide: widget.borderSide,
                          valueStyle: widget.style,
                          hasSearch: widget.hasSearch,
                          valueToString: widget.valueToString,
                          showClearButton: widget.showClearButton,
                          // autoFocus: widget.searchAutoFocus,
                          required: widget.required,
                          label: widget.label,
                          height: widget.height ?? 45,
                          radius: widget.radius,
                          itemToWidget: widget.itemToWidget,
                          // builder: widget.itemToWidget,
                          suggestion: widget.suggestion,
                          placeholder: widget.placeholder,
                          onChange: (v) {
                            if (v == Null || v.toString() == 'null') {
                              dev.log('should null value');
                              value.value = null;
                              widget.onChange?.call(null);
                              setState(() {});
                            } else if (v != null) {
                              dev.log(v.toString());
                              value.value = v;
                              // setState(() {});
                            }
                          },
                        ),
                        loading
                            ? SpinKitChasingDots(
                                size: 20,
                                color: context.mainColor,
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
                // if (widget.showClearButton)
                //   Container(
                //     height: widget.height,
                //     decoration: BoxDecoration(
                //       color: Colors.white
                //     ),
                //       padding: EdgeInsets.symmetric(horizontal: 12),
                //       child: DotButton(icon: Icons.clear,))
              ],
            ),
          );
        },
      );
    }

    return ValueListenableBuilder<T?>(
      valueListenable: value,
      builder: (context, v, _) {
        return GestureDetector(
          onTap: widget.locked
              ? null
              : () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                        // This moves content above the keyboard
                        // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        padding: EdgeInsets.only(top: 0),
                        child: PickerSheetWidget(
                          suggestion: widget.suggestion,
                          value: widget.value,
                          searchAutoFocus: widget.searchAutoFocus,
                          hasClear: widget.showClearButton,
                          searchBuilder: widget.searchBuilder,
                          items: items,
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
                      dev.log('should null value');
                      value.value = null;
                      widget.onChange?.call(null);
                      setState(() {});
                    } else if (v != null) {
                      dev.log(v.toString());
                      value.value = v;
                      setState(() {});
                    }
                  });
                },
          child: AppTextFieldNew(
            showError: false,
            style: widget.style,
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
            height: widget.height,
            fontSize: 14,
            placeholder: widget.placeholder,
            // suffixIcon: widget.suffixIcon ?? SizedBox(height: 25, child: Icon(Icons.arrow_drop_down, size: 20)),
            suffixIcon: widget.suffixIcon,
          ),
        );
      },
    );
  }
}

class PickerSheetWidget<T> extends StatefulWidget {
  final List<T> items;
  final List<T> suggestion;
  final String label;
  final bool hasSearch;
  final bool hasClear;
  final bool searchAutoFocus;
  final T? value;
  final Widget? headerWidget;
  final Widget Function(T)? itemToWidget;
  final String Function(T)? searchBuilder;

  const PickerSheetWidget({
    super.key,
    required this.items,
    this.headerWidget,
    required this.suggestion,
    required this.label,
    required this.hasClear,
    this.itemToWidget,
    required this.value,
    required this.searchAutoFocus,
    this.searchBuilder,
    required this.hasSearch,
  });

  @override
  State<PickerSheetWidget<T>> createState() => _PickerSheetWidgetState<T>();
}

class _PickerSheetWidgetState<T> extends State<PickerSheetWidget<T>> {
  final TextEditingController searchC = TextEditingController();
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _positionsListener = ItemPositionsListener.create();
  bool autoPop = false;

  @override
  void initState() {
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
  void didUpdateWidget(covariant PickerSheetWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value || oldWidget.items != widget.items) {
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
  }

  void _scrollToSelected() {
    if (!mounted || widget.value == null) return;

    final items = _filteredSorted(); // <- your filtered list
    final idx = items.indexOf(widget.value as T);
    if (idx < 0) return;

    // Defer until laid out so positions are available
    if (!_itemScrollController.isAttached || _positionsListener.itemPositions.value.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
      return;
    }

    // If everything fits, don't scroll
    if (_listFitsInViewport(items.length)) {
      return;
    }

    // If already fully visible, don't scroll
    if (_isIndexFullyVisible(idx)) {
      return;
    }

    _itemScrollController.scrollTo(index: idx, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut, alignment: 0.1);
  }

  void _scrollToTop() {
    if (!mounted || widget.value == null) return;

    final items = _filteredSorted(); // <- your filtered list
    final idx = 0;
    // Defer until laid out so positions are available
    if (!_itemScrollController.isAttached || _positionsListener.itemPositions.value.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
      return;
    }

    // If everything fits, don't scroll
    if (_listFitsInViewport(items.length)) {
      return;
    }

    // If already fully visible, don't scroll
    if (_isIndexFullyVisible(idx)) {
      return;
    }

    _itemScrollController.scrollTo(index: idx, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut, alignment: 0.1);
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
    if (widget.suggestion.isNotEmpty &&
        items.isEmpty &&
        widget.suggestion.where((a) => searchC.text.toLowerCase().isEmpty || (widget.searchBuilder?.call(a) ?? a.toString()).toLowerCase().split(' ').any((sp) => sp.startsWith(searchC.text.toLowerCase()))).toList().length == 1 &&
        !autoPop) {
      autoPop = true;
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!context.mounted) return;
        Navigator.of(context).pop(widget.suggestion.first);
      });
    }
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    if (widget.hasClear) AppButton(label: 'Clear', reverse: true, color: Colors.blueAccent, onPressed: () => Navigator.of(context).pop(Null)),
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
                  onSubmitted: (a) {
                    if (a.isEmpty && widget.suggestion.isNotEmpty) {
                      Navigator.of(context).pop(widget.suggestion.first);
                    }
                  },
                  prefix: const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.search)),
                ),

              // List
              Column(
                children: widget.suggestion.map((s) {
                  return InkWell(
                    onTap: () => Navigator.of(context).pop(s),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha(8),
                        border: const Border(bottom: BorderSide(color: Colors.white)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(child: widget.itemToWidget?.call(s) ?? Text(s.toString())),
                          Text('Suggestion', style: TextStyle(color: Colors.black45, fontSize: 10)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              Expanded(
                child: ScrollablePositionedList.builder(
                  padding: EdgeInsets.only(bottom: 400),
                  itemScrollController: _itemScrollController,
                  itemPositionsListener: _positionsListener,
                  itemCount: items.length,
                  itemBuilder: (c, i) {
                    final item = items[i];
                    final isSelected = widget.value == item;
                    return InkWell(
                      onTap: () => Navigator.of(context).pop(item),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blueAccent.withValues(alpha: 0.3) : const Color(0xffF2F3F6),
                          border: const Border(bottom: BorderSide(color: Colors.white)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                        child: Row(children: [Expanded(child: widget.itemToWidget?.call(item) ?? Text(item.toString()))]),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
