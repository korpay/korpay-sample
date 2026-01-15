import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_intent_app_launcher/flutter_intent_app_launcher.dart';
import 'ios_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _WebViewState();
}

class _WebViewState extends State<MyApp> {
  InAppWebViewController? _webViewController;

  Future<void> _handleAndroidIntent(
    String url,
    String originUrl,
    FlutterIntentAppLauncher launcher,
  ) async {
    try {
      String finalUrl = url;
      await launcher.getAppUrl(url).then((value) async {
        finalUrl = value ?? url;
      });

      // 앱 실행 시도
      await launchUrlString(
        finalUrl,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      var packageName = await launcher.getPackageName(originUrl);
      if (packageName != null && packageName.isNotEmpty) {
        var playStoreUrl = 'market://details?id=$packageName';
        try {
          await launchUrlString(playStoreUrl);
        } catch (e) {
          debugPrint('DEBUG 플레이스토어 이동 실패: $e');
        }
      }
    }
  }

  Future<void> _handleIosIntent(String url, BuildContext context) async {
    try {
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        return;
      }
      final scheme = uri.scheme;
      final storeUrlString = getAppStoreUrl(scheme); // ios_utils의 함수

      if (storeUrlString != null) {
        final storeUri = Uri.parse(storeUrlString);
        if (await canLaunchUrl(storeUri)) {
          await launchUrl(storeUri);
        } else {
          _showAlert(context, '오류', '스토어 링크를 열 수 없습니다.');
        }
      } else {
        _showAlert(context, '오류', '스토어 정보를 찾을 수 없습니다.');
      }
    } catch (e) {
      debugPrint('iOS intent handling error: $e');
    }
  }

  void _showAlert(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final launcher = FlutterIntentAppLauncher();

    return SafeArea(
        child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;

              final controller = _webViewController;
              if (controller == null) return;

              if (await controller.canGoBack()) {
                controller.goBack();
                return;
              }

              SystemNavigator.pop();
              return;
            },
            child: Scaffold(
              body: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri('http://localhost:80/auth.php'),
                ),
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  allowsBackForwardNavigationGestures: true,
                ),
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  final uri = navigationAction.request.url!;
                  final String originUrl = uri.rawValue;
                  String url = uri.rawValue;

                  if (url.startsWith('http') ||
                      url.startsWith('https') ||
                      url.startsWith('about')) {
                    return NavigationActionPolicy.ALLOW;
                  }

                  if (Platform.isAndroid) {
                    await _handleAndroidIntent(url, originUrl, launcher);
                  } else if (Platform.isIOS) {
                    await _handleIosIntent(url, context);
                  }

                  return NavigationActionPolicy.CANCEL;
                },
              ),
            )));
  }
}
