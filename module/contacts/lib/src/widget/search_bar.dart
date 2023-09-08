import 'package:flutter/material.dart';
import '../locale/k.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key, required this.onSearch, this.hintText});

  final String? hintText;
  final void Function(String) onSearch;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                textAlignVertical: TextAlignVertical.bottom,
                onSubmitted: (String value) {
                  widget.onSearch.call(_searchController.text);
                },
                onChanged: (String value) {
                  widget.onSearch.call(_searchController.text);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  //去掉输入框的下滑线
                  fillColor: const Color(0xFFE1E1E1),
                  filled: true,
                  hintText: widget.hintText??K.getTranslation('search_hint'),
                  hintStyle:
                      const TextStyle(color: Colors.grey, fontSize: 14.0),
                  contentPadding: const EdgeInsets.all(12.0),
                  enabledBorder: null,
                  disabledBorder: null,
                  alignLabelWithHint: true,
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      widget.onSearch.call(_searchController.text);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
