import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:equatable/equatable.dart';

// ─────────────── State ───────────────
abstract class AttachmentState extends Equatable {
  const AttachmentState();

  @override
  List<Object?> get props => [];
}

class AttachmentIdle extends AttachmentState {
  const AttachmentIdle();
}

class AttachmentMenuOpen extends AttachmentState {
  const AttachmentMenuOpen();
}

class AttachmentPicking extends AttachmentState {
  const AttachmentPicking();
}

class AttachmentPicked extends AttachmentState {
  final File file;
  final AttachmentPickType type;
  const AttachmentPicked({required this.file, required this.type});

  @override
  List<Object?> get props => [file.path, type];
}

class AttachmentError extends AttachmentState {
  final String message;
  const AttachmentError(this.message);

  @override
  List<Object?> get props => [message];
}

enum AttachmentPickType { camera, gallery, pdf }

// ─────────────── Cubit ───────────────
class AttachmentCubit extends Cubit<AttachmentState> {
  final ImagePicker _imagePicker = ImagePicker();

  AttachmentCubit() : super(const AttachmentIdle());

  void toggleMenu() {
    if (state is AttachmentMenuOpen) {
      emit(const AttachmentIdle());
    } else {
      emit(const AttachmentMenuOpen());
    }
  }

  void closeMenu() => emit(const AttachmentIdle());

  Future<void> pickFromCamera() async {
    emit(const AttachmentPicking());
    try {
      final xFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (xFile != null) {
        emit(AttachmentPicked(
          file: File(xFile.path),
          type: AttachmentPickType.camera,
        ));
      } else {
        emit(const AttachmentIdle());
      }
    } catch (e) {
      emit(AttachmentError('Camera access denied: ${e.toString()}'));
    }
  }

  Future<void> pickFromGallery() async {
    emit(const AttachmentPicking());
    try {
      final xFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (xFile != null) {
        emit(AttachmentPicked(
          file: File(xFile.path),
          type: AttachmentPickType.gallery,
        ));
      } else {
        emit(const AttachmentIdle());
      }
    } catch (e) {
      emit(AttachmentError('Gallery access denied: ${e.toString()}'));
    }
  }

  Future<void> pickPdf() async {
    emit(const AttachmentPicking());
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.single.path != null) {
        emit(AttachmentPicked(
          file: File(result.files.single.path!),
          type: AttachmentPickType.pdf,
        ));
      } else {
        emit(const AttachmentIdle());
      }
    } catch (e) {
      emit(AttachmentError('File access denied: ${e.toString()}'));
    }
  }

  void reset() => emit(const AttachmentIdle());
}
