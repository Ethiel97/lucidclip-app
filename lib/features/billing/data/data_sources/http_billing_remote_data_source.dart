import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/errors/errors.dart';
import 'package:lucid_clip/core/network/network.dart';
import 'package:lucid_clip/features/billing/data/data.dart';

@LazySingleton(as: BillingRemoteDataSource)
class HttpBillingRemoteDataSource implements BillingRemoteDataSource {
  HttpBillingRemoteDataSource(this.httpClient);

  final HttpClient httpClient;

  @override
  Future<CheckoutSessionModel?> createCheckoutSession({
    required String productId,
    required String userId,
    required String? email,
  }) async {
    try {
      // TODO(Ethiel): Replace with your actual backend endpoint
      final response = await httpClient.post(
        'https://68b51c6eca97.ngrok-free.app/api/checkout',
        data: {
          'productId': productId,
          'userId': userId,
          'customerEmail': email,
          'metadata': {'supabaseUserId': userId, 'source': 'desktop_app'},
          if (email != null) 'email': email,
        },
      );

      if (response['success'] != true) {
        throw ServerException(
          'Failed to create checkout '
          'session: ${response['error'] ?? 'Unknown error'}',
        );
      }

      return CheckoutSessionModel.fromJson(
        response['data'] as Map<String, dynamic>,
      );
    } on Exception catch (_) {
      rethrow;
    }
  }
}
