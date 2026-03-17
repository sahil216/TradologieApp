import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class PremiumDocumentPicker extends StatefulWidget {
  final String title;
  final List<String> allowedExtensions;
  final Function(File?) onFileSelected;

  const PremiumDocumentPicker({
    super.key,
    required this.title,
    required this.allowedExtensions,
    required this.onFileSelected,
  });

  @override
  State<PremiumDocumentPicker> createState() => _PremiumDocumentPickerState();
}

class _PremiumDocumentPickerState extends State<PremiumDocumentPicker>
    with SingleTickerProviderStateMixin {
  File? file;
  final ImagePicker _picker = ImagePicker();

  late AnimationController _controller;
  late Animation<double> _scale;

  String selectedAction = "Choose";

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scale = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> handleSelection(String value) async {
    setState(() => selectedAction = value);

    if (value == "Camera") {
      final picked = await _picker.pickImage(source: ImageSource.camera);
      if (picked != null) _setFile(File(picked.path));
    } else if (value == "Gallery") {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) _setFile(File(picked.path));
    } else if (value == "File") {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: widget.allowedExtensions,
      );
      if (result != null) {
        _setFile(File(result.files.single.path!));
      }
    }
  }

  void _setFile(File newFile) {
    setState(() => file = newFile);
    widget.onFileSelected(file);
    _controller.forward(from: 0);
  }

  void removeFile() {
    setState(() {
      file = null;
      selectedAction = "Choose";
    });
    widget.onFileSelected(null);
  }

  bool isImage(String path) {
    return path.endsWith(".jpg") ||
        path.endsWith(".jpeg") ||
        path.endsWith(".png");
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = file != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          /// Glass Container
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white.withOpacity(0.15),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    /// Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white.withOpacity(0.25),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedAction,
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          items: const [
                            DropdownMenuItem(
                                value: "Choose", child: Text("Choose Source")),
                            DropdownMenuItem(
                                value: "Camera", child: Text("Camera")),
                            DropdownMenuItem(
                                value: "Gallery", child: Text("Gallery")),
                            DropdownMenuItem(
                                value: "File", child: Text("File")),
                          ],
                          onChanged: (value) {
                            if (value != null && value != "Choose") {
                              handleSelection(value);
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// Animated Preview
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: isSelected
                          ? ScaleTransition(
                              scale: _scale,
                              child: Container(
                                key: const ValueKey("file"),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                child: Row(
                                  children: [
                                    /// Preview
                                    if (isImage(file!.path))
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          file!,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    else
                                      const Icon(Icons.description, size: 40),

                                    const SizedBox(width: 12),

                                    /// File Name
                                    Expanded(
                                      child: Text(
                                        file!.path.split('/').last,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    const Icon(Icons.check_circle,
                                        color: Colors.green),

                                    const SizedBox(width: 8),

                                    GestureDetector(
                                      onTap: removeFile,
                                      child: const Icon(Icons.close,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              key: const ValueKey("empty"),
                              padding: const EdgeInsets.all(20),
                              alignment: Alignment.center,
                              child: Text(
                                "No file selected",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
