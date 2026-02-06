import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/features/my_account/presentation/cubit/my_account_cubit.dart';

import '../../../../../core/error/network_failure.dart';
import '../../../../../core/error/user_failure.dart';
import '../../../../../core/widgets/common_loader.dart';
import '../../../../../core/widgets/custom_error_network_widget.dart';
import '../../../../../core/widgets/custom_error_widget.dart';

class AuthorizedPersonTab extends StatefulWidget {
  const AuthorizedPersonTab({super.key});

  @override
  State<AuthorizedPersonTab> createState() => _AuthorizedPersonTabState();
}

class _AuthorizedPersonTabState extends State<AuthorizedPersonTab> {
  bool? data = false;

  MyAccountCubit get cubit => BlocProvider.of<MyAccountCubit>(context);

  void getAuthorizedPerson() {}

  @override
  void initState() {
    super.initState();
    getAuthorizedPerson();
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
            if (state is AuthorizedPersonSuccess) {
              data = state.data;
            }
            if (state is AuthorizedPersonError) {
              Constants.showFailureToast(state.failure);
            }
          },
        ),
      ],
      child: BlocBuilder<MyAccountCubit, MyAccountState>(
        buildWhen: (previous, current) {
          bool result = previous != current;
          result = result &&
              (current is AuthorizedPersonSuccess ||
                  current is AuthorizedPersonError ||
                  current is AuthorizedPersonIsLoading);
          return result;
        },
        builder: (context, state) {
          if (data == null) {
            if (state is AuthorizedPersonError) {
              if (state.failure is NetworkFailure) {
                return CustomErrorNetworkWidget(
                  onPress: () {
                    getAuthorizedPerson();
                  },
                );
              } else if (state.failure is UserFailure) {
                return CustomErrorWidget(
                  onPress: () {
                    getAuthorizedPerson();
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
