import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

class AppleLoginPage extends StatefulWidget {
  const AppleLoginPage({super.key});

  @override
  State<AppleLoginPage> createState() => _AppleLoginPageState();
}

class _AppleLoginPageState extends State<AppleLoginPage> {
  Future<void> _loginWithApple() async {
    const callbackUrlScheme = 'myapp'; // must match Info.plist
    const loginUrl = 'https://bideshibazar.com/login/apple';

    try {
      final result = await FlutterWebAuth2.authenticate(
        url: loginUrl,
        callbackUrlScheme: callbackUrlScheme,
      );

      final uri = Uri.parse(result);
      final accessToken = uri.queryParameters['access_token'];
      final idToken = uri.queryParameters['id_token'];

      print('✅ Access Token: $accessToken');
      print('🆔 ID Token: $idToken');

      // TODO: Save token, load user info, etc.
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home'); // Go to WebView or Main screen
    } catch (e) {
      print('❌ Login failed: $e');
      if (!mounted) return;
      Navigator.pop(context); // Back to previous screen
    }
  }

  @override
  void initState() {
    super.initState();
    _loginWithApple();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
