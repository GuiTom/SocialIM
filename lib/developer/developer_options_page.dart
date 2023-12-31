import 'package:base/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeveloperOptionsPage extends StatefulWidget {
  const DeveloperOptionsPage({super.key});

  static Future show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => DeveloperOptionsPage(),
        settings: const RouteSettings(name: '/DeveloperOptionsPage'),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<DeveloperOptionsPage> {
  final List<String> _data = ['服务端环境'];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          alignment: AlignmentDirectional.center,
          height: 300,
          color: Colors.white,
          child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return _buildListItem(index);
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(color: const Color(0x3F111111));
              },
              itemCount: 1),
        ),
      ),
    );
  }

  Widget _buildListItem(int index) {
    return InkWell(
      onTap: () {
        _showModalPageView(index);
      },
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        height: 50,
        color: const Color(0x3F111111),
        margin: const EdgeInsetsDirectional.symmetric(horizontal: 20),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
        child: const Text('服务端环境选择'),
      ),
    );
  }

  Future _showModalPageView(int index) {
    return showDialog(
      context: context, // 上下文对象
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_data[index]),
          content: StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Container(
                height: 200,
                width: 200,
                color: Colors.white,
                child: Center(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          PrefsHelper.setBool(
                              'server_env_is_debug', index == 0);
                          ToastUtil.showCenter(
                              msg: '已经切换为${index == 0 ? "测试环境" : "生产环境"}');
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsetsDirectional.all(3),
                          color: (PrefsHelper.getBool(
                                      'server_env_is_debug', true) ==
                                  (index == 0))
                              ? Colors.green
                              : Colors.grey,
                          height: 30,
                          child: Text(index == 0 ? '测试环境' : '生产环境'),
                        ),
                      );
                    },
                    itemCount: 2,
                  ),
                ),
              );
            },
          ),
          actions: [
           TextButton(onPressed: (){
             Navigator.pop(context);
           }, child: const Center(child: Text('确定'))),
          ],
        );
      },
    );
  }
}
