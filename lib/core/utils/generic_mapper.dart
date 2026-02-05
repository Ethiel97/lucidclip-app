// Generic mapper utilities used across the codebase.
// Provides a few small helpers to convert between types in a generic,
// reusable way.

typedef Mapper<S, T> = T Function(S source);

/// Map a nullable single value using [mapper]. Returns null
/// if [source] is null.
T? mapNullable<S, T>(S? source, Mapper<S, T> mapper) =>
    source == null ? null : mapper(source);

/// Map a nullable list using [mapper]. Returns null if [list] is null.
List<T>? mapList<S, T>(List<S>? list, Mapper<S, T> mapper) =>
    list?.map(mapper).toList();

/// Helper for converting a list of entities
/// to a list of json-serializable maps.
List<Map<String, dynamic>>? toJsonList<S>(
  List<S>? list,
  Mapper<S, Map<String, dynamic>> mapper,
) => mapList<S, Map<String, dynamic>>(list, mapper);

/// Helper for converting a json list (List<dynamic>)
/// to typed list using [fromJson].
List<T>? fromJsonList<T>(
  List<dynamic>? json,
  T Function(Map<String, dynamic>) fromJson,
) {
  if (json == null) return null;
  return json.cast<Map<String, dynamic>>().map(fromJson).toList();
}

/// Compose two mappers A->B and B->C into A->C.
Mapper<A, C> compose<A, B, C>(Mapper<A, B> f, Mapper<B, C> g) =>
    (a) => g(f(a));
