
# LucidClip – AI Assistant Instructions (Copilot / Codex / Claude)

These guidelines describe **how code must be generated** for the LucidClip project.

LucidClip is a **privacy-first, modern clipboard manager** built with **Flutter** and **Supabase** (for optional sync).  
The codebase must remain:

- **Cleanly architected**
- **Testable**
- **Maintainable**
- **Desktop-ready (macOS first, later Windows/Linux)**

> If you are an AI coding assistant, **do not ignore this file**.  
> All generated code must follow these constraints.

---

## 1. High-Level Goals

- Local-first clipboard manager with:
    - Clipboard history
    - Pinned items & snippets
    - Search
    - Detailed item view
    - Optional Supabase sync (opt-in)
- **Privacy by default**: everything stays local unless the user explicitly enables sync.
- UX inspired by Raycast / Linear / Notion, but **not copied**.

Do **not** introduce quick hacks that bypass the architecture just to “make it work”.

---

## 2. Architecture Principles

We use a **feature-first Clean Architecture** inspired by DDD.

### 2.1 Structure (example / target)

```text
lib/
├── app/                    # App configuration, entrypoints, env
├── bootstrap.dart          # Initialization (DI, Supabase, local DB, etc.)
├── core/                   # Cross-cutting abstractions and utilities
│   ├── constants/
│   ├── di/                 # Dependency injection setup
│   ├── errors/
│   ├── network/            # Supabase / HTTP abstractions
│   ├── storage/            # Local storage abstractions (Isar/Hive)
│   └── utils/              # ValueWrapper, extensions, etc.
├── features/
│   ├── clipboard/          # Clipboard history feature
│   ├── snippets/           # Snippets & pinned items
│   ├── history/            # Advanced history views / filters
│   ├── sync/               # Supabase sync feature (opt-in)
│   ├── settings/           # Theme, privacy, sync toggles, shortcuts
│   └── shell/              # Main layout (sidebar, command board)
├── shared/
│   ├── routing/            # Navigation configuration
│   ├── theme/              # Light/Dark/“Lucid” theme
│   ├── utils/              # Shared helpers
│   └── widgets/            # Reusable UI components
└── l10n/                   # Internationalization
```

### 2.2 Feature layout

Every **feature** follows this structure:

```text
features/<feature_name>/
├── data/
│   ├── datasources/        # Local + remote data sources
│   ├── models/             # DTOs with JSON serialization
│   └── repositories/       # Repository implementations
├── domain/
│   ├── entities/           # Entities, value objects
│   └── repositories/       # Repository contracts (interfaces)
└── presentation/
    ├── cubit/ or bloc/     # State management
    ├── pages/              # Screens
    └── widgets/            # Feature-specific widgets
```

### 2.3 Allowed dependencies between layers

- `presentation` → `domain`
- `data` → `domain`
- `domain` → **no dependency** on `data` or `presentation`
- `core` and `shared` may be used by all, but must stay generic.

Never let **data layer classes** import from `presentation`, and never place business logic directly inside widgets.

---

## 3. State Management

We use **BLoC/Cubit (`flutter_bloc`)** + a **ValueWrapper pattern** for representing async states.

### 3.1 Rules

- Do **not** introduce other state managers (`provider`, `riverpod`, `setState`-heavy logic, etc.).
- States are **immutable** (`const` + `copyWith`).
- Use **`BlocSelector`** to limit rebuilds.
- Use **`BlocListener` + `listenWhen`** for targeted side effects.

### 3.2 ValueWrapper usage

We encapsulate async UI states in a `ValueWrapper<T>` with variants: `initial`, `loading`, `success`, `error`.

Preferred usage:

```dart
emit(state.copyWith(
  historyStatus: null.toLoading<List<ClipItem>>(),
));

emit(state.copyWith(
  historyStatus: clips.toSuccess<List<ClipItem>>(),
));

emit(state.copyWith(
  historyStatus: 'Network error'.toError<List<ClipItem>>(),
));
```

In the UI:

```dart
state.historyStatus.when(
  initial: () => const _EmptyHistoryPlaceholder(),
  loading: (oldData) =>
      oldData != null ? HistoryList(oldData) : const LoadingView(),
  success: (data) => HistoryList(data),
  error: (error, oldData) => ErrorView(
    message: error,
    retry: _reload,
    previousContent: oldData != null ? HistoryList(oldData) : null,
  ),
);
```

**AI assistants must generate new states / UI flows using this pattern.**

---

## 4. Dependency Injection

LucidClip uses **GetIt + Injectable** for DI.

### 4.1 Principles

- Inject **abstractions**, not concretes.  
  Example: inject `ClipboardRepository`, **not** `SupabaseClipboardRepository` directly.
- Use constructor injection for all dependencies.
- Annotate injectable classes with `@injectable`, `@LazySingleton`, `@Singleton`, etc.

Example:

```dart
@LazySingleton(as: ClipboardRepository)
class ClipboardRepositoryImpl implements ClipboardRepository {
  ClipboardRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
  );

  final ClipboardLocalDataSource _localDataSource;
  final ClipboardRemoteDataSource _remoteDataSource;
}
```

Global setup:

```dart
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() => getIt.init();
```

**Do not** instantiate `SupabaseClient`, local DB instances, or services directly inside widgets or Cubits. Always inject them.

---

## 5. Data & Sync (Local + Supabase)

LucidClip is **local-first with optional sync**.

### 5.1 Local Storage

- Use an abstraction in `core/storage` (e.g. `StorageService` or `LocalClipboardStore`).
- Actual implementation (Isar/Hive/SQLite) goes in the `data` layer (e.g. `IsarLocalClipboardStore`).

Example interface:

```dart
abstract class LocalClipboardStore {
  Future<void> upsertItem(ClipItemModel item);
  Future<void> deleteItem(String id);
  Future<List<ClipItemModel>> getItems();
  Stream<List<ClipItemModel>> watchItems();
}
```

AI assistants must **not** couple presentation directly to a concrete DB.

### 5.2 Supabase Integration

- Wrap `SupabaseClient` in an abstraction inside `core/network` (e.g. `RemoteSyncClient`).
- Any Supabase operation is done through **datasources** (e.g. `ClipboardRemoteDataSource`).

Example:

```dart
abstract class ClipboardRemoteDataSource {
  Future<void> syncItems(List<ClipItemModel> items);
  Future<List<ClipItemModel>> fetchRemoteItems();
}
```

Implementations are responsible for:

- using Supabase tables (e.g. `clipboard_items`, `snippets`, `settings`)
- handling upserts, conflict resolution, and soft deletion.

The **sync strategy** should remain:

- local-first
- batched sync (not per clipboard event)
- explicit opt-in from the user (via Settings / Sync UI).

Do not force network calls from within widgets.

---

## 6. Navigation

- Use a **single, centralized router** (e.g. `AutoRoute` or `GoRouter`—stay consistent with the chosen one).
- No ad-hoc `Navigator.push` scattered around the codebase, except potentially in legacy or trivial cases aligned with the router.

Example (AutoRoute style):

```dart
@AutoRouteConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: ShellRoute.page, initial: true, path: '/'),
    AutoRoute(page: ClipboardRoute.page, path: '/clipboard'),
    AutoRoute(page: SnippetsRoute.page, path: '/snippets'),
    AutoRoute(page: SettingsRoute.page, path: '/settings'),
  ];
}
```

Use generated route types or named routes from the router, not hard-coded push/pop logic.

---

## 7. Error Handling

- Use a **centralized error model** in `core/errors` (e.g. `AppException`, `ErrorDetails`).
- Repositories must **translate** low-level errors (Supabase, local DB, platform) into domain-level exceptions or `ValueWrapper.error`.

Example:

```dart
class ErrorDetails extends Equatable {
  const ErrorDetails({
    required this.message,
    this.code,
    this.stackTrace,
  });

  final String message;
  final String? code;
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [message, code, stackTrace];
}
```

In a repository:

```dart
@override
Future<List<ClipItem>> getHistory() async {
  try {
    final models = await _localDataSource.getItems();
    return models.map((m) => m.toEntity()).toList();
  } on SupabaseException catch (e, s) {
    throw AppException.network(
      ErrorDetails(message: e.message, code: e.code, stackTrace: s),
    );
  } catch (e, s) {
    throw AppException.unknown(
      ErrorDetails(message: e.toString(), stackTrace: s),
    );
  }
}
```

UI must **never** throw raw Supabase or DB exceptions.

---

## 8. UI & UX Guidelines

LucidClip’s UI should be:

- Desktop-centric (mouse + keyboard, global shortcuts)
- Dark-theme first, with light theme parity
- Minimalistic, with clear hierarchy and breathing space

### 8.1 Components / Layout

- Sidebar with sections:
    - **Clipboard**
    - **Snippets**
    - **History**
    - **Settings**
- Main panel with:
    - Global search bar (command palette style)
    - “Pinned” section
    - “Recent” section
    - Detailed item view (right-side panel or modal) with:
        - full content preview,
        - metadata (source app, timestamp, type),
        - actions (copy, pin, delete, transform).

### 8.2 Performance

- Use `BlocSelector` or similar for large lists.
- Prefer `ListView.builder`, `SliverList`, or `Lazy` patterns.
- Use `const` constructors wherever possible to reduce rebuilds.
- Avoid unnecessary widget fragmentation.

Do not generate overly nested micro-widgets unless they genuinely encapsulate reusable behavior.

---

## 9. Testing

When suggesting tests, prefer:

- **Unit tests** for:
    - Cubits/BLoCs (with `bloc_test`)
    - Repositories (with mocked datasources)
- **Widget tests** for:
    - Pages
    - Frequently used reusable widgets
- **Mocks** using `mocktail` or similar library.

Example:

```dart
blocTest<ClipboardCubit, ClipboardState>(
  'emits success when loading history succeeds',
  build: () => ClipboardCubit(mockRepository),
  act: (cubit) => cubit.loadHistory(),
  expect: () => [
    const ClipboardState(historyStatus: null.toLoading<List<ClipItem>>()),
    ClipboardState(
      historyStatus: clips.toSuccess<List<ClipItem>>(),
    ),
  ],
);
```

---

## 10. Do / Don’t Summary for AI Assistants

### ✅ DO

- Respect **feature-first + Clean Architecture**.
- Inject dependencies using **GetIt + Injectable**.
- Use `Bloc/Cubit` + `ValueWrapper` for state.
- Use Supabase **only behind abstractions** in the `data` layer.
- Keep clipboard logic & privacy rules in **domain/data**, not UI.
- Prefer **local-first** data flow, then optionally sync via Supabase.
- Keep code consistent with existing patterns and naming conventions.

### ❌ DON’T

- Don’t put business logic inside widgets.
- Don’t call `SupabaseClient` or DB APIs directly from UI or Cubits.
- Don’t introduce new state managers (`provider`, `riverpod`, etc.).
- Don’t create random globals or singletons outside DI.
- Don’t bypass error handling; always map errors to domain types or `ValueWrapper.error`.
- Don’t copy external products (Raycast, Linear, etc.) visually or structurally; only draw inspiration.

---

Following these rules ensures LucidClip stays **consistent, robust, and pleasant to work in**—for humans and AI assistants alike.
