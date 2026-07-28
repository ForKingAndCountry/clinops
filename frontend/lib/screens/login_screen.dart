import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/service_locator.dart';
import '../repositories/auth_repository.dart';
import '../theme/clinops_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthRepository _authRepository = getIt<AuthRepository>();
  
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _authRepository.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClinOpsTheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(ClinOpsTheme.space4),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ClinOps wordmark with Thread motif
                    _buildWordmark(),
                    const SizedBox(height: ClinOpsTheme.space5),
                    
                    // Login form
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: ClinOpsTheme.space2),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outlined),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: ClinOpsTheme.space3),
                    
                    // Error message
                    if (_error != null)
                      Container(
                        padding: const EdgeInsets.all(ClinOpsTheme.space2),
                        decoration: BoxDecoration(
                          color: ClinOpsTheme.danger.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(ClinOpsTheme.radius),
                          border: Border.all(
                            color: ClinOpsTheme.danger,
                            width: ClinOpsTheme.borderWidth,
                          ),
                        ),
                        child: Text(
                          _error!,
                          style: GoogleFonts.inter(
                            color: ClinOpsTheme.danger,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    
                    if (_error != null) const SizedBox(height: ClinOpsTheme.space2),
                    
                    // Login button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Sign in'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWordmark() {
    return Column(
      children: [
        // ClinOps text
        Text(
          'ClinOps',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 48,
            fontWeight: FontWeight.w600,
            color: ClinOpsTheme.primary,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 8),
        
        // Thread motif - thin connecting line
        CustomPaint(
          size: const Size(double.infinity, 2),
          painter: const _ThreadPainter(),
        ),
        const SizedBox(height: 8),
        
        // Tagline
        Text(
          'Clinical Operations System',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: ClinOpsTheme.muted,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _ThreadPainter extends CustomPainter {
  const _ThreadPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ClinOpsTheme.accent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw a subtle flowing line
    final path = Path();
    final width = size.width;
    
    path.moveTo(0, 1);
    path.quadraticBezierTo(
      width * 0.25, 0,
      width * 0.5, 1,
    );
    path.quadraticBezierTo(
      width * 0.75, 2,
      width, 1,
    );
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
