import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_seller_document_detail.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_seller_document_list.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_seller_document_type.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_seller_documents_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/update_seller_documents_usecase.dart';
import 'package:tradologie_app/features/fmcg/presentation/cubit/chat_cubit.dart';
import 'package:tradologie_app/features/fmcg/presentation/widgets/common_file_picker.dart';

class FmcgDocumentsScreen extends StatefulWidget {
  const FmcgDocumentsScreen({super.key});

  @override
  State<FmcgDocumentsScreen> createState() => _FmcgDocumentsScreenState();
}

class _FmcgDocumentsScreenState extends State<FmcgDocumentsScreen>
    with SingleTickerProviderStateMixin {
  ChatCubit get chatCubit => BlocProvider.of(context);
  SecureStorageService secureStorage = SecureStorageService();

  FmcgSellerDocumentDetail? data;

  bool isSubmitted = false;

  void getDocuments() async {
    GetSellerDocumentsParams params = GetSellerDocumentsParams(
        token: await secureStorage.read(AppStrings.apiVerificationCode) ?? '',
        loginID: await secureStorage.read(AppStrings.loginId) ?? '',
        deviceID: Constants.deviceID);
    await chatCubit.getSellerDocuments(params);
  }

  @override
  void initState() {
    super.initState();
    getDocuments();
  }

  late UpdateSellerDocumentsParams params;

  int? expandedIndex;

  int navIndex = 0;
  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      body: BlocListener<ChatCubit, ChatState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) async {
          if (state is GetSellerDocumentsSuccess) {
            data = state.data;
          }
          if (state is GetSellerDocumentsError) {
            CommonToast.showFailureToast(state.failure);
          }
        },
        child: Stack(
          children: [
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                return CustomScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            var field = data?.fmcgSellerDocumentType?[index] ??
                                FmcgSellerDocumentType();
                            FmcgSellerDocumentList? doc;

                            try {
                              doc = data?.fmcgSellerDocument?.firstWhere((d) =>
                                  d.documentTypeId == field.documentTypeId);
                            } catch (e) {
                              doc = null;
                            }

                            return PremiumDocumentPicker(
                              title: field.documentName ?? "",
                              allowedExtensions: ["pdf", "jpg", "png"],
                              initialFileUrl: doc?.document,
                              onFileSelected: (file) async {
                                params = UpdateSellerDocumentsParams(
                                    token: await secureStorage.read(
                                            AppStrings.apiVerificationCode) ??
                                        "",
                                    loginID: await secureStorage
                                            .read(AppStrings.loginId) ??
                                        "",
                                    document: file,
                                    documentTypeId:
                                        field.documentTypeId.toString(),
                                    description: '');
                              },
                              upload: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      chatCubit.updateSellerDocuments(params);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                    ),
                                    child: const Text("Upload"),
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: data?.fmcgSellerDocumentType?.length,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is GetSellerDocumentsIsLoading ||
                    state is UpdateSellerDocumentsIsLoading) {
                  return Positioned.fill(child: const CommonLoader());
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
