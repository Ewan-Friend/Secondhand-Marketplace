import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;
  //sign in with email and password
  Future<AuthResponse> signInwithEmailpassword(
        String email, String password) async {
          return await supabase.auth.signInWithPassword(
            email:email,
            password:password);
        }
  
  //sign up with email and password
Future<AuthResponse> signUpWithEmailPassword({
  required String email,
  required String password,
  String? emailRedirectTo,
}) async {
  return await supabase.auth.signUp(
    email: email,
    password: password,
    emailRedirectTo: emailRedirectTo, // Web verification bounce-back
  );
}


  //sign out
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
  
   //get user email
  String? getCurrentUserEmail() {
    final session = supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}
