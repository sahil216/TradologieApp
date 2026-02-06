import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/app_colors.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  //
  final double? height;
  final double? width;
  //
  final Widget? child;
  final Widget? childHolder;
  //
  final Color? color;
  final BoxBorder? border;
  final BoxShape shape;
  final BoxFit fit;
  //
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  //
  final List<BoxShadow>? boxShadow;

  const CustomCachedNetworkImage({
    super.key,
    required this.imageUrl,
    //
    this.height,
    this.width,
    //
    this.child,
    this.childHolder,
    //
    this.color,
    this.border,
    this.shape = BoxShape.rectangle,
    this.fit = BoxFit.fill,
    //
    this.borderRadius,
    this.padding,
    this.margin,
    //
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      imageBuilder: (context, imageProvider) {
        return Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color,
            shape: shape,
            border: border,
            boxShadow: boxShadow,
            borderRadius: borderRadius,
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
            ),
          ),
          child: child,
        );
      },
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          Shimmer.fromColors(
        baseColor: AppColors.defaultBaseShimmer,
        highlightColor: AppColors.defaultHighlightShimmer,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: shape,
            border: border,
            borderRadius: borderRadius,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Shimmer.fromColors(
        baseColor: AppColors.defaultBaseShimmer,
        highlightColor: AppColors.defaultHighlightShimmer,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: shape,
            border: border,
            borderRadius: borderRadius,
          ),
        ),
      ),
      fit: fit,
    );
  }
}
