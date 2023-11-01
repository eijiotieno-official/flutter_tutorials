// Utility function to format time as a human-readable string (e.g., 'Just now', '5 minutes ago', etc.).
import 'package:intl/intl.dart';

String formatTimeFromNow({required DateTime dateTime}) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    final minutes = difference.inMinutes;
    return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
  } else if (difference.inHours < 24) {
    final hours = difference.inHours;
    return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
  } else if (difference.inDays < 30) {
    final days = difference.inDays;
    return '$days ${days == 1 ? 'day' : 'days'} ago';
  } else {
    // Format the date using intl package
    final formatter = DateFormat.yMMMd();
    return formatter.format(dateTime);
  }
}
