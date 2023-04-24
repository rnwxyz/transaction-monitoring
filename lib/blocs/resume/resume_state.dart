part of 'resume_bloc.dart';

@immutable
abstract class ResumeState {}

class ResumeInitial extends ResumeState {}

class ResumeLoading extends ResumeState {}

class ResumeLoaded extends ResumeState {
  final List<ResumeModel> data;

  ResumeLoaded({required this.data});
}

class ResumeError extends ResumeState {
  final String message;

  ResumeError({required this.message});
}
