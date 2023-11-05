import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({
    super.key,
    required this.searchQuery,
  });

  final Function(String) searchQuery;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    );
    var primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: TextField(
        controller: searchController,
        style: const TextStyle(color: Colors.white),
        cursorColor: primaryColor,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white12,
          contentPadding: EdgeInsets.only(left: 3.w),
          border: outlineInputBorder,
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          hintText: "Search user",
          hintStyle: const TextStyle(color: Colors.white24),
          suffixIcon: Visibility(
            visible: FocusScope.of(context).hasFocus &&
                searchController.text.isNotEmpty,
            child: IconButton(
              onPressed: () {
                searchController.clear();
              },
              icon: const Icon(Icons.clear_rounded),
            ),
          ),
        ),
        onChanged: (value) {
          widget.searchQuery(value);
        },
        onSubmitted: (value) {
          widget.searchQuery(value);
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}
