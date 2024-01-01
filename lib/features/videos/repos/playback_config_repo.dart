import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaybackConfigRepository {
  static const String _autoplay = "autoplay";
  static const String _muted = "muted";
  final SharedPreferences sharedPrefs;

  PlaybackConfigRepository({
    required this.sharedPrefs,
  });

  Future<void> setMuted(bool value) async {
    await sharedPrefs.setBool(_muted, value);
  }

  Future<void> setAutoplay(bool value) async {
    await sharedPrefs.setBool(_autoplay, value);
  }

  bool isMuted() {
    return sharedPrefs.getBool(_muted) ?? false;
  }

  bool isAutoplay() {
    return sharedPrefs.getBool(_autoplay) ?? false;
  }
}

final playbackRepo = Provider(
  (ref) async {
    return PlaybackConfigRepository(
      sharedPrefs: await SharedPreferences.getInstance(),
    );
  },
);
