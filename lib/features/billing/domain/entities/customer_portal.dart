import 'package:equatable/equatable.dart';

class CustomerPortal extends Equatable {
  const CustomerPortal({required this.expiresAt, required this.url});

  final DateTime expiresAt;
  final String url;

  CustomerPortal copyWith({DateTime? expiresAt, String? url}) {
    return CustomerPortal(
      expiresAt: expiresAt ?? this.expiresAt,
      url: url ?? this.url,
    );
  }

  @override
  List<Object?> get props => [expiresAt, url];

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
