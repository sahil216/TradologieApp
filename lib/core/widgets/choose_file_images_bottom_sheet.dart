// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../../core/utils/extensions.dart';
import '../../../../../../../core/utils/app_colors.dart';
import '../../../../../../core/utils/assets_manager.dart';
import 'custom_text/text_style_constants.dart';

class ChooseFileImagesBottomSheet extends StatelessWidget {
  final bool isMultiSelect;
  final bool isEnableCrop;

  const ChooseFileImagesBottomSheet({
    super.key,
    this.isMultiSelect = false,
    this.isEnableCrop = true,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: context.bottom,
      ),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 60,
                margin: EdgeInsets.only(top: 8, bottom: 24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        ("choose_photo"),
                        style: TextStyleConstants.medium(
                          context,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        _selectImage(ImageSource.gallery, context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                ("gallery"),
                                style: TextStyleConstants.regular(
                                  context,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SvgPicture.asset(
                              VectorAssets.gallery,
                              colorFilter: ColorFilter.mode(
                                  AppColors.primary, BlendMode.srcIn),
                              height: 25,
                              width: 25,
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _selectImage(ImageSource.camera, context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                ("camera"),
                                style: TextStyleConstants.regular(
                                  context,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SvgPicture.asset(
                              VectorAssets.camera,
                              colorFilter: ColorFilter.mode(
                                  AppColors.primary, BlendMode.srcIn),
                              height: 25,
                              width: 25,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        ("files"),
                        style: TextStyleConstants.medium(
                          context,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                ("files"),
                                style: TextStyleConstants.regular(
                                  context,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SvgPicture.asset(
                              VectorAssets.gallery,
                              colorFilter: ColorFilter.mode(
                                  AppColors.primary, BlendMode.srcIn),
                              height: 25,
                              width: 25,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          );
        },
      ),
    );
  }

  void _selectImage(ImageSource type, BuildContext context) {
    try {
      ImagePicker picker = ImagePicker();
      if (type == ImageSource.gallery && isMultiSelect) {
        picker.pickMultiImage().then(
          (value) async {
            Navigator.pop(context, value.map((e) => e.path).toList());
          },
        );
        return;
      }
      picker.pickImage(source: type).then(
        (value) async {
          if (value != null) {
            Navigator.pop(context, value.path);
          } else {
            Navigator.pop(context);
          }
        },
      );
    } catch (e) {
      return;
    }
  }
}
