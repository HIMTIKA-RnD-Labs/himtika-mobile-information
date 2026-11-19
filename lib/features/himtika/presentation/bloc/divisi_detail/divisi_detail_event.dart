part of 'divisi_detail_bloc.dart';

abstract class DivisiDetailEvent extends Equatable {
  const DivisiDetailEvent();
  @override
  List<Object?> get props => [];
}

class FetchDivisiData extends DivisiDetailEvent {
  final String divisiId;
  final String? divisiTitle;

  const FetchDivisiData({required this.divisiId, this.divisiTitle});

  @override
  List<Object?> get props => [divisiId, divisiTitle];
}
