import 'package:flutter/material.dart';

import '../services/auth_store.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'calendar_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _openRegister() async {
    final registered = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => const RegisterScreen(),
      ),
    );
    if (registered == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro concluído. Entre na sua conta.')),
      );
    }
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    final user = AuthStore.authenticate(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email ou senha não conferem.')),
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => CalendarScreen(userName: user.name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _AuthBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _BrandMark(),
                    const SizedBox(height: 42),
                    const Text(
                      'Seu dia,\nno seu ritmo.',
                      style: TextStyle(
                        fontSize: 38,
                        height: 1.12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Entre para deixar as ideias em movimento.',
                      style: TextStyle(
                        color: Color(0xFF9BA2B7),
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _GlassPanel(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: _emailController,
                              label: 'Email',
                              hint: 'voce@email.com',
                              icon: Icons.alternate_email_rounded,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                final email = value?.trim() ?? '';
                                if (email.isEmpty || !email.contains('@')) {
                                  return 'Informe um email válido.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _passwordController,
                              label: 'Senha',
                              icon: Icons.lock_outline_rounded,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Informe sua senha.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            CustomButton(
                              label: 'Entrar',
                              icon: Icons.arrow_forward_rounded,
                              onPressed: _login,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text(
                            'Ainda não tem uma conta? ',
                            style: TextStyle(color: Color(0xFF9BA2B7)),
                          ),
                          TextButton(
                            onPressed: _openRegister,
                            child: const Text(
                              'Criar conta',
                              style: TextStyle(
                                color: Color(0xFF35E0C1),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Center(
                      child: Text(
                        'SEU ESPAÇO. SEU FOCO. SEU DIA.',
                        style: TextStyle(
                          color: Color(0xFF666D82),
                          fontSize: 10,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
}

class _AuthBackground extends StatelessWidget {
  const _AuthBackground({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -110,
          right: -100,
          child: _Glow(color: const Color(0xFF7C4DFF).withOpacity(0.16)),
        ),
        Positioned(
          bottom: -120,
          left: -110,
          child: _Glow(color: const Color(0xFF35E0C1).withOpacity(0.1)),
        ),
        child,
      ],
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withOpacity(0)],
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF35E0C1), Color(0xFF8B5CF6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.bolt_rounded, color: Color(0xFF090B14)),
        ),
        const SizedBox(width: 12),
        const Text(
          'neon daily',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _GlassPanel extends StatelessWidget {
  const _GlassPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.055),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}
