import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/features/my_account/presentation/cubit/my_account_cubit.dart';

import '../../../../../core/error/network_failure.dart';
import '../../../../../core/error/user_failure.dart';
import '../../../../../core/widgets/common_loader.dart';
import '../../../../../core/widgets/custom_error_network_widget.dart';
import '../../../../../core/widgets/custom_error_widget.dart';

class DocumentItem {
  final String title;
  String? description;
  String? fileName;

  DocumentItem(this.title);
}

class DocumentsTab extends StatefulWidget {
  const DocumentsTab({super.key});

  @override
  State<DocumentsTab> createState() => _DocumentsTabState();
}

class _DocumentsTabState extends State<DocumentsTab> {
  bool? data = false;

  MyAccountCubit get cubit => BlocProvider.of<MyAccountCubit>(context);

  void getDocuments() {}

  @override
  void initState() {
    super.initState();
    getDocuments();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<DocumentItem> documents = [
    DocumentItem("Registration Certificate of Company"),
    DocumentItem("PAN No / Company Registration Proof"),
    DocumentItem("Import / Export License / Permission Certificate"),
    DocumentItem("Memorandum of Association (MOA)"),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MyAccountCubit, MyAccountState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is DocumentsSuccess) {
              data = state.data;
            }
            if (state is DocumentsError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
        ),
      ],
      child: BlocBuilder<MyAccountCubit, MyAccountState>(
        buildWhen: (previous, current) {
          bool result = previous != current;
          result = result &&
              (current is DocumentsSuccess ||
                  current is DocumentsError ||
                  current is DocumentsIsLoading);
          return result;
        },
        builder: (context, state) {
          if (data == null) {
            if (state is DocumentsError) {
              if (state.failure is NetworkFailure) {
                return CustomErrorNetworkWidget(
                  onPress: () {
                    getDocuments();
                  },
                );
              } else if (state.failure is UserFailure) {
                return CustomErrorWidget(
                  onPress: () {
                    getDocuments();
                  },
                  errorText: state.failure.msg,
                );
              }
            }
            return const CommonLoader();
          }
          return SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                return _documentCard(documents[index], index);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _documentCard(DocumentItem doc, int index) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doc.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: "Description",
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (value) => doc.description = value,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.upload_file, size: 18),
                  label: const Text("Upload"),
                  onPressed: () {
                    setState(() {
                      doc.fileName = "sample_document.pdf";
                    });
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    doc.fileName ?? "No file selected",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
