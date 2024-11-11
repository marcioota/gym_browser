import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atlas Coach Center',
      theme: ThemeData(
          // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red,
          // useMaterial3: true, // Não é mais necessário no Flutter 2.5.0 e superior
          ),
      home: const GymBrowser(),
    );
  }
}

class GymBrowser extends StatefulWidget {
  const GymBrowser({Key? key}) : super(key: key);

  @override
  _GymBrowserState createState() => _GymBrowserState();
}

class _GymBrowserState extends State<GymBrowser> {
  late WebViewController _webViewController;
  final TextEditingController _textEditingController = TextEditingController();

  // Instância do plugin de notificações
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();

    // Inicializar o plugin de notificações
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Configurações de inicialização para Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configurações de inicialização para iOS
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    // Configurações de inicialização geral
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Inicializar o plugin com as configurações de inicialização
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atlas Coach Center'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.amber,
        toolbarHeight: 30,
      ),
      body: Column(
        children: [
          Visibility(
            visible: false, // Define o widget como invisível
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
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: WebView(
                initialUrl: 'https://gym-aluno.atlascoachcenter.com.br',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _webViewController = webViewController;
                },
                javascriptChannels: <JavascriptChannel>{
                  _notificationJavascriptChannel(context),
                },
              ),
            ),
          ),
          Visibility(
            visible: true, // Define o widget como invisível
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

  JavascriptChannel _notificationJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Notification',
        onMessageReceived: (JavascriptMessage message) {
          // Espera mensagens no formato "title|body"
          var parts = message.message.split('|');
          if (parts.length == 2) {
            _showNotification(parts[0], parts[1]);
          }
        });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
