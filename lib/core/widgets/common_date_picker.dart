import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';

enum PickerType { date, time, dateTime }

class CommonDatePicker extends StatefulWidget {
  final String label;
  final String hint;
  final PickerType type;

  final DateTime? initialValue;
  final DateTime? firstDate;
  final DateTime? lastDate;

  final TimeOfDay? minTime;
  final TimeOfDay? maxTime;
  final bool hasError;

  final Function(DateTime?) onChanged;
  final String? Function(DateTime?)? validator;

  const CommonDatePicker({
    super.key,
    required this.label,
    required this.hint,
    required this.type,
    required this.onChanged,
    this.initialValue,
    this.firstDate,
    this.lastDate,
    this.minTime,
    this.maxTime,
    this.validator,
    this.hasError = false,
  });

  @override
  State<CommonDatePicker> createState() => _CommonDatePickerState();
}

class _CommonDatePickerState extends State<CommonDatePicker> {
  DateTime? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  bool _isTimeValid(TimeOfDay time) {
    if (widget.minTime != null) {
      if (time.hour < widget.minTime!.hour ||
          (time.hour == widget.minTime!.hour &&
              time.minute < widget.minTime!.minute)) {
        return false;
      }
    }

    if (widget.maxTime != null) {
      if (time.hour > widget.maxTime!.hour ||
          (time.hour == widget.maxTime!.hour &&
              time.minute > widget.maxTime!.minute)) {
        return false;
      }
    }

    return true;
  }

  Future<void> _pick() async {
    final now = DateTime.now();

    if (widget.type == PickerType.date) {
      final date = await showDatePicker(
        context: context,
        initialDate: _selected ?? now,
        firstDate: widget.firstDate ?? DateTime(2000),
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

      if (time == null) return;

      if (!_isTimeValid(time)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Selected time is outside allowed range"),
          ),
        );
        return;
      }

      final dt = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      setState(() => _selected = dt);
      widget.onChanged(dt);
    } else {
      final date = await showDatePicker(
        context: context,
        initialDate: _selected ?? now,
        firstDate: widget.firstDate ?? DateTime(2000),
        lastDate: widget.lastDate ?? DateTime(2100),
      );

      if (date == null) return;

      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selected ?? now),
      );

      if (time == null) return;

      if (!_isTimeValid(time)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Selected time is outside allowed range"),
          ),
        );
        return;
      }

      final dt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      setState(() => _selected = dt);
      widget.onChanged(dt);
    }
  }

  String _format(DateTime? value) {
    if (value == null) return widget.hint;

    switch (widget.type) {
      case PickerType.date:
        return DateFormat('yyyy/MM/dd').format(value);
      case PickerType.time:
        return DateFormat('HH:mm').format(value);
      case PickerType.dateTime:
        return DateFormat('yyyy/MM/dd HH:mm').format(value);
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
            /// Label
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            /// Field
            InkWell(
              onTap: _pick,
              borderRadius: BorderRadius.circular(14),
              child: InputDecorator(
                decoration: InputDecoration(
                  errorText: field.errorText,
                  filled: true,
                  fillColor: const Color(0xFFF1F3F5),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  suffixIcon: const Icon(
                    Icons.calendar_month_outlined,
                    size: 22,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color:
                          widget.hasError ? Colors.red : AppColors.defaultText,
                      width: 1,
                    ),
                  ),

                  /// 👇 FOCUSED BORDER
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: widget.hasError ? Colors.black : AppColors.black,
                      width: 1.4,
                    ),
                  ),

                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.4,
                    ),
                  ),
                ),
                child: Text(
                  _format(_selected),
                  style: TextStyle(
                    fontSize: 14,
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
