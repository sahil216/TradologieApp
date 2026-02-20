import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum PickerType { date, time, dateTime }

class CommonDatePicker extends FormField<DateTime> {
  CommonDatePicker({
    super.key,
    required String label,
    required String hint,
    required PickerType type,
    super.initialValue,
    DateTime? firstDate,
    DateTime? lastDate,
    TimeOfDay? minTime,
    TimeOfDay? maxTime,
    bool isRequired = false,
    required Function(DateTime?) onChanged,
    super.validator,
  }) : super(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (field) {
            final state = field as _CommonDatePickerState;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// LABEL
                RichText(
                  text: TextSpan(
                    text: label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    children: [
                      if (isRequired)
                        const TextSpan(
                          text: " *",
                          style: TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                /// FIELD
                InkWell(
                  onTap: () => state._pick(
                    field,
                    type,
                    firstDate,
                    lastDate,
                    minTime,
                    maxTime,
                    onChanged,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      errorText: field.hasError ? field.errorText : null,
                      helperText: " ", // ⭐ keeps height stable
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      suffixIcon: const Icon(
                        Icons.calendar_month_outlined,
                        size: 22,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                            const BorderSide(color: Colors.black87, width: 1.2),
                      ),

                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1.4),
                      ),

                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1.4),
                      ),
                    ),
                    child: Text(
                      state._format(field.value, type, hint),
                      style: TextStyle(
                        fontSize: 14,
                        color: field.value == null ? Colors.grey : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );

  @override
  FormFieldState<DateTime> createState() => _CommonDatePickerState();
}

class _CommonDatePickerState extends FormFieldState<DateTime> {
  String _format(DateTime? value, PickerType type, String hint) {
    if (value == null) return hint;

    switch (type) {
      case PickerType.date:
        return DateFormat('yyyy/MM/dd').format(value);
      case PickerType.time:
        return DateFormat('HH:mm').format(value);
      case PickerType.dateTime:
        return DateFormat('yyyy/MM/dd HH:mm').format(value);
    }
  }

  bool _isTimeValid(TimeOfDay time, TimeOfDay? min, TimeOfDay? max) {
    if (min != null) {
      if (time.hour < min.hour ||
          (time.hour == min.hour && time.minute < min.minute)) {
        return false;
      }
    }
    if (max != null) {
      if (time.hour > max.hour ||
          (time.hour == max.hour && time.minute > max.minute)) {
        return false;
      }
    }
    return true;
  }

  Future<void> _pick(
    FormFieldState<DateTime> field,
    PickerType type,
    DateTime? firstDate,
    DateTime? lastDate,
    TimeOfDay? minTime,
    TimeOfDay? maxTime,
    Function(DateTime?) onChanged,
  ) async {
    final context = this.context;
    final now = DateTime.now();

    DateTime? result;

    if (type == PickerType.date) {
      result = await showDatePicker(
        context: context,
        initialDate: field.value ?? now,
        firstDate: firstDate ?? DateTime(2000),
        lastDate: lastDate ?? DateTime(2100),
      );
    } else if (type == PickerType.time) {
      final time = await showTimePicker(
        context: context,
        initialTime: field.value != null
            ? TimeOfDay.fromDateTime(field.value!)
            : TimeOfDay.now(),
      );

      if (time == null) return;

      if (!_isTimeValid(time, minTime, maxTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Selected time not allowed")),
        );
        return;
      }

      result = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    } else {
      final date = await showDatePicker(
        context: context,
        initialDate: field.value ?? now,
        firstDate: firstDate ?? DateTime(2000),
        lastDate: lastDate ?? DateTime(2100),
      );

      if (date == null) return;

      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(field.value ?? now),
      );

      if (time == null) return;

      if (!_isTimeValid(time, minTime, maxTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Selected time not allowed")),
        );
        return;
      }

      result =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
    }

    if (result != null) {
      (field as FormFieldState<DateTime>)
          .didChange(result); // ⭐ TRIGGERS VALIDATION
      onChanged(result);
    }
  }
}
