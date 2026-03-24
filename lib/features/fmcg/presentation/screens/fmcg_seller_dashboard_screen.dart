import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/extensions.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/app/injection_container_app.dart';
import 'package:tradologie_app/features/app/presentation/screens/main_screen.dart';
import 'package:tradologie_app/features/contact_us/coming_soon_screen.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/distributor_enquiry_list.dart';
import 'package:tradologie_app/features/fmcg/presentation/cubit/chat_cubit.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/fmcg_distributor_enq.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/fmcg_main_screen.dart';

class FmcgSellerDashboardScreen extends StatefulWidget {
  const FmcgSellerDashboardScreen({super.key});

  @override
  State<FmcgSellerDashboardScreen> createState() =>
      _FmcgSellerDashboardScreenState();
}

class _FmcgSellerDashboardScreenState extends State<FmcgSellerDashboardScreen>
    with SingleTickerProviderStateMixin {
  List<DistributorEnquiryList>? distributorList;

  int? open;

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
                      ),
                      // EnquiryTabsSliver(
                      //   selected: tab,
                      //   onSelect: (i) {
                      //     setState(() {
                      //       tab = i;
                      //       open = null;
                      //     });
                      //   },
                      // ),

                      // List
                      EnquiryListSliver(
                        items: distributorList ?? [],
                        openIndex: open,
                        onToggle: (i) {
                          setState(() {
                            open = open == i ? null : i;
                          });
                        },
                      ),

                      /// Chat List
                      // SliverPadding(
                      //   padding: const EdgeInsets.all(16),
                      //   sliver: SliverList(
                      //     delegate: SliverChildBuilderDelegate(
                      //       (context, index) {
                      //         final item = distributorList?[index];
                      //         final expanded = expandedIndex == index;

                      //         return Padding(
                      //           padding:
                      //               const EdgeInsets.only(bottom: 16),
                      //           child: GestureDetector(
                      //             onTap: () => toggle(index),
                      //             child: AnimatedContainer(
                      //               duration:
                      //                   const Duration(milliseconds: 250),
                      //               padding: const EdgeInsets.all(18),
                      //               decoration: BoxDecoration(
                      //                 color: Colors.white,
                      //                 borderRadius:
                      //                     BorderRadius.circular(18),
                      //                 boxShadow: [
                      //                   BoxShadow(
                      //                     blurRadius: 20,
                      //                     color: Colors.black
                      //                         .withOpacity(0.08),
                      //                     offset: const Offset(0, 10),
                      //                   )
                      //                 ],
                      //               ),
                      //               child: Column(
                      //                 children: [
                      //                   /// HEADER
                      //                   Row(
                      //                     children: [
                      //                       Expanded(
                      //                         child: Text(
                      //                           "${(Constants().hideSensitiveData ?? true) ? Constants().maskName(item?.companyName ?? "") : (item?.companyName ?? "")} | ${item?.perferredLocation ?? ""} | ${item?.interestedBrandName ?? ""}",
                      //                           style: const TextStyle(
                      //                             fontSize: 16,
                      //                             fontWeight:
                      //                                 FontWeight.w600,
                      //                           ),
                      //                         ),
                      //                       ),
                      //                       AnimatedRotation(
                      //                         turns: expanded ? 0.5 : 0,
                      //                         duration: const Duration(
                      //                             milliseconds: 250),
                      //                         child: const Icon(Icons
                      //                             .keyboard_arrow_down),
                      //                       )
                      //                     ],
                      //                   ),

                      //                   /// EXPANDABLE AREA
                      //                   AnimatedSize(
                      //                     duration: const Duration(
                      //                         milliseconds: 250),
                      //                     child: expanded
                      //                         ? Padding(
                      //                             padding:
                      //                                 const EdgeInsets
                      //                                     .only(top: 18),
                      //                             child: Column(
                      //                               crossAxisAlignment:
                      //                                   CrossAxisAlignment
                      //                                       .start,
                      //                               children: [
                      //                                 Row(
                      //                                   children: [
                      //                                     Text(
                      //                                       (Constants().hideSensitiveData ??
                      //                                               true)
                      //                                           ? Constants().maskName(
                      //                                               item?.name ??
                      //                                                   "")
                      //                                           : (item?.name ??
                      //                                               ""),
                      //                                       style:
                      //                                           const TextStyle(
                      //                                         fontSize:
                      //                                             16,
                      //                                         fontWeight:
                      //                                             FontWeight
                      //                                                 .w500,
                      //                                       ),
                      //                                     ),
                      //                                     const Spacer(),
                      //                                     Text(
                      //                                       "${item?.countryCode ?? ""} - ${(Constants().hideSensitiveData ?? true) ? Constants().maskPhone(item?.mobile ?? "") : (item?.mobile ?? "")}",
                      //                                       style:
                      //                                           const TextStyle(
                      //                                         fontSize:
                      //                                             16,
                      //                                         fontWeight:
                      //                                             FontWeight
                      //                                                 .w500,
                      //                                       ),
                      //                                     ),
                      //                                   ],
                      //                                 ),
                      //                                 const SizedBox(
                      //                                     height: 10),
                      //                                 Text(
                      //                                   (Constants().hideSensitiveData ??
                      //                                           true)
                      //                                       ? Constants()
                      //                                           .maskEmail(
                      //                                               item?.email ??
                      //                                                   "")
                      //                                       : (item?.email ??
                      //                                           ""),
                      //                                   style:
                      //                                       const TextStyle(
                      //                                     fontSize: 16,
                      //                                     fontWeight:
                      //                                         FontWeight
                      //                                             .w500,
                      //                                   ),
                      //                                 ),
                      //                                 const SizedBox(
                      //                                     height: 10),
                      //                                 Text(
                      //                                   (item?.interestedBrandName)
                      //                                       .toString(),
                      //                                   style:
                      //                                       const TextStyle(
                      //                                     fontSize: 16,
                      //                                     fontWeight:
                      //                                         FontWeight
                      //                                             .w500,
                      //                                   ),
                      //                                 )
                      //                               ],
                      //                             ),
                      //                           )
                      //                         : const SizedBox(),
                      //                   )
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //       childCount: distributorList?.length ?? 0,
                      //     ),
                      //   ),
                      // ),
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
            // CommonFMCGFloatingNavBar(
            //   index: navIndex,
            //   onTap: (i) {
            //     setState(() {
            //       navIndex = i;
            //     });
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

class EnquiryTabsSliver extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;

  const EnquiryTabsSliver({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  static const _labels = ['All', 'New', 'In review', 'Contacted'];

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 36,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: _labels.length,
          itemBuilder: (_, i) => GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 24),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: i == selected ? T.blue : Colors.transparent,
                    width: 1.5,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  _labels[i],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        i == selected ? FontWeight.w600 : FontWeight.w400,
                    color: i == selected ? T.blue : T.muted,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EnquiryListSliver extends StatelessWidget {
  final List<DistributorEnquiryList> items;
  final int? openIndex;
  final ValueChanged<int> onToggle;

  const EnquiryListSliver({
    super.key,
    required this.items,
    required this.openIndex,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: Text('Nothing here yet', style: T.body)),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) {
          return Column(
            children: [
              _Row(
                enquiry: items[i],
                index: i,
                isOpen: openIndex == i,
                onTap: () => onToggle(i),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Divider(
                  height: 0,
                  thickness: 0.5,
                  color: T.faint,
                ),
              ),
            ],
          );
        },
        childCount: items.length,
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final DistributorEnquiryList enquiry;
  final int index;
  final bool isOpen;
  final VoidCallback onTap;

  const _Row({
    required this.enquiry,
    required this.index,
    required this.isOpen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String getInitial(String? name) {
      if (name == null || name.trim().isEmpty) {
        return '?'; // fallback icon letter
      }
      return name.trim()[0].toUpperCase();
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Collapsed row ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                // Monogram — just text on white, framed by a very faint ring
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: T.faint, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      getInitial(enquiry.interestedBrandName),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: T.ink,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(enquiry.interestedBrandName ?? "",
                                style: T.title,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Expanded(
                            child: Text(enquiry.perferredLocation ?? "",
                                style: T.body, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Chevron
                AnimatedRotation(
                  turns: isOpen ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child:
                      const Icon(Icons.chevron_right, size: 16, color: T.muted),
                ),
              ],
            ),
          ),

          // ── Expanded detail ──────────────────────────────────────────────
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            child: isOpen ? _Detail(enquiry: enquiry) : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  final DistributorEnquiryList enquiry;
  const _Detail({required this.enquiry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Contact fields ──────────────────────────────────────────────
          if (enquiry.mobile != null) ...[
            _Field(
              label: 'Name',
              value: (Constants().hideSensitiveData ?? true)
                  ? Constants().maskName(enquiry.name ?? "")
                  : (enquiry.name ?? ""),
            ),
            const SizedBox(height: 12),
          ],
          if (enquiry.mobile != null) ...[
            _Field(
              label: 'Phone',
              value:
                  "${enquiry.countryCode ?? ""} - ${(Constants().hideSensitiveData ?? true) ? Constants().maskPhone(enquiry.mobile ?? "") : (enquiry.mobile ?? "")}",
              valueStyle: T.mono,
            ),
            const SizedBox(height: 12),
          ],
          if (enquiry.email != null) ...[
            _Field(
              label: 'Email',
              value: (Constants().hideSensitiveData ?? true)
                  ? Constants().maskEmail(enquiry.email ?? "")
                  : (enquiry.email ?? ""),
              valueStyle: T.mono,
            ),
            const SizedBox(height: 12),
          ],
          _Field(label: 'Location', value: enquiry.perferredLocation ?? ""),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;
  const _Field({required this.label, required this.value, this.valueStyle});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 64,
          child: Text(label, style: T.caption.copyWith(letterSpacing: 0)),
        ),
        Expanded(
          child:
              Text(value, style: valueStyle ?? T.body.copyWith(color: T.ink)),
        ),
      ],
    );
  }
}
