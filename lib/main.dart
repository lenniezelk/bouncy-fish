import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bouncy Fish',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Bouncy Fish'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Color> colors = [
    Colors.amber,
    Colors.pink,
    Colors.purple,
    Colors.green,
    Colors.blue
  ];
  final path = 'assets/bouncy_fish.riv';
  bool playing = true;
  Artboard artboard;
  SimpleAnimation fishAnimController;

  loadRive() async {
    final data = await rootBundle.load(path);
    final file = RiveFile();
    Artboard _artboard;
    if (file.import(data)) {
      _artboard = file.mainArtboard;
      _artboard..addController(fishAnimController = SimpleAnimation('fish'));
    }
    setState(() => artboard = _artboard);
  }

  @override
  void initState() {
    super.initState();

    loadRive();
  }

  void play() {
    setState(() {
      playing = !playing;
      fishAnimController.isActive = playing;
    });
  }

  changeColor(int index) {
    final shapes = ['body_path', 'lower_tail', 'upper_tail'];
    artboard.forEachComponent((cn) {
      if (shapes.contains(cn.name)) {
        Shape path = cn;
        final fill = path.fills.first;
        fill.paint.color = colors[index];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: 50.0,
                child: ListView.builder(
                    itemCount: colors.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          changeColor(index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: colors[index],
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            if (artboard != null) Expanded(child: Rive(artboard: artboard))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: play,
        child: Icon(playing ? Icons.pause : Icons.play_arrow),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
