import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucid_clip/core/clipboard_manager/clipboard_manager.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/features/clipboard/presentation/cubit/clipboard_cubit.dart';
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
  late StreamController<List<ClipboardItem>> localItemsStreamController;
  late StreamController<List<ClipboardHistory>> localHistoryStreamController;

  setUp(() {
    mockClipboardManager = MockClipboardManager();
    mockClipboardRepository = MockClipboardRepository();
    mockLocalClipboardRepository = MockLocalClipboardRepository();
    mockLocalClipboardHistoryRepository = MockLocalClipboardHistoryRepository();
    clipboardStreamController = StreamController<ClipboardData>.broadcast();
    localItemsStreamController = StreamController<List<ClipboardItem>>.broadcast();
    localHistoryStreamController = StreamController<List<ClipboardHistory>>.broadcast();

    // Setup default mock behaviors
    when(() => mockClipboardManager.watchClipboard())
        .thenAnswer((_) => clipboardStreamController.stream);
    when(() => mockClipboardManager.dispose()).thenAnswer((_) async {});
    when(() => mockClipboardRepository.fetchClipboardHistory())
        .thenAnswer((_) async => []);
    when(() => mockClipboardRepository.fetchTags()).thenAnswer((_) async => []);
    when(() => mockLocalClipboardRepository.getAll())
        .thenAnswer((_) async => []);
    when(() => mockLocalClipboardRepository.watchAll())
        .thenAnswer((_) => localItemsStreamController.stream);
    when(() => mockLocalClipboardHistoryRepository.watchAll())
        .thenAnswer((_) => localHistoryStreamController.stream);
    when(() => mockLocalClipboardRepository.upsert(any()))
        .thenAnswer((_) async {});
    when(() => mockLocalClipboardHistoryRepository.upsert(any()))
        .thenAnswer((_) async {});
  });

  tearDown(() {
    clipboardStreamController.close();
    localItemsStreamController.close();
    localHistoryStreamController.close();
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
      'updates currentClipboardData when clipboard manager emits new data',
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
              state.currentClipboardData!.text == 'Test content';
        }),
      ],
    );

    blocTest<ClipboardCubit, ClipboardState>(
      'does not add duplicate clipboard data to local repository',
      build: () => ClipboardCubit(
        clipboardManager: mockClipboardManager,
        clipboardRepository: mockClipboardRepository,
        localClipboardRepository: mockLocalClipboardRepository,
        localClipboardHistoryRepository: mockLocalClipboardHistoryRepository,
      ),
      act: (cubit) async {
        // Wait for initialization
        await Future.delayed(const Duration(milliseconds: 50));
        
        // Add initial item via stream
        final item = ClipboardItem(
          id: 'id1',
          content: 'Duplicate content',
          contentHash: 'hash456',
          type: ClipboardItemType.text,
          userId: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        localItemsStreamController.add([item]);
        
        await Future.delayed(const Duration(milliseconds: 50));
        
        final clipboardData = ClipboardData(
          type: ClipboardContentType.text,
          text: 'Duplicate content',
          contentHash: 'hash456',
          timestamp: DateTime.now(),
        );
        // Try to add the same clipboard data twice
        clipboardStreamController.add(clipboardData);
        clipboardStreamController.add(clipboardData);
      },
      wait: const Duration(milliseconds: 100),
      verify: (cubit) {
        // Should only call upsert once since the second one is a duplicate
        verify(() => mockLocalClipboardRepository.upsert(any())).called(1);
      },
    );

    blocTest<ClipboardCubit, ClipboardState>(
      'receives multiple clipboard items from local repository stream',
      build: () => ClipboardCubit(
        clipboardManager: mockClipboardManager,
        clipboardRepository: mockClipboardRepository,
        localClipboardRepository: mockLocalClipboardRepository,
        localClipboardHistoryRepository: mockLocalClipboardHistoryRepository,
      ),
      act: (cubit) async {
        // Wait for initialization
        await Future.delayed(const Duration(milliseconds: 50));
        
        final item1 = ClipboardItem(
          id: 'id1',
          content: 'First content',
          contentHash: 'hash1',
          type: ClipboardItemType.text,
          userId: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        final item2 = ClipboardItem(
          id: 'id2',
          content: 'Second content',
          contentHash: 'hash2',
          type: ClipboardItemType.text,
          userId: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        localItemsStreamController.add([item1, item2]);
      },
      wait: const Duration(milliseconds: 100),
      verify: (cubit) {
        expect(cubit.state.localClipboardItems.length, 2);
        expect(cubit.state.localClipboardItems[0].text, 'First content');
        expect(cubit.state.localClipboardItems[1].text, 'Second content');
      },
    );

    blocTest<ClipboardCubit, ClipboardState>(
      'handles different clipboard content types from stream',
      build: () => ClipboardCubit(
        clipboardManager: mockClipboardManager,
        clipboardRepository: mockClipboardRepository,
        localClipboardRepository: mockLocalClipboardRepository,
        localClipboardHistoryRepository: mockLocalClipboardHistoryRepository,
      ),
      act: (cubit) async {
        // Wait for initialization
        await Future.delayed(const Duration(milliseconds: 50));
        
        final textItem = ClipboardItem(
          id: 'id1',
          content: 'Text content',
          contentHash: 'text_hash',
          type: ClipboardItemType.text,
          userId: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        final urlItem = ClipboardItem(
          id: 'id2',
          content: 'https://example.com',
          contentHash: 'url_hash',
          type: ClipboardItemType.url,
          userId: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        final imageItem = ClipboardItem(
          id: 'id3',
          content: '',
          contentHash: 'image_hash',
          type: ClipboardItemType.image,
          userId: '',
          imageUrl: 'local',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        localItemsStreamController.add([textItem, urlItem, imageItem]);
      },
      wait: const Duration(milliseconds: 100),
      verify: (cubit) {
        expect(cubit.state.localClipboardItems.length, 3);
        expect(
          cubit.state.localClipboardItems[0].type,
          ClipboardContentType.text,
        );
        expect(
          cubit.state.localClipboardItems[1].type,
          ClipboardContentType.url,
        );
        expect(
          cubit.state.localClipboardItems[2].type,
          ClipboardContentType.image,
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

    test('subscribes to local clipboard items stream on initialization', () async {
      final cubit = ClipboardCubit(
        clipboardManager: mockClipboardManager,
        clipboardRepository: mockClipboardRepository,
        localClipboardRepository: mockLocalClipboardRepository,
        localClipboardHistoryRepository: mockLocalClipboardHistoryRepository,
      );

      // Wait for initialization
      await Future.delayed(const Duration(milliseconds: 100));

      verify(() => mockLocalClipboardRepository.watchAll()).called(1);
      verify(() => mockLocalClipboardHistoryRepository.watchAll()).called(1);

      await cubit.close();
    });

    blocTest<ClipboardCubit, ClipboardState>(
      'updates state when local items stream emits new data',
      build: () => ClipboardCubit(
        clipboardManager: mockClipboardManager,
        clipboardRepository: mockClipboardRepository,
        localClipboardRepository: mockLocalClipboardRepository,
        localClipboardHistoryRepository: mockLocalClipboardHistoryRepository,
      ),
      act: (cubit) async {
        // Wait for initialization
        await Future.delayed(const Duration(milliseconds: 100));
        
        // Emit items from local repository stream
        final item1 = ClipboardItem(
          id: 'id1',
          content: 'Item 1',
          contentHash: 'hash1',
          type: ClipboardItemType.text,
          userId: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        final item2 = ClipboardItem(
          id: 'id2',
          content: 'Item 2',
          contentHash: 'hash2',
          type: ClipboardItemType.text,
          userId: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        localItemsStreamController.add([item1, item2]);
      },
      wait: const Duration(milliseconds: 100),
      verify: (cubit) {
        expect(cubit.state.localClipboardItems.length, 2);
        expect(cubit.state.localClipboardItems[0].text, 'Item 1');
        expect(cubit.state.localClipboardItems[1].text, 'Item 2');
      },
    );
  });
}
