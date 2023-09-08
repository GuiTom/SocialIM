import 'package:base/base.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:contacts/src/search_mixin.dart';
import 'package:contacts/src/widget/fans_sub_page.dart';
import 'package:contacts/src/widget/focus_sub_page.dart';
import 'package:contacts/src/widget/user_list_page.dart';
import './widget/friends_sub_page.dart';
import 'locale/k.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key, required this.tabIndex});

  final int tabIndex;

  static Future show(BuildContext context, int tabIndex) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => ContactsPage(
          tabIndex: tabIndex,
        ),
        settings: const RouteSettings(name: '/ContactsPage'),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ContactsPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late List<GlobalKey<OnSearchMinxin>> _keys;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: widget.tabIndex);
    _keys = [
      GlobalKey<OnSearchMinxin>(),
      GlobalKey<OnSearchMinxin>(),
      GlobalKey<OnSearchMinxin>()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(K.getTranslation('contacts')),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 8,
            ),
            child: InkWell(
              onTap: () async {
                await UserListPage.show(context);
                _keys[_tabController.index].currentState?.refresh();
              },
              child: const Icon(Icons.add_outlined),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              K.getTranslation('friends'),
              K.getTranslation('fans'),
              K.getTranslation('my_focus')
            ]
                .map((e) => Container(
                      margin: const EdgeInsetsDirectional.symmetric(
                          horizontal: 12, vertical: 20),
                      child: Text(
                        e,
                        style: const TextStyle(
                            color: Color(0xFF313131),
                            fontWeight: FontWeight.bold),
                      ),
                    ))
                .toList(),
          ),
          SearchBar(
            onSearch: (String value) {
              if (value.isEmpty) return;
              _keys[_tabController.index].currentState?.onSearch(value);
            },
            onCancel: () {
              _keys[_tabController.index].currentState?.onSearch("");
            },
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                FriendsSubPage(key: _keys[0]),
                FansSubPage(key: _keys[1]),
                FocusSubpage(key: _keys[2]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
