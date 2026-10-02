// search_textfield_widget.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../themes/app_theme.dart';

class SearchTextFieldWidget extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  final Duration debounceDuration;

  const SearchTextFieldWidget({
    Key? key,
    required this.onSearchChanged,
    this.debounceDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  _SearchTextFieldWidgetState createState() => _SearchTextFieldWidgetState();
}

class _SearchTextFieldWidgetState extends State<SearchTextFieldWidget> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final query = _controller.text;
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(widget.debounceDuration, () {
      widget.onSearchChanged(query.toLowerCase());
    });
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: const TextStyle(color: AppColors.hint, fontSize: 15),
        hintText: context.tr('search_hint'),
        prefixIcon: const Icon(Icons.search, color: AppColors.hint),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  _controller.clear();
                  widget.onSearchChanged('');
                },
                icon: const Icon(Icons.close, color: AppColors.muted),
              ),
        border: border(AppColors.border),
        enabledBorder: border(AppColors.border),
        focusedBorder: border(AppColors.primary, 1.5),
      ),
    );
  }
}
