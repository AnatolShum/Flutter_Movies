import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  final DateTime creationTime;
  final String userName;
  final String email;
  const AuthUser(
    this.isEmailVerified,
    this.creationTime,
    this.userName,
    this.email,
  );

  factory AuthUser.fromFirebase(User user) => AuthUser(
        user.emailVerified,
        user.metadata.creationTime ?? DateTime.now(),
        user.displayName ?? 'N/A',
        user.email ?? 'N/A',
      );
}
