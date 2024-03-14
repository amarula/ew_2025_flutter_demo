// Dart imports:
import 'dart:async';

// Project imports:
import 'package:ew_flutter_demo/utils/string_utils.dart';

class BoostService {
  bool boosting = false;
  int boostDurationSec = 10;

  late int _boostRemainingSec = 0;
  late Timer _boostTimer;

  final void Function() onBoostFinished;

  BoostService({required this.onBoostFinished});

  String boostRemaining() {
    return StringUtils.intToTimeLeft(_boostRemainingSec);
  }

  void start() {
    boosting = true;
    _boostRemainingSec = boostDurationSec;
    _boostTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_boostRemainingSec == 0) {
        boosting = false;
        onBoostFinished();
        _boostTimer.cancel();
      } else {
        _boostRemainingSec--;
      }
    });
  }

  void stop() {
    if (!_boostTimer.isActive) {
      return;
    }

    boosting = false;
    _boostRemainingSec = 0;
    onBoostFinished();
    _boostTimer.cancel();
  }
}
