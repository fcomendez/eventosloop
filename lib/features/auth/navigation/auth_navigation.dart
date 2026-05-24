import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/features/auth/views/login_view.dart';
import 'package:eventosloop/features/feed/views/feed_home_view.dart';
import 'package:eventosloop/features/onboarding/services/intereses_service.dart';
import 'package:eventosloop/features/onboarding/views/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthNavigation {
  const AuthNavigation._();

  static Future<void> navigateAfterAuth(
    BuildContext context, {
    required String email,
  }) async {
    final bool tieneIntereses =
        await InteresesService().usuarioTieneIntereses();
    if (!context.mounted) {
      return;
    }
    if (tieneIntereses) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) => FeedHomeView(email: email),
        ),
        (_) => false,
      );
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => const WelcomeView(),
      ),
      (_) => false,
    );
  }

  static Future<void> navigateFromSplash(BuildContext context) async {
    if (!AppEnv.useSupabase) {
      _goLogin(context);
      return;
    }

    final Session? session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      _goLogin(context);
      return;
    }

    await navigateAfterAuth(
      context,
      email: session.user.email ?? '',
    );
  }

  static void _goLogin(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginView()),
      (_) => false,
    );
  }

  static Future<void> cerrarSesion(BuildContext context) async {
    if (AppEnv.useSupabase) {
      await Supabase.instance.client.auth.signOut();
    }
    if (!context.mounted) {
      return;
    }
    _goLogin(context);
  }
}
