import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

import '../widgets/custom_dialog.dart';
import 'app_colors.dart';

extension MediaQueryValues on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
  double get top => MediaQuery.of(this).viewPadding.top;
  double get bottom => MediaQuery.of(this).viewPadding.bottom;
  double get topPading => MediaQuery.of(this).padding.top;
  double get bottomPading => MediaQuery.of(this).padding.bottom;
  double get topInsets => MediaQuery.of(this).viewInsets.top;
  double get bottomInsets => MediaQuery.of(this).viewInsets.bottom;

  bool get isCurrentScreen => ModalRoute.of(this)?.isCurrent == true;

  double getHeightImage({
    double subFromWidth = 0,
    int colsInRow = 1,
    required int heightImage,
    required int widthImage,
  }) {
    return (heightImage * ((width - subFromWidth)) / colsInRow) / widthImage;
  }

  double getChildAspectRatio({
    double subFromWidth = 0,
    int colsInRow = 1,
    required int heightImage,
    required int widthImage,
  }) {
    return (width / colsInRow) /
        ((heightImage * (width / colsInRow)) / widthImage);
  }

  showCustomDialog(
    Widget child, {
    double borderRadius = 18,
    bool barrierDismissible = true,
    Function(Object?)? onValue,
    EdgeInsetsGeometry? margin,
    AlignmentGeometry? alignment,
  }) {
    showGeneralDialog(
      context: this,
      barrierLabel: "",
      barrierDismissible: barrierDismissible,
      barrierColor: AppColors.primary,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, a1, a2, widget) {
        return CustomDialog(
          a1: a1,
          a2: a2,
          borderRadius: borderRadius,
          margin: margin,
          alignment: alignment,
          child: child,
        );
      },
    ).then(onValue ?? (value) => null);
  }

  void showCustomBottomSheet(
    Widget child, {
    Function(Object?)? onValue,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: this,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: AppColors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      builder: (BuildContext ctx) {
        return child;
      },
    ).then(onValue ?? (value) => null);
  }
}

extension ListValues on List {
  int getIndexByKey(Key key) {
    final messageKey = key as ValueKey;
    return indexWhere((msg) => msg.id == messageKey.value);
  }

  void updateItemFromList(dynamic newItem) {
    final item = firstWhereOrNull((element) => element.id == newItem.id);
    if (item != null) {
      var itemIndex = indexOf(item);
      insert(itemIndex, newItem);
      remove(item);
    }
  }
}

extension DateTimeValues on DateTime {
  String get dateFormat {
    return DateFormat('yyyy-MM-dd').format(this).replaceArabicNumerals;
  }

  String get dateStringFormat {
    return DateFormat(
      'EEEE, d MMMM y',
    ).format(this).replaceArabicNumerals;
  }
}

extension StringValues on String {
  bool get isEmailValid {
    final emailRegExp = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegExp.hasMatch(this);
  }

  String get removeTrailingZero {
    if (contains('.') && !endsWith('0')) {
      return this;
    } else {
      return replaceAll(RegExp(r'\.0+$'), '');
    }
  }

  Future<void> get launchUrl async {
    final Uri uri = Uri.parse(this);
    if (await launcher.canLaunchUrl(uri)) {
      await launcher.launchUrl(uri,
          mode: launcher.LaunchMode.externalApplication);
    }
  }

  Future<void> get launchCall async {
    final Uri uri = Uri(
      scheme: 'tel',
      path: this,
    );
    if (await launcher.canLaunchUrl(uri)) {
      await launcher.launchUrl(uri,
          mode: launcher.LaunchMode.externalApplication);
    }
  }

  Future<void> get launchEmail async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: this,
    );
    if (await launcher.canLaunchUrl(uri)) {
      await launcher.launchUrl(uri,
          mode: launcher.LaunchMode.externalApplication);
    }
  }

  String get keyLocalization =>
      toLowerCase().replaceAll(" ", "_").replaceAll(".", "");

  String get datePointFormat {
    DateTime originalDate = DateTime.parse(this);
    return DateFormat('yyyy.MM.dd').format(originalDate).replaceArabicNumerals;
  }

  String get dateFormatyMMMMd {
    DateTime originalDate = DateTime.parse(this);

    return DateFormat.yMMMMd().format(originalDate).replaceArabicNumerals;
  }

  String get replaceArabicNumerals {
    var output = this;
    output = output.replaceAll("٠", "0");
    output = output.replaceAll("١", "1");
    output = output.replaceAll("٢", "2");
    output = output.replaceAll("٣", "3");
    output = output.replaceAll("٤", "4");
    output = output.replaceAll("٥", "5");
    output = output.replaceAll("٦", "6");
    output = output.replaceAll("٧", "7");
    output = output.replaceAll("٨", "8");
    output = output.replaceAll("٩", "9");
    return output;
  }
}
