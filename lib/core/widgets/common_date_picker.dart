import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';

class CommonCupertinoDatePicker extends StatelessWidget {
  final String label;
  final String hint;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final String? Function(DateTime?)? validator;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final DateFormat dateFormat;

  const CommonCupertinoDatePicker({
    super.key,
    required this.label,
    required this.hint,
    required this.onDateSelected,
    this.selectedDate,
    this.validator,
    this.minimumDate,
    this.maximumDate,
    required this.dateFormat,
  });

  void _showCupertinoPicker(
      BuildContext context, FormFieldState<DateTime> state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (_) {
        DateTime tempDate = selectedDate ?? DateTime.now();

        return Container(
          height: 300,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              /// Top action bar
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.black12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: CommonText(
                        "Cancel",
                        style: TextStyle(color: AppColors.blue),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        onDateSelected(tempDate);
                        state.didChange(tempDate);
                        Navigator.pop(context);
                      },
                      child: CommonText(
                        "Done",
                        style: TextStyle(
                          color: AppColors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Cupertino picker
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: selectedDate ?? DateTime.now(),
                  minimumDate: minimumDate,
                  maximumDate: maximumDate,
                  onDateTimeChanged: (date) {
                    tempDate = date;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      validator: validator,
      initialValue: selectedDate,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Label
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),

            /// Field
            InkWell(
              onTap: () => _showCupertinoPicker(context, state),
              child: InputDecorator(
                decoration: InputDecoration(
                  hintText: hint,
                  errorText: state.errorText,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  suffixIcon: const Icon(Icons.calendar_today),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.grayText),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.blue),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.red),
                  ),
                ),
                child: Text(
                  selectedDate != null ? dateFormat.format(selectedDate!) : '',
                  style: TextStyle(
                    color: selectedDate != null
                        ? AppColors.black
                        : AppColors.grayText,
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
