import 'package:equatable/equatable.dart';

class CustomerPortal extends Equatable {
  const CustomerPortal({required this.url});

  final String url;

  CustomerPortal copyWith({String? url}) {
    return CustomerPortal(url: url ?? this.url);
  }

  @override
  List<Object?> get props => [url];
}
