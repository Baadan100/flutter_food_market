import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import '../data/firebase_auth_repository.dart';

class AuthState {
  final AppUser? user;
  final String? errorMessage;
  final bool isLoading;
  
  const AuthState({
    this.user,
    this.errorMessage,
    this.isLoading = false,
  });
  
  bool get isSignedIn => user != null;
  
  AuthState copyWith({
    AppUser? user,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AuthState(
      user: user ?? this.user,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final FirebaseAuthRepository _authRepository;
  
  AuthController(this._authRepository) : super(const AuthState()) {
    // الاستماع لتغييرات حالة المصادقة
    _authRepository.authStateChanges.listen((user) {
      state = state.copyWith(user: user, errorMessage: null);
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final user = await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> signUp(String email, String password, {String? name}) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final user = await _authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );
      
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> signInAnonymously() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final user = await _authRepository.signInAnonymously();
      
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _authRepository.resetPassword(email);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> updateProfile({String? name, String? photoUrl}) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final user = await _authRepository.updateProfile(
        displayName: name,
        photoUrl: photoUrl,
      );
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        isLoading: false,
      );
      rethrow;
    }
  }
}

// Provider للـ Repository
final firebaseAuthRepositoryProvider = Provider<FirebaseAuthRepository>((ref) {
  return FirebaseAuthRepository();
});

// Provider للـ AuthController
final authProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repository = ref.read(firebaseAuthRepositoryProvider);
  return AuthController(repository);
});
