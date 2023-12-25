typedef TTimelineCount = List<bool>;

class PlaybackConfigModel {
  bool muted;
  bool autoplay;

  static const timelineCountDefault = 4;
  TTimelineCount timelineCount;

  PlaybackConfigModel({
    required this.muted,
    required this.autoplay,
    required this.timelineCount,
  });
}
