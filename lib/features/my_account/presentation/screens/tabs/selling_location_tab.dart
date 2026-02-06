import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/features/my_account/presentation/cubit/my_account_cubit.dart';

import '../../../../../core/error/network_failure.dart';
import '../../../../../core/error/user_failure.dart';
import '../../../../../core/widgets/common_loader.dart';
import '../../../../../core/widgets/custom_error_network_widget.dart';
import '../../../../../core/widgets/custom_error_widget.dart';

class SellingLocationTab extends StatefulWidget {
  const SellingLocationTab({super.key});

  @override
  State<SellingLocationTab> createState() => _SellingLocationTabState();
}

class _SellingLocationTabState extends State<SellingLocationTab> {
  bool? data = false;

  MyAccountCubit get cubit => BlocProvider.of<MyAccountCubit>(context);

  void getSellingLocation() {}

  @override
  void initState() {
    super.initState();
    getSellingLocation();
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
            if (state is SellingLocationSuccess) {
              data = state.data;
            }
            if (state is SellingLocationError) {
              Constants.showFailureToast(state.failure);
            }
          },
        ),
      ],
      child: BlocBuilder<MyAccountCubit, MyAccountState>(
        buildWhen: (previous, current) {
          bool result = previous != current;
          result = result &&
              (current is SellingLocationSuccess ||
                  current is SellingLocationError ||
                  current is SellingLocationIsLoading);
          return result;
        },
        builder: (context, state) {
          if (data == null) {
            if (state is SellingLocationError) {
              if (state.failure is NetworkFailure) {
                return CustomErrorNetworkWidget(
                  onPress: () {
                    getSellingLocation();
                  },
                );
              } else if (state.failure is UserFailure) {
                return CustomErrorWidget(
                  onPress: () {
                    getSellingLocation();
                  },
                  errorText: state.failure.msg,
                );
              }
            }
            return const CommonLoader();
          }
          return SafeArea(
            child: Column(
              children: [],
            ),
          );
        },
      ),
    );
  }
}
