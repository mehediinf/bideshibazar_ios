import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

class GoogleLoginPage extends StatefulWidget {
  const GoogleLoginPage({super.key});

  @override
  State<GoogleLoginPage> createState() => _GoogleLoginPageState();
}

class _GoogleLoginPageState extends State<GoogleLoginPage> {
  Future<void> _loginWithGoogle() async {
    const callbackUrlScheme = 'myapp'; // must match Info.plist
    const loginUrl = 'https://bideshibazar.com/login/google';

    try {
      final result = await FlutterWebAuth2.authenticate(
        url: loginUrl,
        callbackUrlScheme: callbackUrlScheme,
      );

      final uri = Uri.parse(result);
      final accessToken = uri.queryParameters['access_token'];
      final idToken = uri.queryParameters['id_token'];

      print('Google Access Token: $accessToken');
      print('Google ID Token: $idToken');

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print('Google Login failed: $e');
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _loginWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
