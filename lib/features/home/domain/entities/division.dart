import 'package:equatable/equatable.dart';

class Division extends Equatable {
  final String id;
  final String name;
  final String logoUrl;
  final int order;
  final bool isCustom;

  const Division({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.order,
    this.isCustom = false,
  });

  @override
  List<Object?> get props => [id, name, logoUrl, order, isCustom];
}