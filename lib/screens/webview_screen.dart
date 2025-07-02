import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebViewController? _controller;
  bool _isLoading = true;
  bool hasInternet = true;

  late final StreamSubscription<InternetStatus> _internetSubscription;

  static const String homeUrl = 'https://bideshibazar.com';
  static const String loginUrl = 'https://bideshibazar.com/user/login';

  @override
  void initState() {
    super.initState();
    _initializeWebViewController();
    _initInternetListener();
  }

  Future<void> _initInternetListener() async {
    hasInternet = await InternetConnection().hasInternetAccess;
    if (mounted) setState(() {});

    _internetSubscription = InternetConnection().onStatusChange.listen((status) async {
      final bool netAvailable = status == InternetStatus.connected;
      if (!mounted) return;
      if (netAvailable != hasInternet) setState(() => hasInternet = netAvailable);
      if (netAvailable) await _reloadSafely();
    });
  }

  @override
  void dispose() {
    _internetSubscription.cancel();
    super.dispose();
  }

  void _initializeWebViewController() {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final url = request.url;

            // ✅ Detect Google login URL
            if (url.contains('accounts.google.com/o/oauth2/auth')) {
              Navigator.pushNamed(context, '/login/google');
              return NavigationDecision.prevent;
            }

            // ✅ Detect Apple login redirect (optional)
            if (url.contains('appleid.apple.com/auth/authorize')) {
              Navigator.pushNamed(context, '/login/apple');
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            if (error.errorType == WebResourceErrorType.hostLookup ||
                error.errorType == WebResourceErrorType.connect) {
              if (mounted) setState(() => hasInternet = false);
            }
          },
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(homeUrl));

    setState(() {
      _controller = controller;
      _isLoading = true;
    });
  }

  Future<void> _reloadSafely() async {
    final urlString = await _controller?.currentUrl() ?? homeUrl;
    _controller?.loadRequest(Uri.parse(urlString));
    setState(() => _isLoading = true);
  }

  Future<void> _refreshPage() async {
    hasInternet = await InternetConnection().hasInternetAccess;
    setState(() {});
    if (hasInternet) {
      await _reloadSafely();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No internet connection!')));
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (_controller != null && await _controller!.canGoBack()) {
      _controller!.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 6,
          backgroundColor: Colors.white,
          elevation: 1,
          actions: [
            IconButton(
                icon: const Icon(Icons.refresh, color: Colors.black),
                onPressed: _refreshPage),
          ],
        ),
        body: hasInternet
            ? Stack(
          children: [
            if (_controller != null) WebViewWidget(controller: _controller!),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ],
        )
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 80, color: Colors.red),
              const SizedBox(height: 20),
              const Text('No internet connection!',
                  style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _refreshPage, child: const Text('Try again')),
            ],
          ),
        ),
      ),
    );
  }
}
