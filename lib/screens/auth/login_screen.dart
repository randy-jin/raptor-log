import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/app_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  bool _loading = false;
  bool _sent = false;
  String? _error;

  Future<void> _sendMagicLink() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) return;
    setState(() { _loading = true; _error = null; });
    try {
      await Supabase.instance.client.auth.signInWithOtp(
        email: email,
        emailRedirectTo: 'io.raptorlog.app://login-callback',
      );
      if (mounted) setState(() { _sent = true; _loading = false; });
    } on AuthException catch (e) {
      if (mounted) setState(() { _error = e.message; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _cycleLocale() {
    final current = ref.read(localeProvider);
    final locales = supportedLocales;
    final idx = locales.indexWhere((l) => l.languageCode == current.languageCode);
    final next = locales[(idx + 1) % locales.length];
    ref.read(localeProvider.notifier).state = next;
  }

  String _localeLabel(String code) {
    switch (code) {
      case 'zh': return '中文';
      case 'fr': return 'FR';
      default: return 'EN';
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appStringsProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _cycleLocale,
                  child: Text(_localeLabel(locale.languageCode),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const Spacer(),
              const Text('🦅', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text(
                'RaptorLog',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2E7D32),
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '${s.tagline1}\n${s.tagline2}',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.grey[600]),
              ),
              const Spacer(),
              if (!_sent) ...[
                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: s.emailLabel,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  onSubmitted: (_) => _sendMagicLink(),
                ),
                const SizedBox(height: 16),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(_error!,
                        style: const TextStyle(color: Colors.red)),
                  ),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: _loading ? null : _sendMagicLink,
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(s.sendMagicLink,
                            style: const TextStyle(fontSize: 16)),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF66BB6A)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.checkEmailTitle,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text(
                        s.checkEmailBody(_emailCtrl.text),
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => setState(() => _sent = false),
                  child: Text(s.useDifferentEmail),
                ),
              ],
              const Spacer(),
              Center(
                child: Text(
                  s.noPassword,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
