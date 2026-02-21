import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';

class _ImagePickerFieldUI extends StatefulWidget {
  final ImagePickerController controller;
  final String label;
  final String hint;
  final String? errorText;
  final Function(File?) onChanged;

  const _ImagePickerFieldUI({
    required this.controller,
    required this.label,
    required this.hint,
    required this.errorText,
    required this.onChanged,
  });

  @override
  State<_ImagePickerFieldUI> createState() => _ImagePickerFieldUIState();
}

class _ImagePickerFieldUIState extends State<_ImagePickerFieldUI> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _showPicker() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final XFile? picked =
        await _picker.pickImage(source: source, imageQuality: 80);

    if (picked != null) {
      final file = File(picked.path);
      widget.controller.setFile(file);
      widget.onChanged(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (_, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: _showPicker,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: widget.label,
                  labelStyle: TextStyleConstants.medium(context, fontSize: 16),
                  errorText: widget.errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: widget.controller.hasImage
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            widget.controller.clear();
                            widget.onChanged(null);
                          },
                        )
                      : SizedBox(),
                ),
                child: Row(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _buildPreview(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.controller.hasImage
                            ? "Image selected"
                            : widget.hint,
                        style: TextStyle(
                          color: widget.controller.hasImage
                              ? Colors.black
                              : Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPreview() {
    if (widget.controller.file != null) {
      return ClipRRect(
        key: const ValueKey("file"),
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          widget.controller.file!,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
        ),
      );
    }

    if (widget.controller.networkUrl != null) {
      return ClipRRect(
        key: const ValueKey("network"),
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          widget.controller.networkUrl!,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
        ),
      );
    }

    return const Icon(Icons.add_photo_alternate_outlined);
  }
}

class ImagePickerController extends ChangeNotifier {
  File? file;
  String? networkUrl;

  void setFile(File? value) {
    file = value;
    networkUrl = null;
    notifyListeners();
  }

  void setNetwork(String? url) {
    networkUrl = url;
    file = null;
    notifyListeners();
  }

  void clear() {
    file = null;
    networkUrl = null;
    notifyListeners();
  }

  bool get hasImage => file != null || networkUrl != null;
}

class ImagePickerFormField extends FormField<File> {
  ImagePickerFormField({
    super.key,
    required ImagePickerController controller,
    required String label,
    String hint = "Select image",
    FormFieldValidator<File>? validator,
    Function(File?)? onChanged,
  }) : super(
          validator: validator,
          builder: (state) {
            return _ImagePickerFieldUI(
              controller: controller,
              label: label,
              hint: hint,
              errorText: state.errorText,
              onChanged: (file) {
                state.didChange(file);
                onChanged?.call(file);
              },
            );
          },
        );
}

class CommonImagePickerField extends StatefulWidget {
  final String label;
  final String hint;
  final Function(File?) onChanged;
  final File? initialFile;

  const CommonImagePickerField({
    super.key,
    required this.label,
    required this.hint,
    required this.onChanged,
    this.initialFile,
  });

  @override
  State<CommonImagePickerField> createState() => _CommonImagePickerFieldState();
}

class _CommonImagePickerFieldState extends State<CommonImagePickerField> {
  final ImagePicker _picker = ImagePicker();
  File? file;

  @override
  void initState() {
    super.initState();
    file = widget.initialFile;
  }

  Future<void> _pick() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      file = File(picked.path);
      setState(() {});
      widget.onChanged(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    /// 🔥 SAME STYLE LIKE YOUR OTHER FIELDS
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: _pick,
          child: InputDecorator(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade200, // 👈 same grey background
              hintText: widget.hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18, // 👈 same height as dropdowns
              ),
              suffixIcon: const Icon(Icons.image_outlined),
            ),

            /// FIELD CONTENT
            child: Row(
              children: [
                if (file != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      file!,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  const Icon(Icons.add_photo_alternate_outlined),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    file != null ? "Image selected" : widget.hint,
                    style: TextStyle(
                      color:
                          file != null ? Colors.black87 : Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
