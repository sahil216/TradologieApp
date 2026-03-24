import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';

class PremiumDocumentPicker extends StatefulWidget {
  final String title;
  final List<String> allowedExtensions;
  final Function(File?) onFileSelected;
  final String? initialFileUrl;
  final Widget? upload;

  const PremiumDocumentPicker({
    super.key,
    required this.title,
    required this.allowedExtensions,
    required this.onFileSelected,
    this.initialFileUrl,
    this.upload,
  });

  @override
  State<PremiumDocumentPicker> createState() => _PremiumDocumentPickerState();
}

class _PremiumDocumentPickerState extends State<PremiumDocumentPicker> {
  File? file;
  String? networkFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    networkFile = widget.initialFileUrl;
  }

  bool isImage(String path) {
    return path.toLowerCase().endsWith(".jpg") ||
        path.toLowerCase().endsWith(".jpeg") ||
        path.toLowerCase().endsWith(".png");
  }

  bool isPdf(String path) {
    return path.toLowerCase().endsWith(".pdf");
  }

  Future<void> _pickFromCamera() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) _setFile(File(picked.path));
  }

  Future<void> _pickFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) _setFile(File(picked.path));
  }

  Future<void> _pickFromFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: widget.allowedExtensions,
    );

    if (result != null && result.files.single.path != null) {
      _setFile(File(result.files.single.path!));
    }
  }

  void _setFile(File newFile) {
    setState(() {
      file = newFile;
      networkFile = null;
    });
    widget.onFileSelected(file);
  }

  void _removeFile() {
    setState(() {
      file = null;
      networkFile = null;
    });
    widget.onFileSelected(null);
  }

  void _openPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: const Text("Files"),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromFiles();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// 🔥 Open Preview
  Future<void> _openPreview() async {
    final path = file?.path ?? networkFile;

    if (path == null) return;

    if (isImage(path)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FullScreenImageView(
            file: file,
            url: networkFile,
          ),
        ),
      );
    }
  }

  Future<String> downloadFile(String url) async {
    final dir = await getTemporaryDirectory();
    final path = "${dir.path}/temp.pdf";
    await Dio().download(url, path);
    return path;
  }

  @override
  Widget build(BuildContext context) {
    final hasFile = file != null || networkFile != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          /// Upload Box
          GestureDetector(
            onTap: _openPicker,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text(
                      "Browse",
                      style: TextStyleConstants.medium(context, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      hasFile
                          ? (file != null
                              ? file!.path.split('/').last
                              : networkFile!.split('/').last)
                          : widget.initialFileUrl ?? "Click to upload file",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyleConstants.medium(context, fontSize: 16),
                    ),
                  ),
                  if (hasFile)
                    GestureDetector(
                      onTap: _removeFile,
                      child: const Icon(Icons.close, color: Colors.red),
                    )
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          /// Preview
          // if (hasFile)
          //   GestureDetector(
          //     onTap: _openPreview,
          //     child: Container(
          //       padding: const EdgeInsets.all(10),
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10),
          //         color: Colors.grey.shade100,
          //       ),
          //       child: Row(
          //         children: [
          //           if (file != null && isImage(file!.path))
          //             Image.file(file!, width: 50, height: 50)
          //           else if (networkFile != null && isImage(networkFile!))
          //             Image.network(networkFile!, width: 50, height: 50)
          //           else if ((file != null && isPdf(file!.path)) ||
          //               (networkFile != null && isPdf(networkFile!)))
          //             const Icon(Icons.picture_as_pdf, size: 40)
          //           else
          //             const Icon(Icons.description, size: 40),
          //           const SizedBox(width: 10),
          //           const Text("Tap to preview"),
          //           const Spacer(),
          //           const Icon(Icons.check_circle, color: Colors.green),
          //         ],
          //       ),
          //     ),
          //   ),
          file != null ? widget.upload ?? Container() : Container(),
        ],
      ),
    );
  }
}

/// 🔥 Full Screen Image Viewer
class FullScreenImageView extends StatelessWidget {
  final File? file;
  final String? url;

  const FullScreenImageView({super.key, this.file, this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Center(
        child: file != null ? Image.file(file!) : Image.network(url!),
      ),
    );
  }
}

/// 🔥 PDF Viewer
