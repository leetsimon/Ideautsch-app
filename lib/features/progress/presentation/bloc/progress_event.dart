import 'package:equatable/equatable.dart';

/// Events that drive the [ProgressBloc].
sealed class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object?> get props => [];
}

/// Load the current user progress.
final class LoadProgressEvent extends ProgressEvent {
  const LoadProgressEvent();
}

/// Refresh progress after a mission completion.
final class RefreshProgressEvent extends ProgressEvent {
  const RefreshProgressEvent();
}
