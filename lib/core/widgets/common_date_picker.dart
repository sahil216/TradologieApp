import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum PickerType { date, time, dateTime }

class CommonDateTimePicker extends StatefulWidget {
  final String label;
  final String hint;
  final PickerType type;
  final DateTime? initialValue;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime?) onChanged;
  final String? Function(DateTime?)? validator;

  const CommonDateTimePicker({
    super.key,
    required this.label,
    required this.hint,
    required this.type,
    required this.onChanged,
    this.initialValue,
    this.firstDate,
    this.lastDate,
    this.validator,
  });

  @override
  State<CommonDateTimePicker> createState() => _CommonDateTimePickerState();
}

class _CommonDateTimePickerState extends State<CommonDateTimePicker> {
  DateTime? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  Future<void> _pick() async {
    DateTime now = DateTime.now();

    if (widget.type == PickerType.date) {
      final date = await showDatePicker(
        context: context,
        initialDate: _selected ?? now,
        firstDate: widget.firstDate ?? DateTime(1900),
        lastDate: widget.lastDate ?? DateTime(2100),
      );

      if (date != null) {
        setState(() => _selected = date);
        widget.onChanged(date);
      }
    } else if (widget.type == PickerType.time) {
      final time = await showTimePicker(
        context: context,
        initialTime: _selected != null
            ? TimeOfDay.fromDateTime(_selected!)
            : TimeOfDay.now(),
      );

      if (time != null) {
        final dateTime = DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        );

        setState(() => _selected = dateTime);
        widget.onChanged(dateTime);
      }
    } else {
      final date = await showDatePicker(
        context: context,
        initialDate: _selected ?? now,
        firstDate: widget.firstDate ?? DateTime(1900),
        lastDate: widget.lastDate ?? DateTime(2100),
      );

      if (date == null) return;

      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selected ?? now),
      );

      if (time == null) return;

      final dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      setState(() => _selected = dateTime);
      widget.onChanged(dateTime);
    }
  }

  String _format(DateTime? value) {
    if (value == null) return widget.hint;

    switch (widget.type) {
      case PickerType.date:
        return DateFormat('dd MMM yyyy').format(value);
      case PickerType.time:
        return DateFormat('hh:mm a').format(value);
      case PickerType.dateTime:
        return DateFormat('dd MMM yyyy • hh:mm a').format(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      validator: widget.validator,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pick,
              borderRadius: BorderRadius.circular(12),
              child: InputDecorator(
                decoration: InputDecoration(
                  errorText: field.errorText,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _format(_selected),
                  style: TextStyle(
                    color: _selected == null ? Colors.grey : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
