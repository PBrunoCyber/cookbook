import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

@immutable
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Navegação Aninhada",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black12,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.laptop_mac_outlined,
              size: 100,
            ),
            SizedBox(height: 20),
            Text("Procurar dispositivos para conectar ao celular")
          ],
        ),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        backgroundColor: Colors.greenAccent,
        onPressed: () => Navigator.of(context).pushNamed("/setup/find_devices"),
      ),
    );
  }
}

class SetupPage extends StatefulWidget {
  SetupPage({
    Key? key,
    required this.subRouteName,
  }) : super(key: key);
  final String subRouteName;

  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final _keyNavigator = GlobalKey<NavigatorState>();

  Route _onGenerationRoute(RouteSettings settings) {
    late Widget page;
    switch (settings.name) {
      case 'find_devices':
        page = Waiting(
            message: "Procurando dispositivos...", onEnd: _selectDivice);
        break;
      case 'select_divice':
        page = SelectDivice(onDiviceSelected: _onDiviceSelected);
        break;
      case 'connecting':
        page = Waiting(message: "Connecting...", onEnd: _onConnectingEnd);
        break;
      case 'finish_page':
        page = DiviceSelected(finishPressed: _finishPressed);
        break;
    }
    return MaterialPageRoute<dynamic>(
      builder: (context) => page,
      settings: settings,
    );
  }

  void _selectDivice() {
    _keyNavigator.currentState!.pushNamed('select_divice');
  }

  void _onDiviceSelected(String id) {
    _keyNavigator.currentState!.pushNamed('connecting');
  }

  void _onConnectingEnd() {
    _keyNavigator.currentState!.pushNamed('finish_page');
  }

  void _finishPressed() {
    Navigator.of(context).pop();
  }

  Future<void> _onExitPressed() async {
    final isConfirmed = await _isExitDesired();

    if (isConfirmed && mounted) {
      _finishPressed();
    }
  }

  Future<bool> _isExitDesired() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Você tem certeza?'),
              content: Text('Se você sair, seu progresso será perdido!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    'Ficar',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'Sair',
                    style: TextStyle(
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _isExitDesired,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: _onExitPressed,
            color: Colors.black,
          ),
          backgroundColor: Colors.black12,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Devices",
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        body: Navigator(
          key: _keyNavigator,
          initialRoute: widget.subRouteName,
          onGenerateRoute: _onGenerationRoute,
        ),
      ),
    );
  }
}

class Waiting extends StatefulWidget {
  Waiting({Key? key, required this.message, required this.onEnd})
      : super(key: key);
  final String message;
  final VoidCallback onEnd;

  @override
  _WaitingState createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {
  @override
  void initState() {
    _startWaiting();
    super.initState();
  }

  Future<void> _startWaiting() async {
    await Future<dynamic>.delayed(const Duration(seconds: 3));
    if (mounted) {
      widget.onEnd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(),
            SizedBox(height: 40),
            Text(widget.message),
          ],
        ),
      ),
    );
  }
}

class SelectDivice extends StatefulWidget {
  SelectDivice({Key? key, required this.onDiviceSelected}) : super(key: key);
  final Function(String id) onDiviceSelected;
  @override
  _SelectDiviceState createState() => _SelectDiviceState();
}

class _SelectDiviceState extends State<SelectDivice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Selecione um dos dispositivos abaixo na se conectar: ",
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Bulb 22n483nk5834"),
                    ElevatedButton(
                      child: Text("Connect"),
                      onPressed: () {
                        widget.onDiviceSelected("22n483nk5834");
                      },
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.resolveWith((states) {
                          return Size.fromHeight(20);
                        }),
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          return Colors.greenAccent;
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiviceSelected extends StatefulWidget {
  DiviceSelected({Key? key, required this.finishPressed}) : super(key: key);
  final VoidCallback finishPressed;
  @override
  _DiviceSelectedState createState() => _DiviceSelectedState();
}

class _DiviceSelectedState extends State<DiviceSelected> {
  late MaterialStateColor finish;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.laptop_mac, size: 60),
            SizedBox(height: 5),
            Text("22n483nk5834 Connected!"),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text("Finalizar"),
              style: ElevatedButton.styleFrom(
                  primary: Colors.greenAccent, elevation: 0),
              onPressed: widget.finishPressed,
            ),
          ],
        ),
      ),
    );
  }
}
