import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _error;
  bool _isSignUp = false;

  Future _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await _supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } catch (e) {
      setState(() {
        _error = 'Error signing in: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future _signUpWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await _supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      setState(() {
        _error = 'Sign-up successful! Please check your email to verify.';
      });
    } catch (e) {
      setState(() {
        _error = 'Error signing up: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future _signOut() async {
    await _supabase.auth.signOut();
    setState(() {
      _emailController.clear();
      _passwordController.clear();
      _error = null;
      _isSignUp = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _supabase.auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade600, Colors.purple.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.purple.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (user != null) ...[
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Welcome, ${user.email ?? 'User'}!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _signOut,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade400,
                            ),
                            child: const Text(
                              'Sign Out',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(
                                r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            obscureText: true,
                            autofillHints: const [AutofillHints.password],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ChoiceChip(
                                label: const Text('Sign In'),
                                selected: !_isSignUp,
                                selectedColor: Colors.blue.shade200,
                                backgroundColor: Colors.grey.shade200,
                                onSelected: (selected) {
                                  if (selected)
                                    setState(() => _isSignUp = false);
                                },
                              ),
                              const SizedBox(width: 10),
                              ChoiceChip(
                                label: const Text('Sign Up'),
                                selected: _isSignUp,
                                selectedColor: Colors.blue.shade200,
                                backgroundColor: Colors.grey.shade200,
                                onSelected: (selected) {
                                  if (selected)
                                    setState(() => _isSignUp = true);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed:
                                _isLoading
                                    ? null
                                    : _isSignUp
                                    ? _signUpWithEmail
                                    : _signInWithEmail,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                            ),
                            child:
                                _isLoading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : Text(
                                      _isSignUp
                                          ? 'Sign Up with Email'
                                          : 'Sign In with Email',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 20),
                            Text(
                              _error!,
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
