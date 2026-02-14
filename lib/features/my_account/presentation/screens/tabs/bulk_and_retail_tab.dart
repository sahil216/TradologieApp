import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/features/my_account/presentation/cubit/my_account_cubit.dart';

import '../../../../../core/error/network_failure.dart';
import '../../../../../core/error/user_failure.dart';
import '../../../../../core/widgets/common_loader.dart';
import '../../../../../core/widgets/custom_error_network_widget.dart';
import '../../../../../core/widgets/custom_error_widget.dart';

class BulkAndRetailTab extends StatefulWidget {
  const BulkAndRetailTab({super.key});

  @override
  State<BulkAndRetailTab> createState() => _BulkAndRetailTabState();
}

class _BulkAndRetailTabState extends State<BulkAndRetailTab> {
  bool? data = false;

  MyAccountCubit get cubit => BlocProvider.of<MyAccountCubit>(context);

  void getBulkRetail() {}

  @override
  void initState() {
    super.initState();
    getBulkRetail();
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
            if (state is BulkRetailSuccess) {
              data = state.data;
            }
            if (state is BulkRetailError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
        ),
      ],
      child: BlocBuilder<MyAccountCubit, MyAccountState>(
        buildWhen: (previous, current) {
          bool result = previous != current;
          result = result &&
              (current is BulkRetailSuccess ||
                  current is BulkRetailError ||
                  current is BulkRetailIsLoading);
          return result;
        },
        builder: (context, state) {
          if (data == null) {
            if (state is BulkRetailError) {
              if (state.failure is NetworkFailure) {
                return CustomErrorNetworkWidget(
                  onPress: () {
                    getBulkRetail();
                  },
                );
              } else if (state.failure is UserFailure) {
                return CustomErrorWidget(
                  onPress: () {
                    getBulkRetail();
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
