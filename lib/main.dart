import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        // useMaterial3: true, // Não é mais necessário no Flutter 2.5.0 e superior
      ),
      home: const GymBrowser(),
    );
  }
}

class GymBrowser extends StatefulWidget {
  const GymBrowser({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GymBrowserState createState() => _GymBrowserState();
}

class _GymBrowserState extends State<GymBrowser> {
  late WebViewController _webViewController;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.black,
        foregroundColor: Colors.amber,
        toolbarHeight: 30,
        /*
        leading: IconButton(
          icon: const Icon(Icons.home), // Ícone de casa adicionado aqui
          onPressed: () {
            // Adicione sua lógica de navegação para a tela inicial aqui
          },
        ),
        */
      ),
      body: Column(
        children: [
          Visibility(
            visible: true, // Define o widget como invisível
            child: Positioned(
              top: 20, // Define a posição do topo
              left: 20, // Define a posição da esquerda

              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                    labelText: 'URL',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _webViewController.loadUrl(value);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 1.0),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: WebView(
                initialUrl: 'https://gym-aluno.esystem.com.br/',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _webViewController = webViewController;
                },
              ),
            ),
          ),
          Visibility(
            visible: false, // Define o widget como invisível
            child: ElevatedButton(
              onPressed: () {
                _webViewController.reload();
              },
              child: const Text('Recarregar'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
