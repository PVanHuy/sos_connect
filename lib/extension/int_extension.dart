extension StatusExtension on int {
  int get weekdayToIndex {
    switch (this) {
      case 1:
        return 1; // => Thứ 2
      case 2:
        return 2; // => Thứ 3
      case 3:
        return 3; // => Thứ 4
      case 4:
        return 4; // => Thứ 5
      case 5:
        return 5; // => Thứ 6
      case 6:
        return 6; // => Thứ 7
      case 7:
        return 0; // => Chủ nhật
      default:
        return 0;
    }
  }
}
