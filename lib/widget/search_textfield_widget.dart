// search_textfield_widget.dart
import 'package:flutter/material.dart';
import 'dart:async';

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
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        fillColor: Colors.white,
        focusColor: Colors.white,
        hoverColor: Colors.white,
        contentPadding: const EdgeInsets.only(left: 20),
        hintStyle: const TextStyle(
          letterSpacing: 2.0,
          color: Color.fromRGBO(163, 157, 157, 1.0),
        ),
        hintText: 'Search for task',
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.search,
                color: Color.fromRGBO(0, 128, 128, 1),
              ),
            ),
            if (_controller.text.isNotEmpty)
              IconButton(
                onPressed: () {
                  _controller.clear();
                  widget.onSearchChanged('');
                },
                icon: const Icon(
                  Icons.close,
                  color: Color.fromRGBO(0, 128, 128, 1),
                ),
              ),
          ],
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromRGBO(0, 128, 128, 1),
            width: 2.0,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromRGBO(0, 128, 128, 1),
            width: 2.0,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          borderSide: BorderSide(
            color: Color.fromRGBO(0, 128, 128, 1),
            width: 2.0,
          ),
        ),
      ),
    );
  }
}