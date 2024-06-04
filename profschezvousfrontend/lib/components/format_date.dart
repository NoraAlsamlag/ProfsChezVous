  import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  final DateFormat formatter = DateFormat('EEEE, d MMMM', 'fr_FR');
  return '${formatter.format(date)}';
}