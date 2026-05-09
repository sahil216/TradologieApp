import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/hex_color.dart';
import 'package:tradologie_app/core/utils/exit_app_dialog.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chat_data.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chat_list.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/get_file_url_response.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/chat_data_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_file_url_usecase.dart';
import 'package:tradologie_app/features/fmcg/presentation/cubit/chat_cubit.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/fmcg_distributor_enq.dart';

// ─── Attachment model ─────────────────────────────────────────────────────────

enum AttachmentType { image, file }

class AttachmentItem {
  final AttachmentType type;
  final String path;
  final String name;
  AttachmentItem({required this.type, required this.path, required this.name});
}

// ─── Chat Screen ──────────────────────────────────────────────────────────────

class ChatScreen extends StatefulWidget {
  final ChatList chat;
  const ChatScreen({
    super.key,
    required this.chat,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController controller = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final ScrollController _scrollController = ScrollController();

  List<ChatData>? chatData;
  GetFileUrlResponse? fileUrlResponse;

  String token = "";
  String loginId = "";
  Timer? _timer;
  bool _isFetching = false;
  bool _isFilePicked = false; // tracks whether picked item is a file vs image

  ChatCubit get chatCubit => BlocProvider.of(context);
  SecureStorageService secureStorage = SecureStorageService();

  // ── Lifecycle ──────────────────────────────────────────────────────────────





  @override
  void initState() {
    super.initState();
    getData("", "0", false, false);
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }






  // ── Polling ────────────────────────────────────────────────────────────────

  void _startPolling() {
    _timer =
        Timer.periodic(const Duration(seconds: 10), (_) => fetchMessages());
  }

  Future<void> fetchMessages() async {
    if (_isFetching) return;
    _isFetching = true;
    try {
      getData("", "0", false, false);
    } catch (e) {
      if (kDebugMode) print(e);
    } finally {
      _isFetching = false;
    }
  }

  void getData(
      String? message,
      String? chatId,
      bool isMessage,
      bool isFile,
      ) async {
    token = await secureStorage.read(AppStrings.apiVerificationCode) ?? "";
    loginId = await secureStorage.read(AppStrings.loginId) ?? "";
    chatCubit.chatData(ChatDataParams(
      token: token,
      contents: message ?? "",
      chatID: chatId ?? "0",
      buyerID: Constants.isBuyer ? loginId : widget.chat.quotationUserId ?? "",
      sellerID: Constants.isBuyer ? widget.chat.sellerId ?? "" : loginId,
      deviceID: Constants.deviceID,
      isMessage: isMessage,
      fileType: "",
      attachmentType: isFile ? "file" : "image",
      type: Constants.isBuyer ? "Buyer" : "Seller",
      brandId: Constants.isBuyer
          ? widget.chat.brandId ?? ""
          : await secureStorage.read(AppStrings.brandId) ?? "",
    ));
  }

  // ── Scroll ─────────────────────────────────────────────────────────────────

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // ── Send ───────────────────────────────────────────────────────────────────

  void _sendMessage() {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    getData(text, chatData?.last.chatId.toString(), true, false);
    controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _sendFile(bool isFile, String fileUrl) {
    getData(fileUrl, chatData?.last.chatId.toString(), false, isFile);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  // ── Attachment picker ──────────────────────────────────────────────────────

  void _showAttachmentPicker() {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 120),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                    ),
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 4, 20, 4),
                    child: Text(
                      "Add Attachment",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  const Divider(height: 16, indent: 20, endIndent: 20),
                  _AttachmentOption(
                    icon: Icons.camera_alt_rounded,
                    label: "Camera",
                    color: const Color(0xFF0A84FF),
                    onTap: () {
                      Navigator.pop(context);
                      _pickFromCamera();
                    },
                  ),
                  _AttachmentOption(
                    icon: Icons.photo_library_rounded,
                    label: "Gallery",
                    color: const Color(0xFF34C759),
                    onTap: () {
                      Navigator.pop(context);
                      _pickFromGallery();
                    },
                  ),
                  _AttachmentOption(
                    icon: Icons.insert_drive_file_rounded,
                    label: "File",
                    color: const Color(0xFFFF9500),
                    onTap: () {
                      Navigator.pop(context);
                      _pickFile();
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Pickers ────────────────────────────────────────────────────────────────

  Future<String?> _cropPickedImage(String sourcePath) async {
    final toolbarColor = HexColor('#0A84FF');
    try {
      final cropped = await ImageCropper().cropImage(
        sourcePath: sourcePath,
        compressQuality: 85,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop image',
            toolbarColor: toolbarColor,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop image',
          ),
        ],
      );
      return cropped?.path;
    } catch (e) {
      if (kDebugMode) print('Crop error: $e');
      CommonToast.error('Could not crop image.');
      return null;
    }
  }

  Future<void> _pickFromCamera() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 85);
      if (photo == null || !mounted) return;
      final croppedPath = await _cropPickedImage(photo.path);
      if (croppedPath == null || !mounted) return;
      _isFilePicked = false;
      _showPreviewSheet(AttachmentItem(
        type: AttachmentType.image,
        path: croppedPath,
        name: photo.name,
      ));
    } catch (e) {
      if (kDebugMode) print("Camera error: $e");
      CommonToast.error("Could not open camera.");
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 85);
      if (image == null || !mounted) return;
      final croppedPath = await _cropPickedImage(image.path);
      if (croppedPath == null || !mounted) return;
      _isFilePicked = false;
      _showPreviewSheet(AttachmentItem(
        type: AttachmentType.image,
        path: croppedPath,
        name: image.name,
      ));
    } catch (e) {
      if (kDebugMode) print("Gallery error: $e");
      CommonToast.error("Could not open gallery.");
    }
  }

  Future<void> _pickFile() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt'],
      );
      if (result != null && result.files.single.path != null) {
        final file = result.files.single;
        _isFilePicked = true;
        _showPreviewSheet(AttachmentItem(
          type: AttachmentType.file,
          path: file.path!,
          name: file.name,
        ));
      }
    } catch (e) {
      if (kDebugMode) print("File pick error: $e");
      CommonToast.error("Could not pick file.");
    }
  }

  // ── Preview sheet ──────────────────────────────────────────────────────────

  void _showPreviewSheet(AttachmentItem attachment) {
    final primaryColor = HexColor('#0A84FF');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AttachmentPreviewSheet(
        attachment: attachment,
        primaryColor: primaryColor,
        onSend: () {
          Navigator.pop(context);
          chatCubit.getFileUrl(GetFileUrlParams(
            token: token,
            deviceId: Constants.deviceID,
            file: File(attachment.path),
            type: Constants.isBuyer ? "Buyer" : "Seller",
          ));
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _scrollToBottom());
        },
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final primaryColor = HexColor('#0A84FF');



    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (!mounted) return;
        showExitAppConfirmationDialog(context);
      },
      child: AdaptiveScaffold(
        body: BlocListener<ChatCubit, ChatState>(
          listenWhen: (prev, curr) => prev != curr,
          listener: (context, state) {
            if (state is ChatDataSuccess) {
              setState(() => chatData = state.data);
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _scrollToBottom());
            }
            if (state is ChatDataError) {
              // CommonToast.showFailureToast(state.failure);
            }
            if (state is GetFileUrlSuccess) {
              setState(() => fileUrlResponse = state.data);
              _sendFile(_isFilePicked, fileUrlResponse?.fileUrl ?? "");
            }
            if (state is GetFileUrlError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
          child: SafeArea(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                return Column(
                  children: [
                    ChatTopBar(
                      name: Constants.isBuyer
                          ? widget.chat.userId ?? ""
                          : widget.chat.name ?? "",
                      imageUrl: widget.chat.profileImage ?? "",
                      notificationCount: 2,
                      isOnline:
                      widget.chat.loginStatus?.toLowerCase() == "online",
                      onBackTap: () => Navigator.pop(context),
                      onNotificationTap: () {},
                    ),
                    Expanded(
                      child: CustomScrollView(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                  final msg = chatData?[index];
                                  final isMe = msg?.msgType?.toLowerCase() ==
                                      (Constants.isBuyer ? "buyer" : "seller");

                                  // Parse MsgContent JSON
                                  Map<String, dynamic>? data;
                                  try {
                                    if ((msg?.msgContent ?? "").isNotEmpty) {
                                      data = jsonDecode(msg!.msgContent!);
                                    }
                                  } catch (_) {
                                    data = null;
                                  }

                                  final String contentUrl =
                                      data?["Message"] ?? "";
                                  final bool isMessage =
                                      msg?.isMessage?.toLowerCase() == "true";
                                  final String attachmentType =
                                  (msg?.attachmentType ?? "").toLowerCase();

                                  return Column(
                                    children: [
                                      if ((msg?.displayDate ?? "").isNotEmpty)
                                        _DateChip(date: msg?.displayDate ?? ""),
                                      Align(
                                        alignment: isMe
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.74,
                                            ),
                                            // ── Conditional bubble ───────────
                                            child: isMessage
                                            // 1️⃣ Normal text message
                                                ? _TextBubble(
                                              message: contentUrl,
                                              time: msg?.displayTime ?? "",
                                              isMe: isMe,
                                              primaryColor: primaryColor,
                                            )
                                                : attachmentType == "image"
                                            // 2️⃣ Image message
                                                ? _ImageBubble(
                                              imageUrl: contentUrl,
                                              time: msg?.displayTime ??
                                                  "",
                                              isMe: isMe,
                                              primaryColor:
                                              primaryColor,
                                            )
                                            // 3️⃣ File message
                                                : _FileBubble(
                                              fileUrl: contentUrl,
                                              time: msg?.displayTime ??
                                                  "",
                                              isMe: isMe,
                                              primaryColor:
                                              primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                childCount: chatData?.length ?? 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _InputBar(
                      controller: controller,
                      primaryColor: primaryColor,
                      onAttachTap: _showAttachmentPicker,
                      onSend: _sendMessage,
                    ),
                  ],
                );
              },
            ),
          ),


        ),
      ),
    );
  }
}

// ─── 1️⃣ Text bubble ──────────────────────────────────────────────────────────


// Updated by Gopal _TextBubble class ( added tick of read and unread)


class _TextBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isMe;
  //final bool isRead; // 👈 NEW
  final Color primaryColor;

  const _TextBubble({
    required this.message,
    required this.time,
    required this.isMe,
    //required this.isRead, // 👈 NEW
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {

    final bool isRead = true;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isMe ?   Colors.white:primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(isMe ? 18 : 4),
          bottomRight: Radius.circular(isMe ? 4 : 18),
        ),
        border: isMe ? null : Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: TextStyleConstants.medium(
              context,
              color: isMe ?  const Color(0xff1F2937):Colors.white ,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),

          // 👇 TIME + TICKS
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                time,
                style: TextStyleConstants.medium(
                  context,
                  color: isMe ?  Colors.grey.shade600 : Colors.white70,
                  fontSize: 11,
                ),
              ),

              if (isMe) ...[
                const SizedBox(width: 4),
                Icon(
                  isRead ? Icons.done_all : Icons.done,
                  size: 16,
                  color: isRead ? Colors.blue : Colors.white70,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}




/*


// old code without tick

class _TextBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isMe;
  final Color primaryColor;

  const _TextBubble({
    required this.message,
    required this.time,
    required this.isMe,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isMe ? primaryColor : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(isMe ? 18 : 4),
          bottomRight: Radius.circular(isMe ? 4 : 18),
        ),
        border: isMe ? null : Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: TextStyleConstants.medium(
              context,
              color: isMe ? Colors.white : const Color(0xff1F2937),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            time,
            style: TextStyleConstants.medium(
              context,
              color: isMe ? Colors.white70 : Colors.grey.shade600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}



*/






// ─── 2️⃣ Image bubble ─────────────────────────────────────────────────────────

class _ImageBubble extends StatelessWidget {
  final String imageUrl;
  final String time;
  final bool isMe;
  final Color primaryColor;

  const _ImageBubble({
    required this.imageUrl,
    required this.time,
    required this.isMe,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (imageUrl.isNotEmpty) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => _FullScreenImageViewer(imageUrl: imageUrl),
          ));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isMe ? primaryColor : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18),
          ),
          border: isMe ? null : Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(17),
                topRight: const Radius.circular(17),
                bottomLeft: Radius.circular(isMe ? 17 : 3),
                bottomRight: Radius.circular(isMe ? 3 : 17),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        width: double.infinity,
                        height: 200,
                        color: isMe
                            ? primaryColor.withValues(alpha: 0.6)
                            : Colors.grey.shade100,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!
                                : null,
                            color: isMe ? Colors.white : primaryColor,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      width: double.infinity,
                      height: 120,
                      color: Colors.grey.shade200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image_rounded,
                              color: Colors.grey.shade400, size: 32),
                          const SizedBox(height: 6),
                          Text("Image unavailable",
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  // Tap-to-view hint overlay
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.zoom_out_map_rounded,
                              color: Colors.white, size: 12),
                          SizedBox(width: 4),
                          Text("Tap to view",
                              style:
                              TextStyle(color: Colors.white, fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),
              child: Text(
                time,
                style: TextStyleConstants.medium(
                  context,
                  color: isMe ? Colors.white70 : Colors.grey.shade600,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 3️⃣ File bubble ──────────────────────────────────────────────────────────

class _FileBubble extends StatelessWidget {
  final String fileUrl;
  final String time;
  final bool isMe;
  final Color primaryColor;

  const _FileBubble({
    required this.fileUrl,
    required this.time,
    required this.isMe,
    required this.primaryColor,
  });

  String get _fileName {
    try {
      return Uri.parse(fileUrl).pathSegments.last;
    } catch (_) {
      return fileUrl;
    }
  }

  String get _ext => _fileName.split('.').last.toLowerCase();

  IconData get _icon {
    switch (_ext) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart_rounded;
      case 'doc':
      case 'docx':
        return Icons.article_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Color get _iconColor {
    switch (_ext) {
      case 'pdf':
        return const Color(0xFFFF453A);
      case 'xls':
      case 'xlsx':
        return const Color(0xFF34C759);
      case 'doc':
      case 'docx':
        return const Color(0xFF0A84FF);
      default:
        return const Color(0xFF8E8E93);
    }
  }

  Future<void> _openFile() async {
    if (fileUrl.isEmpty) return;
    final uri = Uri.parse(fileUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openFile,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? primaryColor : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18),
          ),
          border: isMe ? null : Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // File icon badge
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: isMe
                        ? Colors.white.withValues(alpha: 0.2)
                        : _iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _icon,
                    color: isMe ? Colors.white : _iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _fileName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isMe ? Colors.white : const Color(0xFF1F2937),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.download_rounded,
                            size: 12,
                            color: isMe ? Colors.white70 : Colors.grey.shade500,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            "Tap to open",
                            style: TextStyle(
                              color:
                              isMe ? Colors.white70 : Colors.grey.shade500,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              time,
              style: TextStyleConstants.medium(
                context,
                color: isMe ? Colors.white70 : Colors.grey.shade600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Full-screen image viewer ─────────────────────────────────────────────────

class _FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  const _FullScreenImageViewer({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new_rounded, color: Colors.white),
            tooltip: "Open in browser",
            onPressed: () async {
              final uri = Uri.parse(imageUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
        ],
      ),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Center(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            },
            errorBuilder: (_, __, ___) => const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.broken_image_rounded,
                      color: Colors.white54, size: 48),
                  SizedBox(height: 8),
                  Text("Could not load image",
                      style: TextStyle(color: Colors.white54)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Attachment Preview Sheet ─────────────────────────────────────────────────

class _AttachmentPreviewSheet extends StatelessWidget {
  final AttachmentItem attachment;
  final Color primaryColor;
  final VoidCallback onSend;

  const _AttachmentPreviewSheet({
    required this.attachment,
    required this.primaryColor,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final isImage = attachment.type == AttachmentType.image;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.82,
      margin: const EdgeInsets.only(top: 48),
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              children: [
                Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close_rounded,
                          color: Colors.white70, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        attachment.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white12, height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: isImage
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(attachment.path),
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              )
                  : _LocalFilePreviewCard(attachment: attachment),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: onSend,
                  icon: const Icon(Icons.send_rounded,
                      size: 20, color: Colors.white),
                  label: const Text(
                    "Send",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Local file preview card (before upload) ──────────────────────────────────

class _LocalFilePreviewCard extends StatelessWidget {
  final AttachmentItem attachment;
  const _LocalFilePreviewCard({required this.attachment});

  IconData _iconForExt(String name) {
    final ext = name.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart_rounded;
      case 'doc':
      case 'docx':
        return Icons.article_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Color _colorForExt(String name) {
    final ext = name.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return const Color(0xFFFF453A);
      case 'xls':
      case 'xlsx':
        return const Color(0xFF34C759);
      case 'doc':
      case 'docx':
        return const Color(0xFF0A84FF);
      default:
        return const Color(0xFF8E8E93);
    }
  }

  String _fileSize(String path) {
    try {
      final bytes = File(path).lengthSync();
      if (bytes < 1024) return '$bytes B';
      if (bytes < 1024 * 1024) {
        return '${(bytes / 1024).toStringAsFixed(1)} KB';
      }
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = _colorForExt(attachment.name);
    final size = _fileSize(attachment.path);

    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 88,
              width: 88,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(_iconForExt(attachment.name),
                  color: iconColor, size: 44),
            ),
            const SizedBox(height: 22),
            Text(
              attachment.name,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (size.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(size,
                  style: const TextStyle(color: Colors.white38, fontSize: 13)),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Input bar ────────────────────────────────────────────────────────────────





// Old One =>

/*

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final Color primaryColor;
  final VoidCallback onAttachTap;
  final VoidCallback onSend;

  const _InputBar({
    required this.controller,
    required this.primaryColor,
    required this.onAttachTap,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffF3F5F7),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.black12),
                ),
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  decoration: InputDecoration(
                    hintText: "Type your message...",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 15,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => onSend(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Row(
              children: [
                GestureDetector(
                  onTap: onAttachTap,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xffF3F5F7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Icon(
                      Icons.attach_file_rounded,
                      color: Colors.grey.shade600,
                      size: 22,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){

                  },
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xffF3F5F7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.grey.shade600,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: onSend,
              child: Container(
                height: 48,
                width: 52,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.28),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  //Icons.send_rounded,
                  Icons.keyboard_voice_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

*/


// created by Gopal


class _InputBar extends StatefulWidget {
  final TextEditingController controller;
  final Color primaryColor;
  final VoidCallback onAttachTap;
  final VoidCallback onSend;

  const _InputBar({
    required this.controller,
    required this.primaryColor,
    required this.onAttachTap,
    required this.onSend,
  });

  @override
  State<_InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<_InputBar> with SingleTickerProviderStateMixin {
  bool isTyping = false;

  final SpeechToText _speech = SpeechToText();
  bool _speechAvailable = false;
  bool _isListening = false;
  bool _receivedSpeechThisSession = false;
  bool _speechJustCompleted = false;
  String _textBeforeSpeech = '';
  Timer? _listeningSyncTimer;
  DateTime? _listenUiStartedAt;
  bool _engineWasListeningThisSession = false;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseOpacity;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseOpacity = Tween<double>(begin: 0.45, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    widget.controller.addListener(_handleTyping);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initSpeech());
  }

  void _syncListeningPulse() {
    if (_isListening) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
      _pulseController.value = 1.0;
    }
  }

  /// Native stop (e.g. pause timeout) does not always emit [onStatus]; keep UI in sync.
  void _stopListeningSyncLoop() {
    _listeningSyncTimer?.cancel();
    _listeningSyncTimer = null;
  }

  void _startListeningSyncLoop() {
    _stopListeningSyncLoop();
    _listeningSyncTimer =
        Timer.periodic(const Duration(milliseconds: 200), (_) {
          if (!mounted) {
            _stopListeningSyncLoop();
            return;
          }
          final engineListening = _speech.isListening;
          if (!_isListening || engineListening) return;

          final started = _listenUiStartedAt;
          final gaveUpWaiting = started != null &&
              DateTime.now().difference(started) > const Duration(seconds: 3);
          if (!_engineWasListeningThisSession && !gaveUpWaiting) {
            return;
          }

          setState(() {
            _isListening = false;
            if (_receivedSpeechThisSession) {
              _speechJustCompleted = true;
            }
            _syncListeningPulse();
          });
          _listenUiStartedAt = null;
          _engineWasListeningThisSession = false;
          _stopListeningSyncLoop();
        });
  }

  void _applyListeningFromEngine() {
    final engineListening = _speech.isListening;
    if (engineListening) {
      _engineWasListeningThisSession = true;
    }
    if (_isListening == engineListening) return;
    setState(() {
      _isListening = engineListening;
      if (!engineListening && _receivedSpeechThisSession) {
        _speechJustCompleted = true;
      }
      _syncListeningPulse();
    });
    if (!engineListening) {
      _listenUiStartedAt = null;
      _engineWasListeningThisSession = false;
      _stopListeningSyncLoop();
    }
  }

  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize(
      onError: (e) {
        if (kDebugMode) print('SpeechToText error: ${e.errorMsg}');
        if (mounted) {
          setState(() {
            _isListening = false;
            _syncListeningPulse();
          });
          _stopListeningSyncLoop();
          CommonToast.error('Speech recognition error');
        }
      },
      onStatus: (status) {
        if (!mounted) return;
        _applyListeningFromEngine();
      },
    );
    if (mounted) setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (!mounted) return;
    final words = result.recognizedWords;
    if (words.trim().isNotEmpty) {
      _receivedSpeechThisSession = true;
    }
    final prefix = _textBeforeSpeech;
    final sep = prefix.isNotEmpty && words.trim().isNotEmpty ? ' ' : '';
    final combined = '$prefix$sep$words';
    widget.controller.text = combined;
    widget.controller.selection =
        TextSelection.collapsed(offset: widget.controller.text.length);
    setState(() => isTyping = widget.controller.text.trim().isNotEmpty);
  }

  Future<void> _toggleSpeechToText() async {
    if (!_speechAvailable) {
      CommonToast.error('Speech recognition is not available on this device.');
      return;
    }
    if (_isListening) {
      await _speech.stop();
      if (mounted) {
        setState(() {
          _isListening = false;
          if (_receivedSpeechThisSession) {
            _speechJustCompleted = true;
          }
          _syncListeningPulse();
        });
        _listenUiStartedAt = null;
        _engineWasListeningThisSession = false;
        _stopListeningSyncLoop();
      }
      return;
    }
    _textBeforeSpeech = widget.controller.text;
    _listenUiStartedAt = DateTime.now();
    _engineWasListeningThisSession = false;
    setState(() {
      _isListening = true;
      _receivedSpeechThisSession = false;
      _speechJustCompleted = false;
      _syncListeningPulse();
    });
    _startListeningSyncLoop();
    try {
      await _speech.listen(
        onResult: _onSpeechResult,
        listenOptions: SpeechListenOptions(
          listenMode: ListenMode.dictation,
          partialResults: true,
        ),
        listenFor: const Duration(minutes: 2),
        pauseFor: const Duration(seconds: 5),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isListening = false;
          _syncListeningPulse();
        });
        _listenUiStartedAt = null;
        _engineWasListeningThisSession = false;
        _stopListeningSyncLoop();
        CommonToast.error('Could not start listening.');
      }
    }
  }

  void _handleTyping() {
    final typingNow = widget.controller.text.trim().isNotEmpty;
    final clearSpeechHighlight =
        _speechJustCompleted && widget.controller.text.trim().isEmpty;
    if (typingNow != isTyping || clearSpeechHighlight) {
      setState(() {
        if (typingNow != isTyping) isTyping = typingNow;
        if (clearSpeechHighlight) _speechJustCompleted = false;
      });
    }
  }

  Widget _voiceMicButton() {
    const outer = 40.0;
    if (_isListening) {
      return SizedBox(
        width: outer,
        height: outer,
        child: Icon(
          Icons.voice_chat,
          color: widget.primaryColor,
          size: 22,
        ),
      );
    }
    if (_speechJustCompleted) {
      return SizedBox(
        width: outer,
        height: outer,
        child: Center(
          child: Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.voice_chat,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      );
    }
    return SizedBox(
      width: outer,
      height: outer,
      child: Icon(
        Icons.voice_chat,
        color: Colors.grey.shade600,
        size: 22,
      ),
    );
  }

  @override
  void dispose() {
    _stopListeningSyncLoop();
    _pulseController.dispose();
    widget.controller.removeListener(_handleTyping);
    if (_speech.isListening) {
      _speech.stop();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isListening)
              Padding(
                padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
                child: AnimatedBuilder(
                  animation: _pulseOpacity,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _pulseOpacity.value,
                      child: child,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: widget.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: widget.primaryColor.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.mic_rounded,
                          size: 18,
                          color: widget.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Listening… speak to convert to text',
                            style: TextStyle(
                              color: widget.primaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffF3F5F7),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.black12),
                    ),
                    padding: const EdgeInsets.only(left: 2, right: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [


                        Expanded(
                          child: TextField(
                            controller: widget.controller,
                            minLines: 1,
                            maxLines: 4,
                            textInputAction: TextInputAction.send,
                            decoration: InputDecoration(
                              hintText: "Type your message...",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 15,
                              ),
                              isDense: true,
                              contentPadding: const EdgeInsets.fromLTRB(
                                4,
                                10,
                                12,
                                10,
                              ),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => widget.onSend(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                            ),
                            onPressed: widget.onAttachTap,
                            icon: Icon(
                              Icons.attach_file_rounded,
                              color: Colors.grey.shade600,
                              size: 22,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                            ),
                            onPressed: _toggleSpeechToText,
                            icon: _voiceMicButton(),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // 👇 Mic ↔ Send button
                GestureDetector(
                  onTap: widget.onSend,
                  child: Container(
                    height: 48,
                    width: 52,
                    decoration: BoxDecoration(
                      color: widget.primaryColor,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: widget.primaryColor.withValues(alpha: 0.28),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      isTyping
                          ? Icons.send_rounded
                          : Icons.keyboard_voice_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}





// ─── Attachment option row ────────────────────────────────────────────────────

class _AttachmentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AttachmentOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Date chip ────────────────────────────────────────────────────────────────

class _DateChip extends StatelessWidget {
  final String date;
  const _DateChip({required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.black12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            date,
            style: TextStyleConstants.medium(
              context,
              fontSize: 11,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Date header delegate ─────────────────────────────────────────────────────

class DateHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String date;
  DateHeaderDelegate(this.date);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(date,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ),
    );
  }

  @override
  double get maxExtent => 40;
  @override
  double get minExtent => 40;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

// ─── ChatTopBar ───────────────────────────────────────────────────────────────

class ChatTopBar extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback? onBackTap;
  final VoidCallback? onNotificationTap;
  final bool isOnline;
  final int notificationCount;

  const ChatTopBar({
    super.key,
    required this.name,
    required this.imageUrl,
    this.onBackTap,
    this.onNotificationTap,
    this.isOnline = true,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    String getInitial(String? name) {
      if (name == null || name.trim().isEmpty) return '?';
      return name.trim()[0].toUpperCase();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 18, right: 18, top: 8, bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBackTap,
            behavior: HitTestBehavior.opaque,
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 20, color: Color(0xFF0A2A52)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade300,
                        border: Border.all(color: T.faint, width: 1),
                      ),
                      child: (imageUrl.isEmpty)
                          ? Center(
                        child: Text(
                          getInitial(name),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: T.ink,
                            letterSpacing: 0.5,
                          ),
                        ),
                      )
                          : ClipOval(
                        child: Image.network(
                            "https://www.tradologie.com/docs/$imageUrl",
                            fit: BoxFit.cover),
                      ),
                    ),
                    if (isOnline)
                      Positioned(
                        right: -1,
                        bottom: 2,
                        child: Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6ACB1B),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const Spacer(),
                // IconButton(
                //   onPressed: () {},
                //   icon: const Icon(Icons.call),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
