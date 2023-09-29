import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import "package:webview_in_flutter/browser_menu.dart";
import 'package:webview_flutter/webview_flutter.dart';

class NavigationControls extends StatefulWidget {
  const NavigationControls({required this.controller, super.key});

  @override
  State<NavigationControls> createState() => _NavigationControlState();
  final WebViewController controller;
}

class _NavigationControlState extends State<NavigationControls>{
  bool canGoBack = false;
  bool canGoForward = false;

@override
  void initState() {
    super.initState();
    widget.controller
      .setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) async {
          var mayGoBack = await widget.controller.canGoBack();
          var mayGoForward = await widget.controller.canGoForward();

          // Do not async/await for setState itself!
          // https://stackoverflow.com/a/72307793
          setState(() {
            canGoBack = mayGoBack;
            canGoForward = mayGoForward;
          });
        },
        // // May be useful should we desire to handle Keyman keyboard download links
        // // in a special manner from the browser app.
        // onNavigationRequest: (navigation) {
        //   final host = Uri.parse(navigation.url).host;
        //   if (host.contains('youtube.com')) {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(
        //         content: Text('Blocking navigation to $host')
        //       )
        //     );

        //     return NavigationDecision.prevent;
        //   }
        //   return NavigationDecision.navigate;
        // }
      ));
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            iconSize: 18.0,
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: !canGoBack ? null : () {
              if (canGoBack) {
                widget.controller.goBack();
              }
            },
          ),
          IconButton(
            iconSize: 18.0,
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: !canGoForward ? null : () {
              if (canGoForward) {
                widget.controller.goForward();
              }
            },
          ),

          IconButton(
          icon: const Icon(Icons.share),
          onPressed: () async {
            final String appLink = 'https://play.google.com/store/apps/details?id=com.example.myapp';
            final String message = 'Check out my new app: $appLink';
            await FlutterShare.share(title: 'Share App ', text: message, linkUrl: appLink);
          }
        ),
          const Spacer(),
          const BrowserMenu()
        ],
      )
    );
  }
}