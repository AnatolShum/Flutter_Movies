import 'package:movies/services/auth/auth_provider.dart';
import 'package:movies/services/auth/auth_user.dart';
import 'package:movies/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String userName,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        userName: userName,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> signOut() => provider.signOut();
  
  @override
  Future<void> initialize() => provider.initialize();
  
  @override
  Future<void> sendPasswordReset(String email) => provider.sendPasswordReset(email);
}
