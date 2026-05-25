import 'dart:convert';

/// Flattens FCM [data] when the backend wraps fields in JSON or a nested `data` key.
Map<String, dynamic> normalizeFcmData(Map<String, dynamic> raw) {
  if (raw.isEmpty) return raw;

  var result = Map<String, dynamic>.from(raw);

  void mergeMap(Map<dynamic, dynamic> map) {
    for (final entry in map.entries) {
      result[entry.key.toString()] = entry.value?.toString() ?? '';
    }
  }

  for (final key in ['data', 'Data', 'payload', 'Payload', 'customData']) {
    final nested = result[key];
    if (nested is Map) {
      mergeMap(nested);
      continue;
    }
    final text = nested?.toString().trim() ?? '';
    if (text.startsWith('{')) {
      try {
        final decoded = jsonDecode(text);
        if (decoded is Map) {
          mergeMap(decoded);
        }
      } catch (_) {}
    }
  }

  if (result.length == 1) {
    final only = result.values.first?.toString().trim() ?? '';
    if (only.startsWith('{')) {
      try {
        final decoded = jsonDecode(only);
        if (decoded is Map) {
          mergeMap(decoded);
        }
      } catch (_) {}
    }
  }

  return result;
}
