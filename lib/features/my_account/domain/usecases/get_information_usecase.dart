import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/get_information_detail.dart';
import '../repositories/my_account_repository.dart';

class GetInformationUsecase implements UseCase<GetInformationDetail, NoParams> {
  final MyAccountRepository myAccountRepository;

  GetInformationUsecase({required this.myAccountRepository});
  @override
  Future<Either<Failure, GetInformationDetail>> call(NoParams params) =>
      myAccountRepository.getInformation(params);
}
