import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _webviewController = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Login Example'),
        ),
        body: PageHtml(webviewController: _webviewController),
      ),
    );
  }
}

class PageHtml extends StatelessWidget {
  const PageHtml({
    Key? key,
    required Completer<WebViewController> webviewController,
  })  : _webviewController = webviewController,
        super(key: key);

  final Completer<WebViewController> _webviewController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: WebView(
            initialUrl:
                'https://pergamum.ifc.edu.br/pergamum_ifc/biblioteca_s/php/login_usu.php',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              _webviewController.complete(controller);
            },
            onPageFinished: (url) async {
              final controller = await _webviewController.future;
              const username = '2020006767';
              const password = '4554';
              // Preencher o formulário de login com as credenciais
              await controller.runJavascript('''
                var username = document.getElementById("id_login");
                var password = document.getElementById("id_senhaLogin");
                var form = document.getElementsByTagName("form")[0];
                username.value = '$username';
                password.value = '$password';
                form.submit();
              ''');
            },
          ),
        ),
        FutureBuilder<String>(
          future: _getPageData(),
          builder: (context, snapshot) {
            print(context);
            print(snapshot);
            print(_getPageData());
            if (snapshot.connectionState == ConnectionState.done) {
              return Text(snapshot.data ?? 'Nenhum dado encontrado.');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }

  Future<String> _getPageData() async {
    final controller = await _webviewController.future;
    return controller.runJavascriptReturningResult('''
      // Inserir aqui o código para extrair os dados desejados da página
      document.querySelector("#Accordion1 > div.AccordionPanel.AccordionPanelOpen > div.c1 > table > tbody > tr:nth-child(2) > td:nth-child(2) > a").textContent
    ''');
  }
}
