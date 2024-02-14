class Validator {
  String creatingDataDay(DateTime dateTime) {
    switch (dateTime.month) {
      case 1:
        return '${dateTime.day} янв.';

      case 2:
        return '${dateTime.day} фев.';
      case 3:
        return '${dateTime.day} мар.';
      case 4:
        return '${dateTime.day} апр.';
      case 5:
        return '${dateTime.day} май.';
      case 6:
        return '${dateTime.day} июн.';
      case 7:
        return '${dateTime.day} июл.';
      case 8:
        return '${dateTime.day} авг.';
      case 9:
        return '${dateTime.day} сен.';
      case 10:
        return '${dateTime.day} окт.';
      case 11:
        return '${dateTime.day} ноя.';
      case 12:
        return '${dateTime.day} ноя.';

      default:
        return 'Error';
    }
  }

  String formatTheDateTime(DateTime dateTime) {
    return '${creatingDataDay(dateTime)} - ${dateTime.hour}:${dateTime.minute}';
  }
}
