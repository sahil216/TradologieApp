import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/features/app/injection_container_app.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/distributor_enquiry_list.dart';
import 'package:tradologie_app/features/fmcg/presentation/cubit/chat_cubit.dart';

class FmcgSellerDashboardScreen extends StatefulWidget {
  const FmcgSellerDashboardScreen({super.key});

  @override
  State<FmcgSellerDashboardScreen> createState() =>
      _FmcgSellerDashboardScreenState();
}

class _FmcgSellerDashboardScreenState extends State<FmcgSellerDashboardScreen>
    with SingleTickerProviderStateMixin {
  List<DistributorEnquiryList>? distributorList;

  ChatCubit get chatCubit => BlocProvider.of(context);
  SecureStorageService secureStorage = SecureStorageService();

  void getDistributorList() async {
    await chatCubit.getDistributorList(NoParams());
  }

  @override
  void initState() {
    super.initState();
    getDistributorList();
  }

  Future<void> _refreshChats() async {
    getDistributorList(); // your API call
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
            distributorList = state.data;
          }
          if (state is DistributorListError) {
            CommonToast.showFailureToast(state.failure);
          }
        },
        child: Stack(
          children: [
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                return RefreshIndicator(
                  onRefresh: _refreshChats,
                  child: CustomScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    slivers: [
                      /// App Bar
                      CommonAppbar(
                        title: "Distributorship Enquiries",
                        showBackButton: false,
                        showNotification: false,
                        showSuffixIcon: true,
                        suffixIcon: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  CommonToast.success(
                                      "Signed Out Successfully");
                                  Constants.isLogin = false;
                                  Constants.isBuyer = false;
                                  Constants.isFmcg = false;

                                  SecureStorageService secureStorage =
                                      SecureStorageService();
                                  secureStorage.delete(AppStrings.isBuyer);
                                  Constants.token = "";

                                  secureStorage
                                      .delete(AppStrings.apiVerificationCode);
                                  secureStorage.write(
                                      AppStrings.appSession, false.toString());

                                  sl<NavigationService>()
                                      .pushNamedAndRemoveUntil(
                                    Routes.onboardingRoute,
                                  );
                                },
                                icon: Icon(Icons.logout, color: Colors.red)),
                          ],
                        ),
                      ),

                      /// Chat List
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final item = distributorList?[index];
                              final expanded = expandedIndex == index;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: GestureDetector(
                                  onTap: () => toggle(index),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 20,
                                          color: Colors.black
                                              .withValues(alpha: 0.08),
                                          offset: const Offset(0, 10),
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        /// HEADER
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "${(Constants().hideSensitiveData ?? true) ? Constants().maskName(item?.companyName ?? "") : (item?.companyName ?? "")} | ${item?.perferredLocation ?? ""}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            AnimatedRotation(
                                              turns: expanded ? 0.5 : 0,
                                              duration: const Duration(
                                                  milliseconds: 250),
                                              child: const Icon(
                                                  Icons.keyboard_arrow_down),
                                            )
                                          ],
                                        ),

                                        /// EXPANDABLE AREA
                                        AnimatedSize(
                                          duration:
                                              const Duration(milliseconds: 250),
                                          child: expanded
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 18),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            (Constants().hideSensitiveData ??
                                                                    true)
                                                                ? Constants()
                                                                    .maskName(
                                                                        item?.name ??
                                                                            "")
                                                                : (item?.name ??
                                                                    ""),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          Text(
                                                            "${item?.countryCode ?? ""} - ${(Constants().hideSensitiveData ?? true) ? Constants().maskPhone(item?.mobile ?? "") : (item?.mobile ?? "")}",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Text(
                                                        (Constants().hideSensitiveData ??
                                                                true)
                                                            ? Constants()
                                                                .maskEmail(
                                                                    item?.email ??
                                                                        "")
                                                            : (item?.email ??
                                                                ""),
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Text(
                                                        (item?.updatedDate)
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : const SizedBox(),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: distributorList?.length ?? 0,
                          ),
                        ),
                      ),
                    ],
                  ),
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
