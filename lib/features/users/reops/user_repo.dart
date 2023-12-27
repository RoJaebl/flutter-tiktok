import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class UserRepository {
  /// creat eprofile
  /// get profile
  /// TODO: update eprofile
  /// / update avatar
  /// / update bio
  /// / update link
  /// / update etc..
  ///

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createProfile(UserProfileModel user) async {}
}

final userRepo = Provider(
  (ref) => UserRepository(),
);
