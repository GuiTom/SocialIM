import 'package:base/base.dart';

import 'package:flutter/material.dart';
import 'package:base/src/locale/k.dart' as BaseK;
import 'discover_api.dart';
import 'locale/k.dart';
import 'package:flutter/cupertino.dart';

mixin ContextMenuMixin<T extends StatefulWidget> on State<T> {
  void showIOSActionSheet(BuildContext context, Dynamic item,{bool needPopPage = true,Function()? onComplete}) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(K.getTranslation('select_option')),
          actions: [
            if (item.uid.toInt() == Session.uid) //删除
              CupertinoActionSheetAction(
                child: Text(BaseK.K.getTranslation('delete')),
                onPressed: () async {
                  Resp resp = await DiscoverAPI.deleteDynamic(item.id.toInt());
                  if (resp.code == 1) {
                    if (!(context as Element).mounted) {
                      onComplete?.call();
                      return;
                    }
                    Navigator.pop(context, true);
                    if (!(context as Element).mounted) {
                      onComplete?.call();
                      return;
                    }
                    if(needPopPage) {
                      Navigator.pop(context, true);
                    }
                    onComplete?.call();
                  }
                },
              ),
            if (item.uid.toInt() != Session.uid)
              CupertinoActionSheetAction(
                //举报这条内容
                child: Text(K.getTranslation('report_content')),
                onPressed: () async {
                  Navigator.pop(context, true);
                  showReportReasonSheet(context, item);
                },
              ),
            if (item.uid.toInt() != Session.uid)
              CupertinoActionSheetAction(
                //屏蔽这条内容
                child: Text(K.getTranslation('block_this_content')),
                onPressed: () async {
                  Resp resp = await DiscoverAPI.blockDynamic(item.id.toInt());
                  if (resp.code == 1) {
                    ToastUtil.showCenter(msg: resp.message);
                    Session.addDynBlackList(item.id.toInt());
                    if (!(context as Element).mounted) {
                      onComplete?.call();
                      return;
                    }
                    Navigator.pop(context, true);
                    if (!(context as Element).mounted) {
                      onComplete?.call();
                      return;
                    }
                    if(needPopPage) {
                      Navigator.pop(context, true);
                    }
                    onComplete?.call();

                  }
                },
              ),
            if (item.uid.toInt() != Session.uid)
              CupertinoActionSheetAction(
                //拉黑作者
                child: Text(K.getTranslation('block_author')),
                onPressed: () async {
                  Resp resp = await DiscoverAPI.putUserToBlackList(item.uid);
                  if (resp.code == 1) {
                    Session.addUserBlackList(item.uid);
                    ToastUtil.showCenter(msg: resp.message);
                    if (!(context as Element).mounted) {
                      onComplete?.call();
                      return;
                    }
                    Navigator.pop(context, true);
                    if (!(context as Element).mounted) {
                      onComplete?.call();
                      return;
                    }
                    if(needPopPage) {
                      Navigator.pop(context, true);
                    }
                    onComplete?.call();
                  }
                },
              ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(BaseK.K.getTranslation('cancel')),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void showReportReasonSheet(BuildContext context, Dynamic item) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(K.getTranslation('select_option')),
          actions: <Map<String, dynamic>>[
            {'id': 1, 'reason': K.getTranslation('report_reason_1')},
            {'id': 2, 'reason': K.getTranslation('report_reason_2')},
            {'id': 3, 'reason': K.getTranslation('report_reason_3')},
            {'id': 4, 'reason': K.getTranslation('report_reason_4')},
          ]
              .map(
                (e) => CupertinoActionSheetAction(
                  child: Text(e['reason']),
                  onPressed: () async {
                    Resp resp = await DiscoverAPI.reportDynamic(
                        item.id.toInt(), e['id']);
                    if (resp.code == 1) {
                      ToastUtil.showCenter(msg: resp.message);
                      if (!(context as Element).mounted) {
                        return;
                      }
                      Navigator.pop(context, true);
                    }
                  },
                ),
              )
              .toList(),
          cancelButton: CupertinoActionSheetAction(
            child: Text(BaseK.K.getTranslation('cancel')),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
