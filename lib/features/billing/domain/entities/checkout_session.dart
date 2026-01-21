import 'package:equatable/equatable.dart';

class CheckoutSession extends Equatable {
  const CheckoutSession({
    required this.id,
    required this.expiresAt,
    required this.url,
  });

  final String id;
  final DateTime expiresAt;
  final String url;

  @override
  List<Object?> get props => [id, expiresAt, url];
}
