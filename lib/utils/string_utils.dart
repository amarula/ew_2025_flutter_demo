class StringUtils {
  static String intToTimeLeft(int value) {
    int h;
    int m;
    int s;

    h = value ~/ 3600;
    m = (value - h * 3600) ~/ 60;
    s = value - (h * 3600) - (m * 60);

    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    } else {
      return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
  }
}
