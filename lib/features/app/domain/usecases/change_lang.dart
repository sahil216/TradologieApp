import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/app_repository.dart';

class ChangeLangUseCase implements UseCase<bool, String> {
  final AppRepository appRepository;

  ChangeLangUseCase({required this.appRepository});

  @override
  Future<Either<Failure, bool>> call(String langCode) async =>
      await appRepository.changeLang(langCode: langCode);
}
