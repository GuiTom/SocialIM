import 'package:base/base.dart';
import 'package:contacts/src/contacts_page.dart';
import 'package:flutter/material.dart';
class ContactsRouter implements IContactsRouter {
  @override
  Future toContactsPage({required tabIndex}) {
    return ContactsPage.show(
      Constant.context,
      tabIndex,
    );
  }
  @override
  Widget getContactsPage(){
    return const ContactsPage(tabIndex: 0);
  }
}
