import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

class VideosRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask uploadVideoFile(File video, String uid) {
    final fileRef = _storage.ref().child(
          "/videos/$uid/${DateTime.now().millisecondsSinceEpoch.toString()}",
        );
    return fileRef.putFile(video);
  }

  Future<void> saveVideo(VideoModel data) async {
    await _db.collection("videos").add(data.toJson());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos(
      {int? lastItemCreatedAt}) {
    final query = _db
        .collection("videos")
        .orderBy(
          "createdAt",
          descending: true,
        )
        .limit(2);
    if (lastItemCreatedAt == null) {
      return query.get();
    } else {
      return query.startAfter([lastItemCreatedAt]).get();
    }
  }

  Future<Map<String, dynamic>> _likeVideo({
    required String videoId,
    required String userId,
  }) async {
    final query = _db.collection("likes").doc("${videoId}000$userId");
    final like = await query.get();
    return {"query": query, "exists": like.exists};
  }

  Future<bool> likeVideo({
    required String videoId,
    required String userId,
  }) async {
    final likeData = await _likeVideo(videoId: videoId, userId: userId);
    final query = likeData["query"] as DocumentReference<Map<String, dynamic>>;
    final exists = likeData["exists"] as bool;

    if (!exists) {
      await query.set(
        {
          "createdAt": DateTime.now().millisecondsSinceEpoch,
        },
      );
    } else {
      await query.delete();
    }
    return !exists;
  }

  Future<bool> isLikeVideo({
    required String videoId,
    required String userId,
  }) async {
    final likeData = await _likeVideo(videoId: videoId, userId: userId);
    return likeData["exists"] as bool;
  }
}

final videosRepo = Provider((ref) => VideosRepository());
