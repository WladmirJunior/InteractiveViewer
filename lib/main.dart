import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Image'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  final _transformationController = TransformationController();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isInZoom = false;
  String textButton = 'Zoom In';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InteractiveViewer(
              maxScale: 4.0,
              transformationController: widget._transformationController,
              child: Image.asset('assets/atelectasiaLoboSuperiorEsquerdo.png'),
              onInteractionUpdate: (scaleDetails) {
                final scaleX = widget._transformationController.value.row0.x;
                final scaleY = widget._transformationController.value.row1.y;
                if (scaleX > 1.2 || scaleY > 1.2) {
                  setState(() {
                    textButton = 'Zoom Out';
                    isInZoom = true;
                  });
                } else {
                  setState(() {
                    textButton = 'Zoom In';
                    isInZoom = false;
                  });
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                print('onPressed');
                setState(() {
                  if (isInZoom) {
                    print('Fazer zoom out');
                    makeZoomOut();
                  } else {
                    print('Fazer zoom in');
                    makeZoomIn(context);
                  }
                });
              },
              child: Text(textButton),
            ),
          ],
        ),
      ),
    );
  }

  void makeZoomIn(BuildContext context) {
    textButton = 'Zoom Out';
    isInZoom = true;
    double width = MediaQuery.of(context).size.width;
    widget._transformationController.value = Matrix4.compose(
      Vector3(-width / 4, -width / 4, 0.0),
      Quaternion.identity(),
      Vector3(1.5, 1.5, 1.0),
    );
  }

  void makeZoomOut() {
    textButton = 'Zoom In';
    isInZoom = false;
    widget._transformationController.value = Matrix4.identity();
  }
}
