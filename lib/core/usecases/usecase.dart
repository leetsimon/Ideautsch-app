import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failures.dart';

/// Base contract for all use cases in the application.
///
/// Every use case takes a [Params] object and returns
/// an [Either] wrapping a [Failure] or a [Type] result.
///
/// Use cases represent single business operations and coordinate
/// between repositories and engines.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Parameter class for use cases that require no input.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
