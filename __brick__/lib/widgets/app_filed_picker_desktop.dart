import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppFieldPickerDesktop<T> extends ConsumerStatefulWidget {
  // Mapping / data
  final String Function(T)? itemToString;
  final String Function(T)? valueToString;
  final String Function(T)? searchBuilder;
  final Color Function(T)? itemToColor;
  final Widget Function(T)? itemToWidget;
  final List<T> items;
  final List<T> suggestion;
  final ValueChanged<T?>? onChange;
  final T? value;

  // Visuals & layout
  final String? label;
  final String? placeholder;
  final bool required;
  final bool absorbing;
  final List<int> rowLabelRatio;
  final double height;
  final BorderRadius? radius;
  final Color? headerBgColor;
  final Color? bodyBgColor;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? suffixWidth;
  final EdgeInsetsGeometry? valuePadding;
  final BoxBorder? borderSide;

  // Suggestion visuals
  final Color? suggestionColor;

  // Behavior
  final bool hasSearch;
  final bool searchAutoFocus;
  final bool supportNull;
  final bool showClearButton;
  final bool locked;
  final bool disabled;

  // Validation
  final String? Function(String displayText)? validator;
  final Color? validationColor;
  final bool showError;
  final IconData? validationIcon;
  final bool validationMode;
  final bool labelInRow;

  const AppFieldPickerDesktop({
    super.key,
    // mapping
    this.itemToString,
    this.valueToString,
    this.searchBuilder,
    this.itemToColor,
    this.borderSide,
    this.itemToWidget,
    required this.items,
    this.onChange,
    this.labelInRow = true,
    this.absorbing = false,
    this.value,
    this.suggestion = const [],

    // visuals
    required this.label,
    this.placeholder,
    this.rowLabelRatio = const [30, 70],
    this.height = 40,
    this.radius,
    this.headerBgColor,
    this.bodyBgColor,
    this.labelStyle,
    this.valueStyle,
    this.prefix,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixWidth,
    this.valuePadding = const EdgeInsets.symmetric(horizontal: 8),

    // suggestion visuals
    this.suggestionColor,

    // behavior
    this.hasSearch = true,
    this.searchAutoFocus = true,
    this.supportNull = true,
    this.showClearButton = true,
    this.locked = false,
    this.disabled = false,

    // validation
    this.required = false,
    this.validator,
    this.validationColor,
    this.showError = true,
    this.validationIcon,
    this.validationMode = false,
  });

  @override
  ConsumerState<AppFieldPickerDesktop<T>> createState() => _MyFieldPickerStateDesktop<T>();
}

class _MyFieldPickerStateDesktop<T> extends ConsumerState<AppFieldPickerDesktop<T>> {
  // constants
  static const double _kMenuHeight = 300;
  static const double _kItemExtent = 40;
  static const double _kGap = 4;
  static const double _kMenuRadius = 8;

  // selected value & display
  late final ValueNotifier<T?> _value = ValueNotifier<T?>(widget.value);

  // search state
  final _searchCtrl = TextEditingController();
  final _searchFocus = FocusNode();
  final GlobalKey _searchFieldKey = GlobalKey();

  // when hasSearch == false, this node gets keyboard events
  final _overlayFocus = FocusNode(debugLabel: 'PickerOverlayFocus');

  // list scroll
  final _listScroll = ScrollController();

  // anchoring
  final _link = LayerLink();
  final _valueBoxKey = GlobalKey(); // anchor to the right box (value area)
  Size _valueBoxSize = Size.zero;

  // overlay
  OverlayEntry? _entry;
  bool _open = false;

  // data
  int _highlight = -1;
  late List<T> _filtered = List<T>.from(widget.items);

  // helpers
  String _itemToText(T item) => widget.itemToString?.call(item) ?? item.toString();

  String _valueToText(T? v) => v == null ? '' : (widget.valueToString?.call(v as T) ?? _itemToText(v as T));

  String _itemToSearchText(T item) => widget.searchBuilder?.call(item) ?? _itemToText(item);

  @override
  void initState() {
    super.initState();
    _value.addListener(() {
      widget.onChange?.call(_value.value);
      if (mounted) setState(() {}); // refresh displayed text + validation box
      _rebuildOverlay();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureValueBox());
  }

  @override
  void didUpdateWidget(covariant AppFieldPickerDesktop<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _value.value = widget.value;
    }
    _applyFilter(_searchCtrl.text);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureValueBox());
  }

  @override
  void dispose() {
    _value.dispose();
    _searchCtrl.dispose();
    _searchFocus.dispose();
    _overlayFocus.dispose();
    _listScroll.dispose();
    _closeOverlay();
    super.dispose();
  }

  void _measureValueBox() {
    final ctx = _valueBoxKey.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    setState(() => _valueBoxSize = box.size);
  }

  // === helper: partition filtered items into suggestions and the rest ===
  List<T> _getSuggestionItems() {
    if (widget.suggestion.isEmpty || _filtered.isEmpty) {
      return <T>[];
    }
    final sugSet = widget.suggestion.toSet();
    return _filtered.where((e) => sugSet.contains(e)).toList();
  }

  List<T> _getNonSuggestionItems() {
    if (_filtered.isEmpty) return <T>[];
    if (widget.suggestion.isEmpty) return List<T>.from(_filtered);
    final sugSet = widget.suggestion.toSet();
    return _filtered.where((e) => !sugSet.contains(e)).toList();
  }

  // === highlight current value according to ordering (None + suggestions + rest) ===
  void _updateHighlightFromValue() {
    final suggestionItems = _getSuggestionItems();
    final otherItems = _getNonSuggestionItems();
    final hasNullRow = widget.supportNull;

    // no items at all
    if (suggestionItems.isEmpty && otherItems.isEmpty) {
      _highlight = -1;
      return;
    }

    // no value selected
    if (_value.value == null) {
      _highlight = hasNullRow ? 0 : -1;
      return;
    }

    final current = _value.value;

    int rowIndex = -1;

    // suggestion section
    final sugIdx = suggestionItems.indexWhere((e) => e == current);
    if (sugIdx != -1) {
      rowIndex = (hasNullRow ? 1 : 0) + sugIdx;
    } else {
      // normal section
      final otherIdx = otherItems.indexWhere((e) => e == current);
      if (otherIdx != -1) {
        rowIndex = (hasNullRow ? 1 : 0) + suggestionItems.length + otherIdx;
      }
    }

    if (rowIndex == -1) {
      // fallback
      _highlight = hasNullRow ? 0 : 0;
    } else {
      _highlight = rowIndex;
    }
  }

  // overlay open/close
  void _toggleOverlay() => _open ? _closeOverlay() : _openOverlay();

  void _openOverlay() {
    // if(widget.absorbing){
    //   return;
    // }
    if (_open || widget.locked || widget.disabled) return;
    _open = true;

    _entry = OverlayEntry(
      builder: (_) {
        return Stack(
          children: [
            // dim + click-away
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _closeOverlay,
                child: Container(color: Colors.black.withOpacity(0.12)),
              ),
            ),
            // anchored menu below the value box
            CompositedTransformFollower(
              link: _link,
              showWhenUnlinked: false,
              targetAnchor: Alignment.bottomLeft,
              followerAnchor: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: _kGap),
                child: Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(_kMenuRadius),
                  clipBehavior: Clip.antiAlias,
                  color: widget.bodyBgColor ?? Theme.of(context).cardColor,
                  child: SizedBox(
                    width: _valueBoxSize.width,
                    height: _kMenuHeight,
                    child: FocusTraversalGroup(child: _buildMenu()),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);

    // keep cached search & filter
    _applyFilter(_searchCtrl.text);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();

      if (_filtered.isNotEmpty) {
        setState(() {
          _updateHighlightFromValue();
        });
        _ensureHighlightedVisible();
      }

      // Focus handling (with/without search)
      if (widget.hasSearch && widget.searchAutoFocus) {
        final ctx = _searchFieldKey.currentContext;
        if (ctx != null) {
          FocusScope.of(ctx).requestFocus(_searchFocus);
        } else {
          _searchFocus.requestFocus();
        }
        _searchCtrl.selection = TextSelection.fromPosition(TextPosition(offset: _searchCtrl.text.length));
      } else {
        _overlayFocus.requestFocus(); // ensure keyboard works without search
      }

      _rebuildOverlay();
    });
  }

  void _closeOverlay() {
    if (!_open) return;

    // Clear search on close
    _searchCtrl.clear();
    _applyFilter('');

    _entry?.remove();
    _entry = null;
    _open = false;
    if (mounted) setState(() {});
  }

  void _rebuildOverlay() => _entry?.markNeedsBuild();

  // menu ui
  Widget _buildMenu() => Container(
    color: Colors.white,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.hasSearch) _buildSearchBar(),
        const Divider(height: 1),
        Expanded(child: _buildListWithFocus()),
      ],
    ),
  );

  Widget _buildSearchBar() => Focus(
    onKeyEvent: (_, e) => _handleKeys(e),
    child: Container(
      height: widget.height,
      color: widget.headerBgColor ?? Theme.of(context).colorScheme.surfaceVariant,
      child: TextField(
        key: _searchFieldKey,
        focusNode: _searchFocus,
        controller: _searchCtrl,
        autofocus: widget.searchAutoFocus,
        onChanged: _applyFilter,
        decoration: InputDecoration(
          hintText: 'Search…',
          prefixIcon: const Icon(Icons.search),
          // suffix: IconButton(
          //   tooltip: 'Clear search',
          //   icon: const Icon(Icons.clear),
          //   onPressed: () {
          //     _searchCtrl.clear();
          //     _applyFilter('');
          //     final ctx = _searchFieldKey.currentContext;
          //     if (ctx != null) {
          //       FocusScope.of(ctx).requestFocus(_searchFocus);
          //     } else {
          //       _searchFocus.requestFocus();
          //     }
          //   },
          // ),
          isDense: true,
          border: const OutlineInputBorder(),
        ),
      ),
    ),
  );

  // (kept for compatibility; not used in menu anymore)
  Widget _buildSuggestionStrip() => Container(
    width: double.infinity,
    color: (widget.headerBgColor ?? Theme.of(context).colorScheme.surface).withOpacity(0.7),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    child: Wrap(
      spacing: 6,
      runSpacing: 6,
      children: widget.suggestion
          .map(
            (sug) => ActionChip(
              label: Text(_itemToText(sug), overflow: TextOverflow.ellipsis),
              onPressed: () => _selectValue(sug),
            ),
          )
          .toList(),
    ),
  );

  // Wrap the list with a Focus when search is disabled so it receives key events.
  Widget _buildListWithFocus() {
    if (widget.hasSearch) return _buildList();
    return Focus(
      focusNode: _overlayFocus,
      autofocus: true,
      onKeyEvent: (_, e) => _handleKeys(e),
      child: _buildList(),
    );
  }

  Widget _buildList() {
    final suggestionItems = _getSuggestionItems();
    final otherItems = _getNonSuggestionItems();

    final bool hasNullRow = widget.supportNull;
    final int totalCount = (hasNullRow ? 1 : 0) + suggestionItems.length + otherItems.length;

    if (totalCount == 0) {
      return const Center(child: Text('No results'));
    }


    return Scrollbar(
      controller: _listScroll,
      child: ListView.builder(
        controller: _listScroll,
        padding: EdgeInsets.zero,
        itemExtent: _kItemExtent,
        itemCount: totalCount,
        itemBuilder: (context, idx) {
          // 1) Optional "None" row
          if (hasNullRow && idx == 0) {
            final selected = _value.value == null;
            final hover = _highlight == 0;
            return InkWell(
              onTap: () => _selectValue(null),
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                color: hover ? Theme.of(context).colorScheme.primary.withOpacity(0.08) : null,
                child: const Text('— None —'),
              ),
            );
          }

          // convert idx to section index (suggestions / others)
          int displayIdx = idx;
          if (hasNullRow) displayIdx -= 1;

          final bool inSuggestions = displayIdx < suggestionItems.length;
          final T item = inSuggestions ? suggestionItems[displayIdx] : otherItems[displayIdx - suggestionItems.length];

          final bool hover = _highlight == idx;
          final Color? customColor = widget.itemToColor?.call(item);

          Color? rowColor;
          if (inSuggestions) {
            final base = widget.suggestionColor ?? Theme.of(context).colorScheme.primary;
            rowColor = customColor ?? base.withOpacity(hover ? 0.20 : 0.10);
          } else {
            rowColor = customColor ?? (hover ? Theme.of(context).colorScheme.primary.withOpacity(0.08) : null);
          }

          return InkWell(
            onTap: () => _selectValue(item),
            onHover: (hov) {
              if (hov) setState(() => _highlight = idx);
              _rebuildOverlay();
            },
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              color: rowColor,
              child:
                  widget.itemToWidget?.call(item) ??
                  Text(
                    _itemToText(item),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
            ),
          );
        },
      ),
    );
  }

  // filter / keys / selection
  void _applyFilter(String q) {
    final query = q.trim().toLowerCase();
    if (query.isEmpty) {
      _filtered = List<T>.from(widget.items);
    } else {
      final filter = (String qq, T item) => _itemToSearchText(item).toLowerCase().contains(qq);
      _filtered = widget.items.where((e) => filter(query, e)).toList();
    }

    if (mounted) {
      setState(() {
        _updateHighlightFromValue();
      });
    }
    _rebuildOverlay();
    _ensureHighlightedVisible();
  }

  KeyEventResult _handleKeys(KeyEvent e) {
    if (e is! KeyDownEvent) return KeyEventResult.ignored;
    final k = e.logicalKey;

    if (k == LogicalKeyboardKey.tab) {
      if (_filtered.isNotEmpty) {
        setState(() => _updateHighlightFromValue());
        _ensureHighlightedVisible();
        _rebuildOverlay();
      }
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowDown) {
      _moveHighlight(1);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowUp) {
      _moveHighlight(-1);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.pageDown) {
      _moveHighlight(8);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.pageUp) {
      _moveHighlight(-8);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.home) {
      _jumpHighlight(false);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.end) {
      _jumpHighlight(true);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.enter || k == LogicalKeyboardKey.numpadEnter) {
      _pickHighlighted();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.escape) {
      _closeOverlay();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.f4) {
      _toggleOverlay();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _moveHighlight(int delta) {
    final suggestionItems = _getSuggestionItems();
    final otherItems = _getNonSuggestionItems();
    final max = (widget.supportNull ? 1 : 0) + suggestionItems.length + otherItems.length - 1;
    if (max < 0) return;
    setState(() {
      if (_highlight < 0) {
        _highlight = widget.supportNull ? 0 : 0;
      } else {
        _highlight = (_highlight + delta).clamp(0, max);
      }
    });
    _ensureHighlightedVisible();
    _rebuildOverlay();
  }

  void _jumpHighlight(bool toEnd) {
    final suggestionItems = _getSuggestionItems();
    final otherItems = _getNonSuggestionItems();
    final max = (widget.supportNull ? 1 : 0) + suggestionItems.length + otherItems.length - 1;
    if (max < 0) return;
    setState(() => _highlight = toEnd ? max : 0);
    _ensureHighlightedVisible();
    _rebuildOverlay();
  }

  void _ensureHighlightedVisible() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // SAFETY: must still be mounted, overlay open, and attached to list
      if (!mounted || !_open || !_listScroll.hasClients) return;
      try {
        final targetTop = (_highlight < 0 ? 0 : _highlight) * _kItemExtent;
        final pos = _listScroll.position;
        final viewStart = pos.pixels;
        final viewEnd = pos.pixels + pos.viewportDimension;
        if (targetTop < viewStart) {
          _listScroll.jumpTo(targetTop);
        } else if (targetTop + _kItemExtent > viewEnd) {
          _listScroll.jumpTo(targetTop - pos.viewportDimension + _kItemExtent);
        }
      } catch (_) {
        /* race safe */
      }
    });
  }

  void _pickHighlighted() {
    final suggestionItems = _getSuggestionItems();
    final otherItems = _getNonSuggestionItems();
    final hasNullRow = widget.supportNull;

    // if nothing is highlighted, current value is null, and exactly 1 suggestion -> pick it
    if (_highlight < 0) {
      if (_value.value == null && suggestionItems.length == 1) {
        _selectValue(suggestionItems.first);
      }
      return;
    }

    int idx = _highlight;

    // "None" row
    if (hasNullRow && idx == 0) {
      _selectValue(null);
      return;
    }

    if (hasNullRow) idx -= 1;

    if (idx < suggestionItems.length) {
      _selectValue(suggestionItems[idx]);
      return;
    }

    final restIdx = idx - suggestionItems.length;
    if (restIdx >= 0 && restIdx < otherItems.length) {
      _selectValue(otherItems[restIdx]);
    }
  }

  void _selectValue(T? v) {
    _value.value = v;
    _closeOverlay();
  }

  // ---- CUSTOM BOX RENDER (label + value) ----
  @override
  Widget build(BuildContext context) {
    final displayText = _valueToText(_value.value);
    final valMsg = widget.validator?.call(displayText) ?? '';


    // bool validationMode = ref.watch(globalFormValidationMode) && widget.required && displayText.isEmpty;
    bool validationMode = false;

    BoxBorder? boxBorder = validationMode ? BoxBorder.all(color: Colors.red) : BoxBorder.all(color: Colors.transparent);

    final Color vColor = widget.validationColor ?? Colors.red;

    final InputBorder? border = widget.validationMode && valMsg.isNotEmpty
        ? OutlineInputBorder(
            borderSide: BorderSide(color: vColor),
            borderRadius: widget.radius ?? BorderRadius.circular(8),
          )
        : InputBorder.none;

    // left label cell
    final labelCell = Container(
      height: widget.height,
      // color: widget.headerBgColor,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.label ?? '',
            style: widget.labelStyle ?? const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
          if (widget.required)
            const Padding(
              padding: EdgeInsets.only(bottom: 4.0, left: 3),
              child: Icon(Icons.star_rate_rounded, color: Colors.red, size: 10),
            ),
        ],
      ),
    );
    final labelCellColumn = Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      color: widget.headerBgColor,

      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.label ?? '',
            style: widget.labelStyle ?? const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
          if (widget.required)
            const Padding(
              padding: EdgeInsets.only(bottom: 4.0, left: 3),
              child: Icon(Icons.star_rate_rounded, color: Colors.red, size: 10),
            ),
        ],
      ),
    );
    double h = (widget.height) - (widget.labelInRow ? 0 : 15);
    // right value cell (clickable) — anchor overlay here
    final valueCell = CompositedTransformTarget(
      key: _valueBoxKey,
      link: _link,
      child: InkWell(
        onTap:widget.absorbing ?null: (widget.locked || widget.disabled) ? null : _toggleOverlay,
        child: Container(
          decoration: BoxDecoration(
            border: boxBorder,

            borderRadius: BorderRadius.circular(5),
          ),
          height: h,
          alignment: Alignment.center,
          padding: widget.valuePadding,
          child: InputDecorator(
            decoration: InputDecoration(
              isDense: true,
              border: border,
              enabledBorder: border,
              disabledBorder: border,
              prefixIcon: widget.prefixIcon,
              suffixIconConstraints: BoxConstraints(
                maxWidth: widget.suffixWidth ?? 200,
                // maxHeight: widget.height,
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  (widget.showClearButton && _value.value != null && !widget.locked && !widget.disabled)
                      ? GestureDetector(
                          // tooltip: 'Clear',
                          child: const Icon(Icons.close),
                          onTap: () {

                            // log("should clear");
                            widget.onChange?.call(null);
                            _selectValue(null);
                          },
                        )
                      : widget.suffixIcon ?? Icon(_open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                ],
              ),
            ),
            child: IgnorePointer(
              ignoring: true,
              child: Container(
                alignment: Alignment.centerLeft,
                // height: widget.height,
                child: Row(
                  children: [
                    if (widget.prefix != null) widget.prefix!,
                    if (widget.prefixIcon != null) const SizedBox(width: 6),
                    Expanded(
                      // FIX: use _value.value instead of widget.value
                      child: (_value.value != null && widget.valueToString != null)
                          ? Text(
                              displayText,
                              overflow: TextOverflow.ellipsis,
                              style: widget.valueStyle,
                            )
                          : _value.value != null && (widget.itemToWidget != null)
                          ? widget.itemToWidget!(_value.value as T)
                          : Text(
                              displayText.isEmpty ? (widget.placeholder ?? '') : displayText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  (displayText.isEmpty
                                          ? (widget.valueStyle ?? const TextStyle(fontSize: 13, color: Colors.black54)).copyWith(color: Colors.black45)
                                          : widget.valueStyle ?? const TextStyle(fontSize: 13, color: Colors.black))
                                      .copyWith(height: 1.1),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // optional validation bubble (right side), shown only when showError && hasError
    final validationBubble = (widget.showError && valMsg.isNotEmpty)
        ? Container(
            // height: widget.height,
            margin: const EdgeInsets.only(left: 12),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: vColor),
              color: vColor.withOpacity(0.06),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.validationIcon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(widget.validationIcon, color: vColor, size: 18),
                  ),
                Text(
                  valMsg,
                  style: TextStyle(color: vColor, fontSize: 10, height: 1),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        : const SizedBox.shrink();

    final labelFlex = widget.rowLabelRatio.isNotEmpty ? widget.rowLabelRatio[0] : 12;
    final valueFlex = (widget.rowLabelRatio.length > 1 ? widget.rowLabelRatio[1] : 33);

    return ClipRRect(
      borderRadius: widget.radius ?? BorderRadius.circular(5),
      child: Container(
        // height: widget.height,
        alignment: Alignment.center,
        child: widget.labelInRow
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: labelFlex,
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.headerBgColor,
                        borderRadius: widget.headerBgColor == null ? widget.radius : BorderRadius.vertical(top: widget.radius?.bottomLeft ?? Radius.circular(0)),
                      ),
                      child: labelCell,
                    ),
                  ),
                  Expanded(
                    flex: valueFlex,
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.bodyBgColor,
                        border: widget.borderSide,
                        borderRadius: widget.headerBgColor == null ? widget.radius : BorderRadius.vertical(bottom: widget.radius?.bottomLeft ?? Radius.circular(0)),
                      ),
                      child: Row(
                        children: [
                          Expanded(child: valueCell),
                          validationBubble,
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Container(
          color: Colors.black12,
                // height: widget.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: widget.headerBgColor,
                        borderRadius: widget.headerBgColor == null ? widget.radius : BorderRadius.vertical(top: widget.radius?.bottomLeft ?? Radius.circular(0)),
                      ),
                      child: Row(
                        children: [
                          labelCellColumn,
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.bodyBgColor,
                          border: widget.borderSide,
                          borderRadius: widget.headerBgColor == null ? widget.radius : BorderRadius.vertical(bottom: widget.radius?.bottomLeft ?? Radius.circular(0)),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: valueCell),
                            validationBubble,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
