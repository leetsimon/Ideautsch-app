import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_progress.dart';
import 'progress_event.dart';
import 'progress_state.dart';

/// BLoC for user progress tracking and display.
///
/// Provides the home screen and progress dashboard with
/// current statistics, career readiness, and streak data.
class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  ProgressBloc({
    required GetProgress getProgress,
  })  : _getProgress = getProgress,
        super(const ProgressInitial()) {
    on<LoadProgressEvent>(_onLoadProgress);
    on<RefreshProgressEvent>(_onRefreshProgress);
  }

  final GetProgress _getProgress;

  Future<void> _onLoadProgress(
    LoadProgressEvent event,
    Emitter<ProgressState> emit,
  ) async {
    emit(const ProgressLoading());

    final result = await _getProgress(const NoParams());

    result.fold(
      (failure) => emit(ProgressError(message: failure.message)),
      (progress) => emit(ProgressLoaded(progress: progress)),
    );
  }

  Future<void> _onRefreshProgress(
    RefreshProgressEvent event,
    Emitter<ProgressState> emit,
  ) async {
    // Don't show loading state on refresh (keeps current data visible)
    final result = await _getProgress(const NoParams());

    result.fold(
      (failure) {
        // On refresh failure, keep current state
      },
      (progress) => emit(ProgressLoaded(progress: progress)),
    );
  }
}
