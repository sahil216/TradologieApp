import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/widgets/common_single_child_scroll_view.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/features/my_account/presentation/cubit/my_account_cubit.dart';

import '../../../../../core/error/network_failure.dart';
import '../../../../../core/error/user_failure.dart';
import '../../../../../core/widgets/common_loader.dart';
import '../../../../../core/widgets/custom_error_network_widget.dart';
import '../../../../../core/widgets/custom_error_widget.dart';

class LegalDocumentsTab extends StatefulWidget {
  const LegalDocumentsTab({super.key});

  @override
  State<LegalDocumentsTab> createState() => _LegalDocumentsTabState();
}

class _LegalDocumentsTabState extends State<LegalDocumentsTab> {
  bool? data = false;

  MyAccountCubit get cubit => BlocProvider.of<MyAccountCubit>(context);

  bool agreeSeller = false;
  bool agreePrivacy = false;
  String? uploadedFile;

  String? sellerFileName;
  String? sellerFileUrl;

  void getLegalDocuments() {}

  @override
  void initState() {
    super.initState();
    getLegalDocuments();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MyAccountCubit, MyAccountState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is LegalDocumentsSuccess) {
              data = state.data;
            }
            if (state is LegalDocumentsError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
        ),
      ],
      child: BlocBuilder<MyAccountCubit, MyAccountState>(
        buildWhen: (previous, current) {
          bool result = previous != current;
          result = result &&
              (current is LegalDocumentsSuccess ||
                  current is LegalDocumentsError ||
                  current is LegalDocumentsIsLoading);
          return result;
        },
        builder: (context, state) {
          if (data == null) {
            if (state is LegalDocumentsError) {
              if (state.failure is NetworkFailure) {
                return CustomErrorNetworkWidget(
                  onPress: () {
                    getLegalDocuments();
                  },
                );
              } else if (state.failure is UserFailure) {
                return CustomErrorWidget(
                  onPress: () {
                    getLegalDocuments();
                  },
                  errorText: state.failure.msg,
                );
              }
            }
            return const CommonLoader();
          }
          return SafeArea(
            child: CommonSingleChildScrollView(
              child: Column(
                children: [
                  _instructionText(),
                  const SizedBox(height: 16),
                  _sellerAgreementCard(),
                  const SizedBox(height: 16),
                  _privacyAgreementCard(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _instructionText() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(fontSize: 13, color: Colors.black87),
        children: [
          TextSpan(
            text: "* ",
            style: TextStyle(color: Colors.red),
          ),
          TextSpan(
            text:
                "Please download & print the Seller agreement and fill all the details. "
                "Kindly sign & upload the filled agreement for our reference.",
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Seller Agreement Card
  Widget _sellerAgreementCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cardHeader(
              title: "Seller Agreement",
              onDownload: () {},
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("I Agree Seller Agreement"),
              value: agreeSeller,
              onChanged: (value) {
                setState(() => agreeSeller = value ?? false);
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.upload_file),
                    label: const Text("Upload Signed Agreement"),
                    onPressed: () {
                      setState(() {
                        sellerFileName = "seller_agreement.pdf";
                        sellerFileUrl =
                            "https://example.com/seller_agreement.pdf";
                      });
                    },
                  ),
                ),
                if (sellerFileName != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: "View document",
                    icon: const Icon(Icons.visibility),
                    onPressed: () {
                      _viewDocument(
                        context,
                        sellerFileName!,
                        sellerFileUrl,
                      );
                    },
                  ),
                ]
              ],
            ),
            if (sellerFileName != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  sellerFileName!,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Privacy Agreement Card
  Widget _privacyAgreementCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cardHeader(
              title: "Privacy Agreement",
              onDownload: () {},
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Accept Privacy Agreement"),
              value: agreePrivacy,
              onChanged: (value) {
                setState(() => agreePrivacy = value ?? false);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Card Header
  Widget _cardHeader({
    required String title,
    required VoidCallback onDownload,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        TextButton.icon(
          onPressed: onDownload,
          icon: const Icon(Icons.download, size: 18),
          label: const Text("Download"),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // View Document Bottom Sheet
  void _viewDocument(
    BuildContext context,
    String fileName,
    String? fileUrl,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  fileName,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Divider(height: 1),
              const Expanded(
                child: Center(
                  child: Text(
                    "PDF / Image Preview Here",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // // ---------------------------------------------------------------------------
  // bool _canSubmit() {
  //   return agreeSeller && agreePrivacy && sellerFileName != null;
  // }

  // void _submit() {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text("Legal documents submitted")),
  //   );
  // }
}
