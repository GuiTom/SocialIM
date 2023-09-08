import 'dart:async';
import '../locale/k.dart';
import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:base/src/locale/k.dart' as BaseK;

typedef OnRecordCompleted = Function(Map recordDetail);

class RecorderOverlay {
  static OverlayEntry? _overlayEntry;
  static GlobalKey<_RecorderVoiceState>? _recorderKey;

  static void show(BuildContext context, OnRecordCompleted onRecordCompleted) {
    if (_overlayEntry != null && _recorderKey != null) {
      return;
    }
    var overlayState = Overlay.of(Constant.context);
    if (overlayState == null) return;

    _recorderKey = GlobalKey();
    _overlayEntry = OverlayEntry(builder: (context) {
      return _RecorderVoiceWidget(
        key: _recorderKey,
        onRecordCompleted: onRecordCompleted,
      );
    });
    overlayState.insert(_overlayEntry!);
    // });
  }

  static void _hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _recorderKey = null;
  }

  static void changeStatus(int status) {
    if (_overlayEntry != null &&
        _recorderKey != null &&
        _recorderKey!.currentState != null) {
      _recorderKey!.currentState!.changeStatus(status);
    }
  }

  static void cancel() async {
    await _recorderKey!.currentState!.cancel();
    await Future.delayed(const Duration(seconds: 2));
    _hide();
  }

  static void finish() async {
    if (_overlayEntry != null && _recorderKey != null) {
      if (_recorderKey!.currentState != null) {
        int res = await _recorderKey!.currentState!.finish();
        if (res < 0) {
          changeStatus(1);
          await Future.delayed(const Duration(seconds: 2));
          _hide();
        } else {
          _hide();
        }
      }
    }
  }
}

class _RecorderVoiceWidget extends StatefulWidget {
  final OnRecordCompleted? onRecordCompleted;

  const _RecorderVoiceWidget({Key? key, this.onRecordCompleted})
      : super(key: key);

  @override
  _RecorderVoiceState createState() => _RecorderVoiceState();
}

class _RecorderVoiceState extends State<_RecorderVoiceWidget> {
  late String _timerText;
  int _status = 0; // 0-正常，1-说话时间太短，2-手指放下可以取消 3.已取消
  bool _recording = false;
  final FlutterSoundRecorder _soundRecorder = FlutterSoundRecorder();
  String _recordingPath = '${Constant.documentsDirectory!.path}/tmp.aac';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timerText = '00:00';
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _startRecord();
    });
  }

  @override
  void dispose() {
    super.dispose();

    if (_recording) {
      _stopRecord();
    }
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withOpacity(0.75)),
          child: Column(
            children: [
              const SizedBox(height: 9),
              Text(
                _status == 0 ? _timerText : '',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 10),
              SvgPicture.asset(
                statusIcon,
                width: 57,
                height: 57,
                package: 'message',
                color: _status == 3 ? Colors.red : Colors.white,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  statusText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  int _startTime = 0;

  void _startRecord() async {
    PermissionStatus status =
        await PermissionUtil.checkAndRequestMicrophonePermission();

    if (status.isDenied) {
      //再次拒绝
      //提示用户去开启权限
      ToastUtil.showCenter(msg: K.getTranslation('mic_rejected_tip'));
      return;
    } else if (status.isPermanentlyDenied) {
      RecorderOverlay.cancel();
      //永久拒绝
      //提示用户去开启权限
      final result = await showOkCancelAlertDialog(
          context: context,
          title: K.getTranslation('mic_priviledge_tip'),
          okLabel: BaseK.K.getTranslation('confirm'),
          cancelLabel: BaseK.K.getTranslation('cancel'),
          style: AdaptiveStyle.iOS);

      return;
    }
    await _soundRecorder.openRecorder();
    _startTime = DateTime.now().millisecondsSinceEpoch;
    _recording = true;

    await _soundRecorder.startRecorder(
        toFile: _recordingPath, codec: Codec.aacADTS);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timerText =
          '${(timer.tick ~/ 60).toString().padLeft(2,'0')}:${(timer.tick % 60).toString().padLeft(2, '0')}';
      setState(() {});
    });
  }

  void _tooShort() {
    //录音时间太短
    changeStatus(1);
  }

  void changeStatus(int status) {
    if (_status == status) return;
    if (!mounted) return;
    setState(() {
      _status = status;
    });
  }

  String get statusText {
    switch (_status) {
      case 0:
        return K.getTranslation('cancel_voice_send');
      case 1:
        return K.getTranslation('duration_too_short');
      case 2:
        return K.getTranslation('release_finger_to_cancel');
      case 3:
        return K.getTranslation('release_finger_to_cancel');
      default:
        return K.getTranslation('voice_canceled');
    }
  }

  String get statusIcon {
    switch (_status) {
      case 0:
        return 'assets/icon_voice_dark.svg';
      case 1:
        return 'assets/icon_record_short.svg';
      case 2:
        return 'assets/icon_record_cancel.svg';
      case 3:
        return 'assets/icon_voice_dark.svg';
      default:
        return 'assets/icon_recording.webp';
    }
  }

  Future<int> _stopRecord() async {
    await _soundRecorder.stopRecorder();
    _recording = false;
    _timer?.cancel();
    int recordTime = DateTime.now().millisecondsSinceEpoch - _startTime;
    print('_stopRecord: $recordTime');
    if (recordTime < 500) {
      _tooShort();
      return -1;
    } else {
      //录音完成
      return recordTime;
    }
  }

  Future<void> cancel() async {
    changeStatus(3);
    await _soundRecorder.stopRecorder();
  }

  Future<int> finish() async {
    int durationInMillSecs = await _stopRecord();
    if (durationInMillSecs > 0) {
      widget.onRecordCompleted!(
          {'filePath': _recordingPath, 'duration': durationInMillSecs});
      return durationInMillSecs;
    }
    return -1;
  }
}
