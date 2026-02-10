import 'package:flutter_test/flutter_test.dart';
import 'package:lucid_clip/core/observability/observability.dart';
import 'package:lucid_clip/core/observability/observability_service.dart';
import 'package:mocktail/mocktail.dart';

class MockObservabilityService extends Mock implements ObservabilityService {}

void main() {
  group('Observability Facade', () {
    late MockObservabilityService mockService;

    setUp(() {
      mockService = MockObservabilityService();
      Observability.initialize(mockService);
    });

    test('should forward captureException to service', () async {
      // Arrange
      final exception = Exception('Test error');
      final stackTrace = StackTrace.current;
      final hint = {'test': 'data'};

      when(
        () => mockService.captureException(
          exception,
          stackTrace: stackTrace,
          hint: hint,
        ),
      ).thenAnswer((_) async {});

      // Act
      await Observability.captureException(
        exception,
        stackTrace: stackTrace,
        hint: hint,
      );

      // Assert
      verify(
        () => mockService.captureException(
          exception,
          stackTrace: stackTrace,
          hint: hint,
        ),
      ).called(1);
    });

    test('should forward addBreadcrumb to service', () async {
      // Arrange
      const message = 'Test breadcrumb';
      const category = 'test';
      final data = {'key': 'value'};
      const level = ObservabilityLevel.info;

      when(
        () =>
            mockService.addBreadcrumb(message, category: category, data: data),
      ).thenAnswer((_) async {});

      // Act
      await Observability.breadcrumb(message, category: category, data: data);

      // Assert
      verify(
        () =>
            mockService.addBreadcrumb(message, category: category, data: data),
      ).called(1);
    });

    test('should forward setUser to service', () async {
      // Arrange
      const userId = 'test-user-id';
      const email = 'test@example.com';
      final extras = {'tier': 'pro'};

      when(
        () => mockService.setUser(userId, email: email, extras: extras),
      ).thenAnswer((_) async {});

      // Act
      await Observability.setUser(userId, email: email, extras: extras);

      // Assert
      verify(
        () => mockService.setUser(userId, email: email, extras: extras),
      ).called(1);
    });

    test('should forward clearUser to service', () async {
      // Arrange
      when(() => mockService.clearUser()).thenAnswer((_) async {});

      // Act
      await Observability.clearUser();

      // Assert
      verify(() => mockService.clearUser()).called(1);
    });

    test('should forward setTag to service', () async {
      // Arrange
      const key = 'subscription';
      const value = 'pro';

      when(() => mockService.setTag(key, value)).thenAnswer((_) async {});

      // Act
      await Observability.setTag(key, value);

      // Assert
      verify(() => mockService.setTag(key, value)).called(1);
    });

    test('should forward close to service', () async {
      // Arrange
      when(() => mockService.close()).thenAnswer((_) async {});

      // Act
      await Observability.close();

      // Assert
      verify(() => mockService.close()).called(1);
    });

    test('should return enabled status from service', () {
      // Arrange
      when(() => mockService.isEnabled).thenReturn(true);

      // Act
      final isEnabled = Observability.isEnabled;

      // Assert
      expect(isEnabled, true);
      verify(() => mockService.isEnabled).called(1);
    });

    test('should return false when service is not initialized', () {
      // Arrange
      // Reset the facade by setting service to null
      // Note: This is a bit hacky but necessary for this test
      // In a real scenario, you might want to add a reset method for testing
      Observability.initialize(null as ObservabilityService);

      // Act
      final isEnabled = Observability.isEnabled;

      // Assert
      expect(isEnabled, false);
    });

    test('should handle null service gracefully for all operations', () async {
      // Arrange
      Observability.initialize(null as ObservabilityService);

      // Act & Assert - should not throw
      await Observability.captureException(Exception('test'));
      await Observability.breadcrumb('test');
      await Observability.setUser('user-id');
      await Observability.clearUser();
      await Observability.setTag('key', 'value');
      await Observability.close();
    });
  });

  group('ObservabilityService Interface', () {
    test('should define all required methods', () {
      // This test ensures the interface is properly defined
      // by checking if MockObservabilityService implements all methods
      final service = MockObservabilityService();

      // These should not throw compilation errors
      expect(service, isA<ObservabilityService>());
    });
  });
}
