import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chatbot_tran_message.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_chatbot_tran_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/presentation/cubit/chat_cubit.dart';

class ChatbotTranScreenArgs {
  final int chatMainId;
  final String contactName;

  const ChatbotTranScreenArgs({
    required this.chatMainId,
    required this.contactName,
  });
}

/// Light-theme chat history for a single Chatbot query (ChatbotTranList API).
class ChatbotTranScreen extends StatefulWidget {
  final ChatbotTranScreenArgs args;

  const ChatbotTranScreen({super.key, required this.args});

  @override
  State<ChatbotTranScreen> createState() => _ChatbotTranScreenState();
}

class _ChatbotTranScreenState extends State<ChatbotTranScreen> {
  final ScrollController _scrollController = ScrollController();
  final SecureStorageService _secureStorage = SecureStorageService();

  static const _bg = Color(0xFFFFFFFF);
  static const _surfaceMuted = Color(0xFFF3F4F6);
  static const _headerIcon = Color(0xFF111827);
  static const _bodyTextMuted = Color(0xFF6B7280);
  static const _aiBubbleColor = Color(0xFF1A4A7A);
  static const _aiAvatarBg = Color(0xFF0D2840);
  static const _pillBorder = Color(0xFF1E88E5);
  static const _pillText = Color(0xFF1565C0);
  static const _pillFill = Color(0xFFE3F2FD);
  static const _formOuterBorder = Color(0xFF90CAF9);
  static const _formOuterFill = Color(0xFFF5FAFF);
  static const _primaryProgress = Color(0xFF1E88E5);
  static const _userAvatarBg = Color(0xFF1E88E5);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final token =
        await _secureStorage.read(AppStrings.apiVerificationCode) ?? '';
    if (!mounted) return;
    context.read<ChatCubit>().getChatbotTranList(
          ChatbotTranListParams(
            token: token,
            deviceId: Constants.deviceID,
            chatMainId: widget.args.chatMainId,
          ),
        );
  }

  static String _cleanText(String raw) {
    return raw
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll('&quot;', '"')
        .replaceAll('\r\n', '\n')
        .trim();
  }

  /// API [ResponseText] may mix plain text with HTML (e.g. follow-up option divs).
  static final RegExp _htmlTagPattern = RegExp(r'<[a-zA-Z][^>]*>');

  static bool _responseContainsHtml(String raw) =>
      _htmlTagPattern.hasMatch(raw);

  /// Wrap fragment in a document so the `html` parser accepts leading text nodes.
  static String _htmlDocumentFromResponse(String raw) {
    final normalized = raw
        .replaceAll('\r\n', '\n')
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '<br/>')
        .replaceAll('\n', '<br/>');
    return '<!DOCTYPE html><html><head><meta charset="UTF-8"></head>'
        '<body>$normalized</body></html>';
  }

  static Map<String, dynamic>? _parseFormJson(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          SizedBox(height: top),
          _buildHeader(context),
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              listenWhen: (p, c) =>
                  c is ChatbotTranListSuccess ||
                  c is ChatbotTranListError ||
                  c is ChatbotTranListLoading,
              listener: (context, state) {
                if (state is ChatbotTranListError) {
                  CommonToast.showFailureToast(state.failure);
                }
                if (state is ChatbotTranListSuccess) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  });
                }
              },
              buildWhen: (p, c) =>
                  c is ChatbotTranListLoading ||
                  c is ChatbotTranListSuccess ||
                  c is ChatbotTranListError,
              builder: (context, state) {
                if (state is ChatbotTranListLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: _primaryProgress,
                    ),
                  );
                }
                if (state is ChatbotTranListSuccess) {
                  final msgs = state.messages;
                  if (msgs.isEmpty) {
                    return Center(
                      child: Text(
                        'No messages',
                        style: GoogleFonts.dmSans(
                          color: _bodyTextMuted,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
                    itemCount: msgs.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildRow(msgs[i]),
                      );
                    },
                  );
                }
                return Center(
                  child: Text(
                    'Unable to load',
                    style: GoogleFonts.dmSans(
                      color: _bodyTextMuted,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: _headerIcon,
              size: 22,
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFF1E88E5),
                child: Text(
                  widget.args.contactName.isNotEmpty
                      ? widget.args.contactName[0].toUpperCase()
                      : '?',
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E),
                    shape: BoxShape.circle,
                    border: Border.all(color: _bg, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.args.contactName,
              style: GoogleFonts.dmSans(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(ChatbotTranMessage m) {
    final type = m.msgType.toLowerCase();

    if (type == 'welcomeoption' || type == 'inneroption') {
      return Align(
        alignment: Alignment.centerLeft,
        child: _optionPill(_cleanText(m.responseText)),
      );
    }

    if (type == 'formsubmit') {
      final form = _parseFormJson(m.responseText);
      if (form != null) {
        return Align(
          alignment: Alignment.centerRight,
          child: _userBubbleWithForm(form, m.userName),
        );
      }
      return Align(
        alignment: Alignment.centerRight,
        child: _userBubbleText(_cleanText(m.responseText), m.userName),
      );
    }

    if (m.isAi) {
      return _buildAiBubble(m.responseText);
    }

    return Align(
      alignment: Alignment.centerRight,
      child: _userBubbleText(_cleanText(m.responseText), m.userName),
    );
  }

  Widget _aiAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: _aiAvatarBg,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        'T',
        style: GoogleFonts.dmSans(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _userAvatar(String userName) {
    final n = userName.trim();
    final initial =
        n.isEmpty ? '?' : n.characters.first.toUpperCase();
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: _userAvatarBg,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: GoogleFonts.dmSans(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildAiBubble(String responseText) {
    final useHtml = _responseContainsHtml(responseText);
    final plain = _cleanText(responseText);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _aiAvatar(),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            decoration: BoxDecoration(
              color: _aiBubbleColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: useHtml
                ? Html(
                    data: _htmlDocumentFromResponse(responseText),
                    shrinkWrap: true,
                    style: {
                      'body': Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        color: Colors.white,
                        fontSize: FontSize(15),
                        lineHeight: const LineHeight(1.35),
                        fontFamily: GoogleFonts.dmSans().fontFamily,
                      ),
                      'div': Style(
                        margin: Margins.only(bottom: 4),
                        display: Display.block,
                      ),
                      'p': Style(
                        margin: Margins.zero,
                        display: Display.block,
                      ),
                    },
                    extensions: [
                      MatcherExtension(
                        matcher: (ctx) =>
                            ctx.elementName == 'p' &&
                            ctx.classes.contains('AiOption'),
                        builder: (ctx) {
                          final t = ctx.element?.text.trim() ?? '';
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      Colors.white.withValues(alpha: 0.35),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                child: Text(
                                  t,
                                  style: GoogleFonts.dmSans(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                : Text(
                    plain,
                    style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.35,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _userBubbleText(String text, String userName) {
    final w = MediaQuery.sizeOf(context).width;
    final maxBubble = (w * 0.82 - 40).clamp(120.0, w * 0.82);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxBubble),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            decoration: BoxDecoration(
              color: _surfaceMuted,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: Text(
              text,
              style: GoogleFonts.dmSans(
                color: const Color(0xFF111827),
                fontSize: 15,
                height: 1.35,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        _userAvatar(userName),
      ],
    );
  }

  Widget _userBubbleWithForm(Map<String, dynamic> form, String userName) {
    final name = form['Name']?.toString() ?? '';
    final email = form['Email']?.toString() ?? '';
    final mobile = form['Mobile']?.toString() ?? '';
    final country = form['CountryCode']?.toString() ?? '';

    final w = MediaQuery.sizeOf(context).width;
    final maxCard = (w * 0.88 - 40).clamp(160.0, w * 0.88);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxCard),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _formOuterFill,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _formOuterBorder, width: 1.2),
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _formPair('Name', name),
                        if (mobile.isNotEmpty) _formPair('Mobile', mobile),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _formPair('Email', email),
                        if (country.isNotEmpty) _formPair('Country', country),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        _userAvatar(userName),
      ],
    );
  }

  Widget _formPair(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value.isEmpty ? '—' : value,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _pillBorder, width: 1.2),
        color: _pillFill,
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          color: _pillText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
