import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter(this.dateTime);
  final dateTime;

  String format() {
    DateTime now = DateTime.now();
    DateTime justNow = DateTime.now().subtract(Duration(minutes: 1));
    DateTime localDateTime = dateTime.toLocal();

    if (now.difference(localDateTime).inDays > 6) {
      return "Older";
    }
    if (!localDateTime.difference(justNow).isNegative) {
      return 'Just now';
    }

    if (localDateTime.day == now.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return 'Today';
    }
    DateTime yesterday = now.subtract(Duration(days: 1));
    if (localDateTime.day == yesterday.day &&
        localDateTime.month == yesterday.month &&
        localDateTime.year == yesterday.year) {
      return 'Yesterday';
    }

    if (now.difference(localDateTime).inDays < 7) {
      String weekday = DateFormat('EEEE').format(localDateTime);
      return '$weekday';
    }
    return 'N/A';
  }
}
