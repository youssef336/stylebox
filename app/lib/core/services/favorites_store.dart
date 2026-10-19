import 'package:flutter/foundation.dart';
import 'package:stylebox/core/services/shared_preferences_singletone.dart';

/// Boxes the customer hearted, kept on this device.
class FavoritesStore {
  FavoritesStore._();

  static const _key = 'favourite_boxes';

  static final ValueNotifier<Set<String>> ids = ValueNotifier<Set<String>>(
    _read(),
  );

  static Set<String> _read() {
    try {
      final raw = Prefs.getString(_key);
      return raw.isEmpty ? <String>{} : raw.split(',').toSet();
    } catch (_) {
      // Prefs not initialised yet (e.g. in isolated widget tests).
      return <String>{};
    }
  }

  static bool contains(String id) => ids.value.contains(id);

  static void toggle(String id) {
    if (id.isEmpty) return;
    final next = Set<String>.of(ids.value);
    if (!next.remove(id)) next.add(id);
    ids.value = next;
    try {
      Prefs.setString(_key, next.join(','));
    } catch (_) {}
  }
}
