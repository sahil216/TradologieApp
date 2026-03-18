import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_button.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/core/widgets/custom_text_field.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_country_code_list.dart';
import 'package:tradologie_app/features/fmcg/presentation/cubit/chat_cubit.dart';
import 'package:tradologie_app/features/fmcg/presentation/widgets/common_file_picker.dart';

import '../../../../../core/widgets/common_drop_down.dart';

class FmcgDocumentsScreen extends StatefulWidget {
  const FmcgDocumentsScreen({super.key});

  @override
  State<FmcgDocumentsScreen> createState() => _FmcgDocumentsScreenState();
}

class _FmcgDocumentsScreenState extends State<FmcgDocumentsScreen>
    with SingleTickerProviderStateMixin {
  ChatCubit get chatCubit => BlocProvider.of(context);
  SecureStorageService secureStorage = SecureStorageService();

  final showPassword = ValueNotifier(false);
  final formKey = GlobalKey<FormState>();

  final fields = [
    {
      "title": "Business Registration Certificate",
      "types": ["pdf", "jpg", "png"]
    },
    {
      "title": "Import/Export License",
      "types": ["pdf"]
    },
    {
      "title": "Tax Registration (GST/VAT)",
      "types": ["pdf", "jpg"]
    },
    {
      "title": "Company Profile",
      "types": ["pdf", "doc", "docx"]
    },
  ];

  bool isSubmitted = false;

  void getDistributorList() async {
    await chatCubit.getDistributorList(NoParams());
  }

  @override
  void initState() {
    super.initState();
    getDistributorList();
  }

  void toggle(int index) {
    setState(() {
      if (expandedIndex == index) {
        expandedIndex = null;
      } else {
        expandedIndex = index;
      }
    });
  }

  int? expandedIndex;

  int navIndex = 0;
  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      body: BlocListener<ChatCubit, ChatState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) async {
          if (state is DistributorListSuccess) {
            // distributorList = state.data;
          }
          if (state is DistributorListError) {
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
                            final field = fields[index];

                            return PremiumDocumentPicker(
                              title: field["title"] as String,
                              allowedExtensions: field["types"] as List<String>,
                              onFileSelected: (file) {
                                debugPrint(
                                    "${field["title"]} -> ${file?.path}");
                              },
                            );
                          },
                          childCount: fields.length,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is DistributorListIsLoading) {
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
