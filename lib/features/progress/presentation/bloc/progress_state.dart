import 'package:equatable/equatable.dart';

import '../../domain/entities/user_progress.dart';

/// States emitted by [ProgressBloc].
sealed class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object?> get props => [];
}

/// Initial state before progress is loaded.
final class ProgressInitial extends ProgressState {
  const ProgressInitial();
}

/// Progress is being loaded from the database.
final class ProgressLoading extends ProgressState {
  const ProgressLoading();
}

/// Progress loaded successfully.
final class ProgressLoaded extends ProgressState {
  const ProgressLoaded({required this.progress});

  final UserProgress progress;

  @override
  List<Object?> get props => [progress];
}

/// Error loading progress.
final class ProgressError extends ProgressState {
  const ProgressError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
