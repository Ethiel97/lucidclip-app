import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucid_clip/core/clipboard_manager/clipboard_manager.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:mocktail/mocktail.dart';

class MockClipboardManager extends Mock implements BaseClipboardManager {}

class MockClipboardRepository extends Mock implements ClipboardRepository {}

class MockLocalClipboardRepository extends Mock
    implements LocalClipboardRepository {}

class MockLocalClipboardHistoryRepository extends Mock
    implements LocalClipboardHistoryRepository {}

void main() {
  late MockClipboardManager mockClipboardManager;
  late MockClipboardRepository mockClipboardRepository;
  late MockLocalClipboardRepository mockLocalClipboardRepository;
  late MockLocalClipboardHistoryRepository
      mockLocalClipboardHistoryRepository;
  late StreamController<ClipboardData> clipboardStreamController;

  setUp(() {
    mockClipboardManager = MockClipboardManager();
    mockClipboardRepository = MockClipboardRepository();
    mockLocalClipboardRepository = MockLocalClipboardRepository();
    mockLocalClipboardHistoryRepository = MockLocalClipboardHistoryRepository();
    clipboardStreamController = StreamController<ClipboardData>.broadcast();

    // Setup default mock behaviors
    when(() => mockClipboardManager.watchClipboard())
        .thenAnswer((_) => clipboardStreamController.stream);
    when(() => mockClipboardManager.dispose()).thenAnswer((_) async {});
    when(() => mockClipboardRepository.fetchClipboardHistory())
        .thenAnswer((_) async => []);
    when(() => mockClipboardRepository.fetchTags()).thenAnswer((_) async => []);
    when(() => mockLocalClipboardRepository.getAll())
        .thenAnswer((_) async => []);
    when(() => mockLocalClipboardRepository.upsert(any()))
        .thenAnswer((_) async {});
    when(() => mockLocalClipboardHistoryRepository.upsert(any()))
        .thenAnswer((_) async {});
  });

  tearDown(() {
    clipboardStreamController.close();
  });

  group('ClipboardCubit', () {
    test('initial state has empty clipboard items', () async {
      final cubit = ClipboardCubit(
        clipboardManager: mockClipboardManager,
        clipboardRepository: mockClipboardRepository,
        localClipboardRepository: mockLocalClipboardRepository,
        localClipboardHistoryRepository: mockLocalClipboardHistoryRepository,
      );

      expect(cubit.state.localClipboardItems, isEmpty);
      expect(cubit.state.currentClipboardData, isNull);

      await cubit.close();
    });

    test('automatically starts watching clipboard on initialization', () async {
      final cubit = ClipboardCubit(
        clipboardManager: mockClipboardManager,
        clipboardRepository: mockClipboardRepository,
        localClipboardRepository: mockLocalClipboardRepository,
        localClipboardHistoryRepository: mockLocalClipboardHistoryRepository,
      );

      verify(() => mockClipboardManager.watchClipboard()).called(1);

      await cubit.close();
    });

    blocTest<ClipboardCubit, ClipboardState>(
      'adds new clipboard data to localClipboardItems when received',
      build: () => ClipboardCubit(
        clipboardManager: mockClipboardManager,
        clipboardRepository: mockClipboardRepository,
        localClipboardRepository: mockLocalClipboardRepository,
        localClipboardHistoryRepository: mockLocalClipboardHistoryRepository,
      ),
      act: (cubit) {
        final clipboardData = ClipboardData(
          type: ClipboardContentType.text,
          text: 'Test content',
          contentHash: 'hash123',
          timestamp: DateTime.now(),
        );
        clipboardStreamController.add(clipboardData);
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        predicate<ClipboardState>((state) {
          return state.currentClipboardData != null &&
              state.currentClipboardData!.text == 'Test content' &&
              state.localClipboardItems.isEmpty;
        }),
        predicate<ClipboardState>((state) {
          return state.localClipboardItems.length == 1 &&
              state.localClipboardItems.first.text == 'Test content';
        }),
      ],
    );

    blocTest<ClipboardCubit, ClipboardState>(
      'does not add duplicate clipboard data to localClipboardItems',
      build: () => ClipboardCubit(
        clipboardManager: mockClipboardManager,
        clipboardRepository: mockClipboardRepository,
        localClipboardRepository: mockLocalClipboardRepository,
        localClipboardHistoryRepository: mockLocalClipboardHistoryRepository,
      ),
      act: (cubit) {
        final clipboardData = ClipboardData(
          type: ClipboardContentType.text,
          text: 'Duplicate content',
          contentHash: 'hash456',
          timestamp: DateTime.now(),
        );
        // Add the same clipboard data twice
        clipboardStreamController.add(clipboardData);
        clipboardStreamController.add(clipboardData);
      },
      wait: const Duration(milliseconds: 100),
      verify: (cubit) {
        // Should only have one item despite receiving the same content twice
        expect(cubit.state.localClipboardItems.length, 1);
      },
    );

    blocTest<ClipboardCubit, ClipboardState>(
      'adds multiple different clipboard items to history',
      build: () => ClipboardCubit(
        clipboardManager: mockClipboardManager,
        clipboardRepository: mockClipboardRepository,
        localClipboardRepository: mockLocalClipboardRepository,
        localClipboardHistoryRepository: mockLocalClipboardHistoryRepository,
      ),
      act: (cubit) {
        final clipboardData1 = ClipboardData(
          type: ClipboardContentType.text,
          text: 'First content',
          contentHash: 'hash1',
          timestamp: DateTime.now(),
        );
        final clipboardData2 = ClipboardData(
          type: ClipboardContentType.text,
          text: 'Second content',
          contentHash: 'hash2',
          timestamp: DateTime.now(),
        );
        clipboardStreamController.add(clipboardData1);
        clipboardStreamController.add(clipboardData2);
      },
      wait: const Duration(milliseconds: 100),
      verify: (cubit) {
        expect(cubit.state.localClipboardItems.length, 2);
        // Newest items should be first
        expect(cubit.state.localClipboardItems.first.text, 'Second content');
        expect(cubit.state.localClipboardItems.last.text, 'First content');
      },
    );

    blocTest<ClipboardCubit, ClipboardState>(
      'handles different clipboard content types',
      build: () => ClipboardCubit(
        clipboardManager: mockClipboardManager,
        clipboardRepository: mockClipboardRepository,
        localClipboardRepository: mockLocalClipboardRepository,
        localClipboardHistoryRepository: mockLocalClipboardHistoryRepository,
      ),
      act: (cubit) {
        final textData = ClipboardData(
          type: ClipboardContentType.text,
          text: 'Text content',
          contentHash: 'text_hash',
          timestamp: DateTime.now(),
        );
        final urlData = ClipboardData(
          type: ClipboardContentType.url,
          text: 'https://example.com',
          contentHash: 'url_hash',
          timestamp: DateTime.now(),
        );
        final imageData = ClipboardData(
          type: ClipboardContentType.image,
          imageBytes: const [1, 2, 3, 4],
          contentHash: 'image_hash',
          timestamp: DateTime.now(),
        );
        clipboardStreamController.add(textData);
        clipboardStreamController.add(urlData);
        clipboardStreamController.add(imageData);
      },
      wait: const Duration(milliseconds: 100),
      verify: (cubit) {
        expect(cubit.state.localClipboardItems.length, 3);
        expect(
          cubit.state.localClipboardItems.first.type,
          ClipboardContentType.image,
        );
        expect(
          cubit.state.localClipboardItems[1].type,
          ClipboardContentType.url,
        );
        expect(
          cubit.state.localClipboardItems.last.type,
          ClipboardContentType.text,
        );
      },
    );

    test('properly cancels subscription on close', () async {
      final cubit = ClipboardCubit(
        clipboardManager: mockClipboardManager,
        clipboardRepository: mockClipboardRepository,
        localClipboardRepository: mockLocalClipboardRepository,
        localClipboardHistoryRepository: mockLocalClipboardHistoryRepository,
      );

      await cubit.close();

      // Verify that dispose was called on the clipboard manager
      verify(() => mockClipboardManager.dispose()).called(1);
    });

    test('upserts clipboard item to local repository on new clipboard data',
        () async {
      final cubit = ClipboardCubit(
        clipboardManager: mockClipboardManager,
        clipboardRepository: mockClipboardRepository,
        localClipboardRepository: mockLocalClipboardRepository,
        localClipboardHistoryRepository: mockLocalClipboardHistoryRepository,
      );

      final clipboardData = ClipboardData(
        type: ClipboardContentType.text,
        text: 'Test content',
        contentHash: 'hash123',
        timestamp: DateTime.now(),
      );

      clipboardStreamController.add(clipboardData);

      // Wait for async operations to complete
      await Future.delayed(const Duration(milliseconds: 100));

      // Verify upsert was called
      verify(() => mockLocalClipboardRepository.upsert(any())).called(1);
      verify(() => mockLocalClipboardHistoryRepository.upsert(any())).called(1);

      await cubit.close();
    });
  });
}
