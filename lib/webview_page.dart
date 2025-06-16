// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class WebViewPage extends StatefulWidget {
//   const WebViewPage({super.key});
//
//   @override
//   State<WebViewPage> createState() => _WebViewPageState();
// }
//
// class _WebViewPageState extends State<WebViewPage> {
//   late final WebViewController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onNavigationRequest: (request) {
//             final url = request.url;
//
//             if (url.contains("bideshibazar.com/user/login")) {
//               return NavigationDecision.navigate;
//             }
//
//             if (url.contains("accounts.google.com/o/oauth2/auth")) {
//               _showGoogleLoginBlockedDialog();
//               return NavigationDecision.prevent;
//             }
//
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse("https://bideshibazar.com/user/login"));
//   }
//
//   void _showGoogleLoginBlockedDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Login Not Supported"),
//         content: const Text(
//           "Google login is not supported inside the app. Please open in browser to continue.",
//         ),
//         actions: [
//           TextButton(
//             child: const Text("OK"),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Login"),
//       ),
//       body: WebViewWidget(controller: _controller),
//     );
//   }
// }
