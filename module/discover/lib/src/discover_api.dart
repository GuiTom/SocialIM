import 'package:base/base.dart';

enum LikeTargetType {
  dynamic,
  comment,
}

class DiscoverAPI {
  //发布动态
  static submitDynamic(String content, List<String> picturePaths) async {
    Resp resp = await Net.uploadMultiFile(
        url: System.api('/api/discover/submitDynamic'),
        pb: true,
        params: {
          'uid': Session.uid,
          'nickName': Session.userInfo.name,
          'content': content,
        },
        filePaths: picturePaths,
        pbMsg: Resp.create());
    if (resp.code != 1) {
      ToastUtil.showCenter(msg: resp.message);
    }
    return resp;
  }

  //删除动态
  static deleteDynamic(int dynamicId) async {
    Resp resp = await Net.post(
        url: System.api('/api/discover/deleteDynamic'),
        pb: true,
        params: {
          'dynamicId': dynamicId,
          'uid': Session.uid,
        },
        pbMsg: Resp.create());
    if (resp.code != 1) {
      ToastUtil.showCenter(msg: resp.message);
    }
    return resp;
  }

  //举报这条内容
  static reportDynamic(int dynamicId, int reasonId) async {
    Resp resp = await Net.post(
        url: System.api('/api/discover/report'),
        pb: true,
        params: {
          'targetId': dynamicId,
          'targetType': 1,
          'reasonId': reasonId,
          'uid': Session.uid,
        },
        pbMsg: Resp.create());
    if (resp.code != 1) {
      ToastUtil.showCenter(msg: resp.message);
    }
    return resp;
  }

  //隐藏动态内容
  static blockDynamic(int dynamicId) async {
    Resp resp = await Net.post(
        url: System.api('/api/discover/putDynToBlackList'),
        pb: true,
        params: {
          'dynamicId': dynamicId,
          'uid': Session.uid,
        },
        pbMsg: Resp.create());
    if (resp.code != 1) {
      ToastUtil.showCenter(msg: resp.message);
    }
    return resp;
  }

  //拉黑某人
  static putUserToBlackList(int otherUid) async {
    Resp resp = await Net.post(
        url: System.api('/api/user/putUserToBlackList'),
        pb: true,
        params: {
          'otherUid': otherUid,
          'uid': Session.uid,
        },
        pbMsg: Resp.create());
    if (resp.code != 1) {
      ToastUtil.showCenter(msg: resp.message);
    }
    return resp;
  }

  //拉取动态列表
  static Future<DynamicListResp> getDynamicList(int pageNo, int pageSize,
      [int uid = 0]) async {
    DynamicListResp resp = await Net.post(
        url: System.api('/api/discover/dynamicList'),
        pb: true,
        params: {
          'pageNo': pageNo,
          'pageSize': pageSize,
          'uid': uid,
        },
        pbMsg: DynamicListResp.create());
    if (resp.code != 1) {
      ToastUtil.showCenter(msg: resp.message);
    }
    return resp;
  }

  //提交评论
  static Future<SubmitCommentResp> submitComment(int dynamicId, String content,
      [int targetCommentId = 0]) async {
    SubmitCommentResp resp = await Net.post(
        url: System.api('/api/discover/comment/submitComment'),
        pb: true,
        params: {
          'dynamicId': dynamicId,
          'uid': Session.uid,
          'targetCommentId': targetCommentId,
          'name': Session.userInfo.name,
          'content': content,
        },
        pbMsg: SubmitCommentResp.create());
    if (resp.code != 1) {
      ToastUtil.showCenter(msg: resp.message);
    }
    return resp;
  }

  //提交评论
  static Future<SubmitCommentResp> submitCommentReply(
      int dynamicId, String content, replyTargetName) async {
    SubmitCommentResp resp = await Net.post(
        url: System.api('/api/discover/comment/submitComment'),
        pb: true,
        params: {
          'dynamicId': dynamicId,
          'uid': Session.uid,
          'name': Session.userInfo.name,
          'replyTargetName': replyTargetName,
          'content': content,
        },
        pbMsg: SubmitCommentResp.create());
    if (resp.code != 1) {
      ToastUtil.showCenter(msg: resp.message);
    }
    return resp;
  }

  //删除评论
  static deleteComment(int commentId) async {
    Resp resp = await Net.post(
        url: System.api('/api/discover/comment/deleteComment'),
        pb: true,
        params: {
          'commentId': commentId,
        },
        pbMsg: Resp.create());
    if (resp.code != 1) {
      ToastUtil.showCenter(msg: resp.message);
    }
    return resp;
  }

  //拉取评论列表
  static getCommentList(int dynamicId, int pageNo, int pageSize) async {
    CommentListResp resp = await Net.post(
        url: System.api('/api/discover/comment/commentList'),
        pb: true,
        params: {
          'dynamicId': dynamicId,
          'pageNo': pageNo,
          'pageSize': pageSize,
        },
        pbMsg: CommentListResp.create());
    if (resp.code != 1) {
      ToastUtil.showCenter(msg: resp.message);
    }
    return resp;
  }

  //动态点赞
  static dynamicAddLike(int dynamicId) async {
    Resp resp = await Net.post(
        url: System.api('/api/discover/addLike'),
        pb: true,
        params: {
          'dynamicId': dynamicId,
          'uid': Session.uid,
          'name': Session.userInfo.name,
        },
        pbMsg: Resp.create());
    if (resp.code != 1) {
      ToastUtil.showCenter(msg: resp.message);
    }
    return resp;
  }

  //动态取消点赞
  static dynamicCancelLike(int dynamicId) async {
    Resp resp = await Net.post(
        url: System.api('/api/discover/cancelLike'),
        pb: true,
        params: {
          'dynamicId': dynamicId,
          'uid': Session.uid,
        },
        pbMsg: Resp.create());
    if (resp.code != 1) {
      ToastUtil.showCenter(msg: resp.message);
    }
    return resp;
  }

  //评论点赞
  static commentAddLike(int commentId) async {
    Resp resp = await Net.post(
        url: System.api('/api/discover/comment/addLike'),
        pb: true,
        params: {
          'commentId': commentId,
          'uid': Session.uid,
          'name': Session.userInfo.name,
        },
        pbMsg: Resp.create());
    if (resp.code != 1) {
      ToastUtil.showCenter(msg: resp.message);
    }
    return resp;
  }

  //评论取消点赞
  static commentCancelLike(int commentId) async {
    Resp resp = await Net.post(
        url: System.api('/api/discover/comment/cancelLike'),
        pb: true,
        params: {
          'commentId': commentId,
          'uid': Session.uid,
        },
        pbMsg: Resp.create());
    if (resp.code != 1) {
      ToastUtil.showCenter(msg: resp.message);
    }
    return resp;
  }

  static Future<DynamicListResp> getDynamicBlackList() async {
    String url = System.api('/api/discover/getDynBlackList');
    Map<String, dynamic> params = {'uid': Session.uid};
    DynamicListResp resp = await Net.post(
        url: url, pb: true, params: params, pbMsg: DynamicListResp.create());
    return resp;
  }

  static Future<Resp> removeUserFromBlackList(int dynamicId) async {
    String url = System.api('/api/discover/pullDynOutOfBlackList');
    Map<String, dynamic> params = {'uid': Session.uid, 'dynamicId': dynamicId};
    Resp resp = await Net.post(
        url: url, pb: true, params: params, pbMsg: Resp.create());
    return resp;
  }
}
