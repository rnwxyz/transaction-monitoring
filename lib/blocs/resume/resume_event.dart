part of 'resume_bloc.dart';

@immutable
abstract class ResumeEvent {}

class ResumeGetEvent extends ResumeEvent {
  final int tahun;

  ResumeGetEvent({required this.tahun});
}
