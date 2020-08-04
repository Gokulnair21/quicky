import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/provider/theme_provider.dart';
import 'package:note_app/screen/paint/paint_detailed_view.dart';
import 'package:note_app/widget/list_tile_document.dart';
import 'package:note_app/model/drwaing_points_model.dart';
import 'dart:ui' as ui;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class PainterDocument extends StatefulWidget {
  final String appBarTitle;

  PainterDocument({this.appBarTitle});

  @override
  _PainterDocumentState createState() => _PainterDocumentState();
}

class _PainterDocumentState extends State<PainterDocument> {
  int _currentIndex = 0;

  final Color white = Colors.white;
  final Color black = Colors.black;
  final Color whiteVariant = Color(0xfff8f8f8);
  Color selectedColor = Colors.black;
  Color colorOfPicker = Colors.black;

  double strokeWidth = 3.0;
  List<DrawingPoint> pointsDrawn = List();
  StrokeCap strokeCap = StrokeCap.round;

  List<Color> containerColor = [
    Colors.red,
    Colors.yellowAccent,
    Colors.orange,
    Colors.blue,
    Colors.green,
    Colors.indigo,
    Colors.pink,
    Colors.black,
    Colors.deepOrangeAccent,
    Colors.cyan,
    Colors.grey,
    Colors.purpleAccent,
    Colors.amber,
    Colors.lime,
    Colors.teal,
  ];

  final titleController = TextEditingController();
  double _lowerValue = 3;

  ByteData imgBytes;
  bool gridLayout;
  bool showEdit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showEdit = true;
    gridLayout = false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = Provider.of<SettingsProvider>(context).bloc;

    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () => Navigator.pop(context)),
          elevation: 0.0,
          title: Text(
            widget.appBarTitle,
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: <Widget>[
            IconButton(
              color: (pointsDrawn.length != 0)
                  ? Theme.of(context).iconTheme.color
                  : Theme.of(context).iconTheme.color.withAlpha(50),
              tooltip: 'Proceed',
              onPressed: () => proceedToPaintDetailedViewer(),
              icon: Icon(Icons.arrow_forward_ios),
            ),
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  showEdit = !showEdit;
                  setState(() {});
                }),
            popUpMenuInAppbar()
          ],
        ),
        body: GestureDetector(
            onPanStart: (details) {
                setState(() {
                  RenderBox renderBox = context.findRenderObject();
                  pointsDrawn.add(DrawingPoint(
                      offset: renderBox.globalToLocal(details.localPosition),
                      paint: Paint()
                        ..color = selectedColor
                        ..isAntiAlias = true
                        ..strokeWidth = strokeWidth
                        ..strokeCap = strokeCap));
                });
            },
            onPanUpdate: (details) {
              setState(() {
                RenderBox renderBox = context.findRenderObject();
                pointsDrawn.add(DrawingPoint(
                    offset: renderBox.globalToLocal(details.localPosition),
                    paint: Paint()
                      ..color = selectedColor
                      ..isAntiAlias = true
                      ..strokeWidth = strokeWidth
                      ..strokeCap = strokeCap));
              });
            },
            onPanEnd: (details) {
              setState(() {
                pointsDrawn.add(null);
              });
            },
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(color: white),
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: DrawingPainter(
                      pointsList: pointsDrawn,
                    ),
                  ),
                ),
                StreamBuilder<int>(
                  stream:bloc.gridLength ,
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      if (gridLayout) {
                        return Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: CustomPaint(
                            painter: GridLayout(
                              length: snapshot.data,
                                height: size.height.toInt(),
                                width: size.width.toInt()),
                          ),
                        );
                      }
                      else {
                        return SizedBox();
                      }
                    }
                    return SizedBox();
                  },
                )

              ],
            )),
        bottomNavigationBar: (showEdit) ? bottomNav(context) : SizedBox());
  }

  Widget bottomNav(BuildContext context) {
    return BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        onTap: (index) => onTap(index, context),
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.undo,
                color: (pointsDrawn.length != 0)
                    ? Theme.of(context).iconTheme.color
                    : Theme.of(context).iconTheme.color.withAlpha(50),
              ),
              title: Text('All')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.line_weight,
              ),
              title: Text('All')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.color_lens,
                color: showColor(),
              ),
              title: Text('All')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.mode_edit,
              ),
              title: Text('All')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.check_box_outline_blank,
              ),
              title: Text('All')),
        ]);
  }

  Widget popUpMenuInAppbar() {
    return PopupMenuButton(
        tooltip: 'More',
        onSelected: (index) => popUpMenuFunction(index),
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text(
                  'Clear\tAll',
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Show\tGrid',
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Checkbox(
                          checkColor: Theme.of(context).primaryColor,
                          activeColor: Theme.of(context).iconTheme.color,
                          value: gridLayout,
                          onChanged: (val) {
                            setState(() {
                              gridLayout = !gridLayout;
                            });
                            Navigator.pop(context);
                          }),
                    )
                  ],
                ),
              ),
            ]);
  }

  void strokeSetter(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: <Widget>[
                ListTile(
                  onTap: () {
                    setState(() {
                      strokeCap = StrokeCap.round;
                    });
                    Navigator.pop(context);
                  },
                  title: Text(
                    'Round',
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      strokeCap = StrokeCap.square;
                    });
                    Navigator.pop(context);
                  },
                  title: Text(
                    'Square',
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      strokeCap = StrokeCap.butt;
                    });
                    Navigator.pop(context);
                  },
                  title: Text(
                    'Button',
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  void colorBottomSheetSetter(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (context) => SafeArea(
            child: Container(
                width: double.infinity,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                      child: Center(
                        child: FittedBox(
                          child: Text(
                            'Choose a brush color',
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      child: ListView.builder(
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: containerColor.length,
                          itemBuilder: (context, index) {
                            return colorContainer(
                                containerColor[index], index, context);
                          }),
                    ),
                    ListTileOfDocs(
                      icon: Icons.colorize,
                      label: 'Custom color',
                      onTap: () => dialogBoxCustomPainter(),
                    )
                  ],
                ))));
  }

  Widget colorContainer(Color color, int index, BuildContext context) {
    return InkWell(
      onTap: () => setColor(index, context),
      child: Container(
        height: 30,
        width: 30,
        margin: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }

  void strokeWidthDialogBoxSetter(BuildContext context) {
    double _upperValue = 20;
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 4.0,
            child: StatefulBuilder(builder: (context, changeState) {
              return Container(
                child: Wrap(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                      child: Center(
                        child: FittedBox(
                          child: Text(
                            'Pen Size',
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: Center(
                        child: FittedBox(
                          child: Text(
                            _lowerValue.toInt().toString(),
                            style: GoogleFonts.lato(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      child: FlutterSlider(
                        tooltip: FlutterSliderTooltip(
                          disabled: true,
                        ),
                        trackBar: FlutterSliderTrackBar(
                          inactiveTrackBar: BoxDecoration(
                            color: black.withAlpha(50),
                          ),
                          activeTrackBar: BoxDecoration(color: black),
                        ),
                        values: [_lowerValue, _upperValue],
                        max: 50,
                        min: 0,
                        onDragging: (handlerIndex, lowerValue, upperValue) {
                          _lowerValue = lowerValue;
                          _upperValue = upperValue;
                          changeState(() {});
                          setState(() {
                            strokeWidth = _lowerValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            }));
      },
    );
  }

  void dialogBoxCustomPainter() {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: colorOfPicker,
            onColorChanged: changeColor,
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Got it'),
            onPressed: () {
              setState(() => selectedColor = colorOfPicker);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void changeColor(Color color) {
    setState(() => colorOfPicker = color);
  }

  void setColor(int index, BuildContext context) {
    switch (index) {
      case 0:
        setState(() {
          selectedColor = Colors.red;
        });
        Navigator.pop(context);
        break;
      case 1:
        setState(() {
          selectedColor = Colors.yellowAccent;
        });
        Navigator.pop(context);
        break;
      case 2:
        setState(() {
          selectedColor = Colors.orange;
        });
        Navigator.pop(context);
        break;
      case 3:
        setState(() {
          selectedColor = Colors.blue;
        });
        Navigator.pop(context);
        break;
      case 4:
        setState(() {
          selectedColor = Colors.green;
        });
        Navigator.pop(context);
        break;
      case 5:
        setState(() {
          selectedColor = Colors.indigo;
        });
        Navigator.pop(context);
        break;
      case 6:
        setState(() {
          selectedColor = Colors.pink;
        });
        Navigator.pop(context);
        break;
      case 7:
        setState(() {
          selectedColor = Colors.black;
        });
        Navigator.pop(context);
        break;
      case 8:
        setState(() {
          selectedColor = Colors.deepOrangeAccent;
        });
        Navigator.pop(context);
        break;
      case 9:
        setState(() {
          selectedColor = Colors.cyan;
        });
        Navigator.pop(context);
        break;
      case 10:
        setState(() {
          selectedColor = Colors.grey;
        });
        Navigator.pop(context);
        break;
      case 11:
        setState(() {
          selectedColor = Colors.purpleAccent;
        });
        Navigator.pop(context);
        break;
      case 12:
        setState(() {
          selectedColor = Colors.amber;
        });
        Navigator.pop(context);
        break;
      case 13:
        setState(() {
          selectedColor = Colors.lime;
        });
        Navigator.pop(context);
        break;
      case 14:
        setState(() {
          selectedColor = Colors.teal;
        });
        Navigator.pop(context);
        break;
    }
  }

  void popUpMenuFunction(int index) {
    switch (index) {
      case 1:
        setState(() {
          pointsDrawn.clear();
        });
        break;
      case 2:
        setState(() {
          gridLayout = !gridLayout;
        });
        break;
    }
  }

  void onTap(int index, BuildContext context) {
    switch (index) {
      case 0:
        undo();
        break;
      case 1:
        strokeWidthDialogBoxSetter(context);
        break;
      case 2:
        colorBottomSheetSetter(context);
        break;
      case 3:
        strokeSetter(context);

        break;
      case 4:
        setState(() {
          selectedColor = white;
        });
        break;
    }
  }

  void undo(){
    int l=pointsDrawn.length;
    if(l==0){
      Fluttertoast.showToast(msg: 'Nothing drawn on the board');
    }else if(l<5){
      setState(() {
        pointsDrawn.clear();
      });
    }
    else {
      for (int i = pointsDrawn.length - 2; i >= 0; i--) {
        if (pointsDrawn[i] == null) {
          setState(() {
            pointsDrawn.removeLast();
            if(i<5){
              pointsDrawn.clear();
            }
          });
          return;
        } else {
          setState(() {
            pointsDrawn.removeAt(i);
          });
        }
      }
    }

  }

  Color showColor() {
    if (selectedColor == Colors.white) {
      return black;
    } else {
      return selectedColor;
    }
  }

  Future<void> saveToImage(List<DrawingPoint> pointsList) async {
    List<Offset> offsetPoints = List();
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
        recorder,
        Rect.fromPoints(
            Offset(0.0, 0.0),
            Offset(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height)));

    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i].offset, pointsList[i + 1].offset,
            pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();

        offsetPoints.add(pointsList[i].offset);

        offsetPoints.add(Offset(
            pointsList[i].offset.dx + 0.1, pointsList[i].offset.dy + 0.1));

        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(MediaQuery.of(context).size.width.floor(),
        (MediaQuery.of(context).size.height-kToolbarHeight).floor());
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
    imgBytes = pngBytes;

    debugPrint('Converted to databytes');
  }

  void proceedToPaintDetailedViewer() async {
    if (pointsDrawn.length != 0) {
      await saveToImage(pointsDrawn);
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (context) => PainterDetailedDocument(
                    imagePath: imgBytes,
                    appBarTitle: 'New',
                  )));
    } else {
      Fluttertoast.showToast(msg: 'Nothing has been drawn');
    }
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({this.pointsList});

  List<DrawingPoint> pointsList;
  List<Offset> offsetPoints = List();

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i].offset, pointsList[i + 1].offset,
            pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].offset);
        offsetPoints.add(Offset(
            pointsList[i].offset.dx + 0.1, pointsList[i].offset.dy + 0.1));

        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i].paint);

      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class GridLayout extends CustomPainter {
  final int height;
  final int width;
  final int length;

  GridLayout({this.height, this.width,this.length});

  int i;
  List<Offset> verticalLines = [];
  List<Offset> horizontalLines = [];

  void insertValuesInVertical() {
    for (i = 0; i < width; i = i + length) {
      verticalLines.add(Offset(i.toDouble(), 0));
      verticalLines.add(Offset(i.toDouble(), height.toDouble()));
    }
  }

  void insertValuesInHorizontal() {
    for (i = 0; i < height; i = i + length) {
      horizontalLines.add(Offset(0, i.toDouble()));
      horizontalLines.add(Offset(width.toDouble(), i.toDouble()));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final pointMode = ui.PointMode.lines;
    insertValuesInVertical();
    insertValuesInHorizontal();
    // TODO: implement paint
    final paint = Paint()
      ..color = Colors.black.withAlpha(20)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, verticalLines, paint);
    canvas.drawPoints(pointMode, horizontalLines, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

