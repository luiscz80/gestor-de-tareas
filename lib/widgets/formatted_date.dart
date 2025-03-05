import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormattedDate extends StatelessWidget {
  final DateTime dateTime;
  final TextStyle? style;

  const FormattedDate({
    Key? key,
    required this.dateTime,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDate(dateTime),
      style:
          style ?? const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  String _formatDate(DateTime dateTime) {
    final day = DateFormat.d().format(dateTime);
    final month = _getMonthInSpanish(dateTime);
    final year = DateFormat.y().format(dateTime);
    final hourMinute = DateFormat.Hm().format(dateTime);
    return '$day de $month de $year - $hourMinute';
  }

  String _getMonthInSpanish(DateTime dateTime) {
    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre'
    ];
    return months[dateTime.month - 1];
  }
}
