import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:note_app/model/document_model.dart';
import 'package:note_app/screen/text/view_picture.dart';
import 'package:note_app/widget/list_tile_document.dart';
import 'package:note_app/widget/text_input_controller_with_validator.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:note_app/plugin/notfication.dart';
import 'package:note_app/bloc/document_all_values_bloc.dart';

class CreateNewDocument extends StatefulWidget {
  final String appBarTitle;
  final Document document;

  CreateNewDocument({this.appBarTitle, this.document});

  @override
  _CreateNewDocumentState createState() => _CreateNewDocumentState(document);
}

class _CreateNewDocumentState extends State<CreateNewDocument> {
  final Document document;

  _CreateNewDocumentState(this.document);

  //Variables declaration
  final Color black = Colors.black;
  final Color white = Colors.white;
  final Color whiteVariant = Color(0xfff8f8f8);

  String _error = 'No Error Dectected';

  int _currentIndex;
  IconData _iconData;

  List<String> imagesFromCamera = List<String>();
  List<String> imagesFromGallery = List<String>();
  List<String> images = List<String>();

  List<String> repeat = ['Once', 'Daily', 'Weekly'];
  List<Day> days;
  String currentValueOfRepeat = 'Once';

  TextAlign descriptionTextAlign;
  IconData alignIcon;
  FontWeight descriptionFontWeight;
  FontStyle descriptionFontStyle;
  static double minPadding = 10;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final fontSizeController = TextEditingController();
  final formFontSizeKey = GlobalKey<FormState>();
  final formScaffoldKey = GlobalKey<FormState>();

  Color uiColor;

  List<Asset> assetImages = List<Asset>();

//default charts
  List<Color> containerColor = [
    Colors.white,
    Colors.red,
    Colors.yellow,
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

  List<FontWeight> fontWeightChart = [
    FontWeight.w100,
    FontWeight.w200,
    FontWeight.w300,
    FontWeight.w400,
    FontWeight.w500,
    FontWeight.w600,
    FontWeight.w700,
    FontWeight.w800,
    FontWeight.w900
  ];

  List<FontStyle> fontStyleChart = [FontStyle.normal, FontStyle.italic];

  List<TextDirection> textDirectionChart = [
    TextDirection.ltr,
    TextDirection.rtl
  ];
  List<TextAlign> textAlignmentChart = [
    TextAlign.left,
    TextAlign.center,
    TextAlign.right,
    TextAlign.justify
  ];
  List<IconData> textAlignmentIconChart = [
    Icons.format_align_left,
    Icons.format_align_center,
    Icons.format_align_right,
    Icons.format_align_justify
  ];

  //document initialization stuff
  double descriptionFontSize;
  TextDirection descriptionTextDirection;
  Color backgroundColor;
  Color textColor;
  PageController controller;
  int currentPage = 0;
  TimeOfDay selectedTime;

  IconData iconDataPriority(int val) {
    if (val == 0) {
      return Icons.bookmark_border;
    }
    return Icons.bookmark;
  }

  void myDocumentInterfaceSetter() {
    _iconData = iconDataPriority(document.priority);
    backgroundColor = containerColor[document.backgroundColor];
    textColor = containerColor[document.textColor];
    uiColor = (backgroundColor == Colors.white) ? black : white;
    descriptionFontWeight =
        fontWeightChart[(document.descriptionFontWeight) - 1];
    if (document.images != null || document.images == '') {
      imagesFromCamera = document.images.split(', ');
      images = imagesFromCamera;
    }
    descriptionController.text = document.description;
    titleController.text = document.title;
    alignIcon = textAlignmentIconChart[document.descriptionTextAlignment];
    descriptionTextAlign =
        textAlignmentChart[document.descriptionTextAlignment];
    fontSizeController.text = document.descriptionFontSize.toString();
    descriptionFontStyle = fontStyleChart[document.descriptionFontStyle];
    descriptionTextDirection =
        textDirectionChart[document.descriptionTextDirection];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myDocumentInterfaceSetter();
    controller = PageController(
      initialPage: currentPage,
      keepPage: false,
      viewportFraction: 0.5,
    );
    _currentIndex = 0;
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: (backgroundColor == Colors.black)
          ? Colors.white.withAlpha(20)
          : backgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: uiColor),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () => Navigator.pop(context)),
        title: Text(
          widget.appBarTitle,
          style: GoogleFonts.lato(
            fontSize: 18,
            color: uiColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        actionsIconTheme: IconThemeData(color: uiColor),
        actions: <Widget>[
          IconButton(
            tooltip: 'Add to important',
            onPressed: () => addToImportant(),
            icon: Icon(_iconData),
          ),
          IconButton(
            tooltip: 'Clear all',
            onPressed: () => clear(context),
            icon: Icon(Icons.clear_all),
          ),
          IconButton(
            tooltip: 'Save',
            onPressed: () => save(documentBloc, context),
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: Form(
        key: formScaffoldKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.only(left: minPadding, right: minPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextInputValidator(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  controller: titleController,
                  hintText: 'Title',
                  inputType: TextInputType.text,
                  color: textColor,
                  autoFocus: true,
                ),
                SizedBox(
                  width: double.infinity,
                  child: (images.length == 0)
                      ? SizedBox()
                      : SizedBox(
                          height: 250,
                          child: imageCarouselViewer(context),
                        ),
                ),
                descriptionInputField(
                    double.tryParse(fontSizeController.text.toString()))
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        unselectedIconTheme: IconThemeData(color: uiColor),
        fixedColor: uiColor,
        onTap: (index) => onTap(index, context),
        backgroundColor: Colors.white.withAlpha(30),
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.image,
              ),
              title: Text('All')),
          BottomNavigationBarItem(icon: Icon(alignIcon), title: Text('All')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.text_fields,
              ),
              title: Text('All')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.style,
              ),
              title: Text('All')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.color_lens,
              ),
              title: Text('All')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.more_vert,
              ),
              title: Text('All')),
        ],
      ),
    );
  }

  Widget descriptionInputField(double descriptionFontSize) {
    return TextFormField(
        textAlign: descriptionTextAlign,
        textDirection: descriptionTextDirection,
        style: GoogleFonts.lato(
            fontWeight: descriptionFontWeight,
            color: textColor,
            fontSize: descriptionFontSize,
            fontStyle: descriptionFontStyle),
        keyboardType: TextInputType.multiline,
        maxLines: 999,
        minLines: 1,
        autofocus: false,
        controller: descriptionController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Description...',
          hintStyle: GoogleFonts.lato(
            color: textColor.withAlpha(100),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ));
  }

  void chooseImageDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 4.0,
          backgroundColor: backgroundColor,
          child: Container(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                  child: Text('Add image',
                      style: GoogleFonts.lato(
                          fontSize: 15,
                          color: uiColor,
                          fontWeight: FontWeight.w600)),
                ),
                ListTileOfDocs(
                  col: uiColor,
                  icon: Icons.camera_alt,
                  label: 'Take photo',
                  onTap: () {
                    getImageFromCamera();
                    Navigator.pop(context);
                  },
                ),
                ListTileOfDocs(
                    col: uiColor,
                    icon: Icons.image,
                    label: 'Choose image',
                    onTap: () {
                      loadAssets();
                      Navigator.pop(context);
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  void colorBottomSheetSetter(BuildContext context) {
    showModalBottomSheet<void>(
        backgroundColor: backgroundColor.withAlpha(240),
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
                            'Choose a background color scheme',
                            style: GoogleFonts.lato(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: uiColor),
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
                                containerColor[index], index, true, context);
                          }),
                    ),
                    SizedBox(
                      height: 30,
                      child: Center(
                        child: FittedBox(
                          child: Text(
                            'Choose a text color scheme',
                            style: GoogleFonts.lato(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: uiColor),
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
                                containerColor[index], index, false, context);
                          }),
                    ),
                  ],
                ))));
  }

  void fontSizeBottomSheetSetter(BuildContext context) {
    showModalBottomSheet<void>(
        backgroundColor: backgroundColor,
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        builder: (context) => SafeArea(
            child: Container(
                padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                width: double.infinity,
                child: Form(
                  key: formFontSizeKey,
                  child: Wrap(
                    children: <Widget>[
                      Container(
                        child: Center(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: TextInputValidator(
                                color: uiColor,
                                hintText: 'Fontsize',
                                controller: fontSizeController,
                                autoFocus: true,
                                inputType: TextInputType.number,
                              )),
                              FlatButton(
                                onPressed: () => changeFontSize(context),
                                child: Text(
                                  'OK',
                                  style: GoogleFonts.lato(
                                    color: uiColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ))));
  }

  void popUpMenuBottomSheetSetter(BuildContext context) {
    IconData upOrDown = Icons.keyboard_arrow_down;
    bool show = true;
    showModalBottomSheet<void>(
        backgroundColor: backgroundColor,
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        builder: (context) => SafeArea(
            child: Container(
                width: double.infinity,
                child: StatefulBuilder(builder: (context, changeState) {
                  return Wrap(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          Icons.text_rotation_none,
                          color: uiColor,
                        ),
                        title: Text(
                          'Text direction',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w600, color: uiColor),
                        ),
                        trailing: Icon(
                          upOrDown,
                          color: uiColor,
                        ),
                        onTap: () {
                          if (show) {
                            changeState(() {
                              show = false;
                              upOrDown = Icons.keyboard_arrow_up;
                            });
                          } else {
                            changeState(() {
                              show = true;
                              upOrDown = Icons.keyboard_arrow_down;
                            });
                          }
                        },
                      ),
                      Container(
                          child: (show)
                              ? SizedBox()
                              : Wrap(
                                  children: <Widget>[
                                    ListTileOfDocs(
                                      icon: Icons.format_textdirection_l_to_r,
                                      label: 'Left to right',
                                      col: uiColor,
                                      onTap: () =>
                                          setDescriptionTextDirection(0),
                                    ),
                                    ListTileOfDocs(
                                      icon: Icons.format_textdirection_r_to_l,
                                      label: 'Right to left',
                                      col: uiColor,
                                      onTap: () =>
                                          setDescriptionTextDirection(1),
                                    ),
                                    Divider(
                                      color: uiColor.withAlpha(50),
                                    )
                                  ],
                                )),
                      ListTileOfDocs(
                        icon: Icons.format_color_reset,
                        label: 'Reset to default',
                        col: uiColor,
                        onTap: () => resetToDefaultScheme(context),
                      ),
                      ListTileOfDocs(
                        icon: (document.archive==0)?Icons.archive:Icons.unarchive,
                        label: (document.archive==0)?'Archive':'Unarchive',
                        col: uiColor,
                        onTap: () { 
                          document.archive=(document.archive==0)?1:0;
                          Navigator.pop(context);
                        }
                      ),
                      (widget.appBarTitle=='New')?SizedBox():ListTileOfDocs(
                        icon: Icons.delete,
                        label: 'Delete',
                        col: uiColor,
                        onTap: () {
                          documentBloc.delete(document.id);
                          Fluttertoast.showToast(msg: 'Deleted');
                          Navigator.pop(context);
                          Navigator.pop(context);
                          
                        },
                      ),
//                      ListTileOfDocs(
//                        icon: Icons.info_outline,
//                        label: 'Details',
//                        col: uiColor,
//                        onTap: () => Fluttertoast.showToast(msg: 'Working..'),
//                      ),
                    ],
                  );
                },),),),);
  }

  void fontStyleBottomSheetSetter(BuildContext context) {
    bool italicStatus = isItalicSet(descriptionFontStyle);
    showModalBottomSheet<void>(
        backgroundColor: backgroundColor,
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        builder: (context) =>
            SafeArea(child: StatefulBuilder(builder: (context, changeState) {
              return Container(
                  width: double.infinity,
                  child: Wrap(
                    children: <Widget>[
                      ListTileOfDocs(
                        icon: Icons.format_bold,
                        label: 'Boldness',
                        col: uiColor,
                        onTap: () =>
                            boldnessOfDescriptionDialogBoxSetter(context),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.format_italic,
                          color: uiColor,
                        ),
                        trailing: (italicStatus)
                            ? Icon(
                                Icons.done,
                                color: uiColor,
                              )
                            : SizedBox(),
                        title: Text(
                          'Italic',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w600, color: uiColor),
                        ),
                        onTap: () {
                          descriptionFontStyleSetter();
                          changeState(() {
                            italicStatus = isItalicSet(descriptionFontStyle);
                          });
                        },
                      )
                    ],
                  ));
            })));
  }

  void alignmentBottomSheetSetter(BuildContext context) {
    showModalBottomSheet<void>(
        backgroundColor: backgroundColor,
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        builder: (context) => SafeArea(
            child: Container(
                width: double.infinity,
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.format_align_left,
                        color: uiColor,
                      ),
                      title: Text(
                        'Align left',
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w600, color: uiColor),
                      ),
                      onTap: () => setDescriptionAlignment(0, context),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.format_align_center,
                        color: uiColor,
                      ),
                      title: Text(
                        'Align center',
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w600, color: uiColor),
                      ),
                      onTap: () => setDescriptionAlignment(1, context),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.format_align_right,
                        color: uiColor,
                      ),
                      title: Text(
                        'Align right',
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w600, color: uiColor),
                      ),
                      onTap: () => setDescriptionAlignment(2, context),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.format_align_justify,
                        color: uiColor,
                      ),
                      title: Text(
                        'Justify',
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w600, color: uiColor),
                      ),
                      onTap: () => setDescriptionAlignment(3, context),
                    ),
                  ],
                ))));
  }

  Widget colorContainer(
      Color color, int index, bool isBg, BuildContext context) {
    return InkWell(
      onTap: () => setColor(index, isBg, context),
      child: Container(
        height: 30,
        width: 30,
        margin: EdgeInsets.only(left: minPadding, right: minPadding),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }

  void boldnessOfDescriptionDialogBoxSetter(BuildContext context) {
    double _lowerValue = document.descriptionFontWeight.ceilToDouble();
    double _upperValue = 9;
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 4.0,
            backgroundColor: backgroundColor,
            child: StatefulBuilder(builder: (context, changeState) {
              return Container(
                child: Wrap(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                      child: Center(
                        child: FittedBox(
                          child: Text(
                            'Boldness level',
                            style: GoogleFonts.lato(
                              color: uiColor,
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
                              color: uiColor,
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
                            color: white.withAlpha(50),
                          ),
                          activeTrackBar: BoxDecoration(color: uiColor),
                        ),
                        values: [_lowerValue, _upperValue],
                        max: 9,
                        min: 0,
                        onDragging: (handlerIndex, lowerValue, upperValue) {
                          _lowerValue = lowerValue;
                          _upperValue = upperValue;
                          document.descriptionFontWeight = _lowerValue.floor();
                          changeState(() {});
                          fontWeightSetterOfDescription(_lowerValue.floor());
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

  void dialogBox(BuildContext context) {
    double _lowerValue = 5;
    double _upperValue = 9;
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 4.0,
            backgroundColor: backgroundColor,
            child: StatefulBuilder(builder: (context, changeState) {
              return Container(
                child: Wrap(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                      child: Center(
                        child: FittedBox(
                          child: Text(
                            'Boldness level',
                            style: GoogleFonts.lato(
                              color: uiColor,
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
                              color: uiColor,
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
                            color: white.withAlpha(50),
                          ),
                          activeTrackBar: BoxDecoration(color: uiColor),
                        ),
                        values: [_lowerValue, _upperValue],
                        max: 9,
                        min: 0,
                        onDragging: (handlerIndex, lowerValue, upperValue) {
                          _lowerValue = lowerValue;
                          _upperValue = upperValue;
                          changeState(() {});
                          fontWeightSetterOfDescription(_lowerValue.floor());
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

  Widget imageCarouselViewer(BuildContext context) {
    return Container(
      child: PageView.builder(
          itemCount: images.length,
          onPageChanged: (value) {
            setState(() {
              currentPage = value;
            });
          },
          controller: controller,
          itemBuilder: (
            context,
            index,
          ) =>
              customBuilder(context, index, images[index])),
    );
  }

  Widget customBuilder(BuildContext context, int index, String path) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double value = 1.0;
        if (controller.position.haveDimensions) {
          value = controller.page - index;
          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
        }

        return Center(
          child: SizedBox(
            height: Curves.easeOut.transform(value) * 300,
            width: Curves.easeOut.transform(value) * 250,
            child: child,
          ),
        );
      },
      child: Hero(
        tag: path,
        child: GestureDetector(
          onLongPress: () {
            openDialogBoxDeleteImage(context, index);
          },
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewImage(
                          imagePath: path,
                        )));
          },
          child: Container(
            margin: EdgeInsets.all(8.0),
            child: Image.file(
              File(path),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  void openDialogBoxDeleteImage(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 4.0,
          backgroundColor: backgroundColor,
          child: Container(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: <Widget>[
                ListTile(
                  //&& imagesFromCamera.length<index+2
                  //&& imagesFromGallery.length>index+2
                  onTap: () {
                    if (index < imagesFromCamera.length &&
                        imagesFromCamera.length != 0) {
                      imagesFromCamera.removeAt(index);
                    } else {
                      if (imagesFromGallery.length != 0) {
                        int x = imagesFromCamera.length - index;
                        if (x < 0) {
                          imagesFromGallery.removeAt((x * -1));
                          assetImages.removeAt((x * -1));
                        } else {
                          imagesFromGallery.removeAt((x));
                          assetImages.removeAt((x));
                        }
                      }
                    }
                    images.removeAt(index);
                    setState(() {});
                    Navigator.pop(context);
                  },
                  title: Text('Remove image',
                      style: GoogleFonts.lato(
                          fontSize: 15,
                          color: uiColor,
                          fontWeight: FontWeight.w400)),
                  trailing: Icon(
                    Icons.delete,
                    color: uiColor,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void onTap(int index, BuildContext context) {
    switch (index) {
      case 0:
        chooseImageDialogBox(context);
        break;
      case 1:
        alignmentBottomSheetSetter(context);
        break;
      case 2:
        fontSizeBottomSheetSetter(context);
        break;
      case 3:
        fontStyleBottomSheetSetter(context);
        break;
      case 4:
        colorBottomSheetSetter(context);
        break;
      case 5:
        popUpMenuBottomSheetSetter(context);
        break;
    }
  }

  void clear(BuildContext context) {
    debugPrint('cleared');
    if (titleController.text.toString() == '' &&
        descriptionController.text.toString() == '' &&
        images.length == 0) {
      Fluttertoast.showToast(msg: 'No data');
    } else if (images.length != 0) {
      alertDialogBox(context);
    } else {
      setState(() {
        titleController.clear();
        descriptionController.clear();
      });
      Fluttertoast.showToast(msg: 'Cleared');
    }
  }

  void alertDialogBox(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        content: Text('Do you want to remove all images too?',
            style:
                GoogleFonts.lato(color: uiColor, fontWeight: FontWeight.w600)),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              setState(() {
                titleController.clear();
                descriptionController.clear();
              });
              Navigator.pop(context);
            },
            child: Text('No',
                style: GoogleFonts.lato(
                    color: uiColor, fontWeight: FontWeight.w600)),
          ),
          FlatButton(
            onPressed: () {
              setState(() {
                titleController.clear();
                descriptionController.clear();
                images.clear();
                assetImages.clear();
                imagesFromCamera.clear();
                imagesFromGallery.clear();
              });
              Navigator.pop(context);
            },
            child: Text('Yes',
                style: GoogleFonts.lato(
                    color: uiColor, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void setDescriptionStyle(int index) {
    switch (index) {
      case 0:
        document.descriptionFontStyle = 0;
        setState(() {
          descriptionFontStyle = FontStyle.normal;
        });
        break;
      case 1:
        document.descriptionFontStyle = 1;
        setState(() {
          descriptionFontStyle = FontStyle.italic;
        });
        break;
    }
  }

  void setDescriptionAlignment(int index, BuildContext context) {
    switch (index) {
      case 0:
        document.descriptionTextAlignment = 0;
        setState(() {
          descriptionTextAlign = TextAlign.left;
          alignIcon = Icons.format_align_left;
        });
        break;
      case 1:
        document.descriptionTextAlignment = 1;
        setState(() {
          descriptionTextAlign = TextAlign.center;
          alignIcon = Icons.format_align_center;
        });
        break;
      case 2:
        document.descriptionTextAlignment = 2;
        setState(() {
          descriptionTextAlign = TextAlign.right;
          alignIcon = Icons.format_align_right;
        });
        break;
      case 3:
        document.descriptionTextAlignment = 3;
        setState(() {
          descriptionTextAlign = TextAlign.justify;
          alignIcon = Icons.format_align_justify;
        });
        break;
      case 4:
        document.descriptionTextAlignment = 4;
        setState(() {
          descriptionTextAlign = TextAlign.start;
        });
        break;
      case 5:
        document.descriptionTextAlignment = 5;
        setState(() {
          descriptionTextAlign = TextAlign.end;
        });
        break;
    }
    Navigator.pop(context);
  }

  void setDescriptionTextDirection(int index) {
    switch (index) {
      case 0:
        document.descriptionTextDirection = 0;
        setState(() {
          descriptionTextDirection = TextDirection.ltr;
        });
        break;
      case 1:
        document.descriptionTextDirection = 1;
        document.descriptionTextAlignment = 3;
        setState(() {
          descriptionTextDirection = TextDirection.rtl;
          descriptionTextAlign = TextAlign.justify;
          alignIcon = Icons.format_align_justify;
        });
        break;
    }
  }

  void setColor(int index, bool isBg, BuildContext context) {
    if (isBg) {
      switch (index) {
        case 0:
          document.backgroundColor = 0;
          document.textColor = 8;

          backgroundColor = Colors.white;
          uiColor = Colors.black;
          textColor = Colors.black;

          break;
        case 1:
          document.backgroundColor = 1;
          document.textColor = 0;
          backgroundColor = Colors.red;
          uiColor = Colors.white;
          textColor = Colors.white;
          break;
        case 2:
          document.backgroundColor = 2;
          document.textColor = 8;
          backgroundColor = Colors.yellow;
          uiColor = Colors.black;
          textColor = Colors.black;
          break;
        case 3:
          document.backgroundColor = 3;
          document.textColor = 0;
          backgroundColor = Colors.orange;
          uiColor = Colors.white;
          textColor = Colors.white;
          break;
        case 4:
          document.backgroundColor = 4;
          document.textColor = 0;
          backgroundColor = Colors.blue;
          uiColor = Colors.white;
          textColor = Colors.white;
          break;
        case 5:
          document.backgroundColor = 5;
          document.textColor = 0;
          backgroundColor = Colors.green;
          uiColor = Colors.white;
          textColor = Colors.white;
          break;
        case 6:
          document.backgroundColor = 6;
          document.textColor = 0;
          backgroundColor = Colors.indigo;
          uiColor = Colors.white;
          textColor = Colors.white;
          break;
        case 7:
          document.backgroundColor = 7;
          document.textColor = 0;
          backgroundColor = Colors.pink;
          uiColor = Colors.white;
          textColor = Colors.white;

          break;
        case 8:
          document.backgroundColor = 8;
          document.textColor = 0;
          backgroundColor = Colors.black;
          uiColor = Colors.white;
          textColor = Colors.white;
          break;
        case 9:
          document.backgroundColor = 9;
          document.textColor = 0;
          backgroundColor = Colors.deepOrangeAccent;
          uiColor = Colors.white;
          textColor = Colors.white;

          break;
        case 10:
          document.backgroundColor = 10;
          document.textColor = 0;
          backgroundColor = Colors.cyan;
          uiColor = Colors.white;
          textColor = Colors.white;

          break;
        case 11:
          document.backgroundColor = 11;
          document.textColor = 0;
          backgroundColor = Colors.grey;
          uiColor = Colors.white;
          textColor = Colors.white;

          break;
        case 12:
          document.backgroundColor = 12;
          document.textColor = 0;
          backgroundColor = Colors.purpleAccent;
          uiColor = Colors.white;
          textColor = Colors.white;

          break;
        case 13:
          document.backgroundColor = 13;
          document.textColor = 0;
          backgroundColor = Colors.amber;
          uiColor = Colors.white;
          textColor = Colors.white;

          break;
        case 14:
          document.backgroundColor = 14;
          document.textColor = 0;
          backgroundColor = Colors.lime;
          uiColor = Colors.white;
          textColor = Colors.white;

          break;
        case 15:
          document.backgroundColor = 15;
          document.textColor = 0;
          backgroundColor = Colors.teal;
          uiColor = Colors.white;
          textColor = Colors.white;

          break;
      }
      setState(() {});
      Navigator.pop(context);
    } else {
      switch (index) {
        case 0:
          document.textColor = 0;
          textColor = Colors.white;

          break;
        case 1:
          document.textColor = 1;
          textColor = Colors.red;

          break;
        case 2:
          document.textColor = 2;
          textColor = Colors.yellow;

          break;
        case 3:
          document.textColor = 3;
          textColor = Colors.orange;

          break;
        case 4:
          document.textColor = 4;

          textColor = Colors.blue;

          break;
        case 5:
          document.textColor = 5;

          textColor = Colors.green;

          break;
        case 6:
          document.textColor = 6;

          textColor = Colors.indigo;

          break;
        case 7:
          document.textColor = 7;
          textColor = Colors.pink;

          break;
        case 8:
          document.textColor = 8;
          textColor = Colors.black;

          break;
        case 9:
          document.textColor = 9;
          textColor = Colors.deepOrangeAccent;

          break;
        case 10:
          document.textColor = 10;
          textColor = Colors.cyan;

          break;
        case 11:
          document.textColor = 11;
          textColor = Colors.grey;

          break;
        case 12:
          document.textColor = 12;
          textColor = Colors.purpleAccent;

          break;
        case 13:
          document.textColor = 13;
          textColor = Colors.amber;

          break;
        case 14:
          document.textColor = 14;
          textColor = Colors.lime;

          break;
        case 15:
          document.textColor = 15;
          textColor = Colors.teal;
          break;
      }
      setState(() {});
      Navigator.pop(context);
    }
  }

  changeFontSize(BuildContext context) {
    if (formFontSizeKey.currentState.validate()) {
      if (double.parse(fontSizeController.text.toString()) < 50.1) {
        setState(() {});
        document.descriptionFontSize =
            num.tryParse(fontSizeController.text.toString());
        Navigator.pop(context);
      } else {
        fontSizeController.clear();
        Fluttertoast.showToast(msg: 'Fontsize cannot be greater than 50');
      }
    }
  }

  void resetToDefaultScheme(BuildContext context) {
    setState(() {
      descriptionFontStyle = FontStyle.normal;
      document.descriptionFontSize = 18;
      document.textColor = 8;
      document.backgroundColor = 0;
      document.descriptionTextDirection = 0;
      document.descriptionTextAlignment = 0;
      document.descriptionFontStyle = 0;
      document.descriptionFontWeight = 5;
      backgroundColor = Colors.white;
      textColor = Colors.black;
      uiColor = Colors.black;
      descriptionTextDirection = TextDirection.ltr;
      descriptionFontWeight = FontWeight.w500;
      descriptionTextAlign = TextAlign.left;
      alignIcon = Icons.format_align_left;
      fontSizeController.text = 18.toString();
    });
    Navigator.pop(context);
  }

  void addToImportant() {
    if (_iconData == Icons.bookmark) {
      Fluttertoast.showToast(msg: 'Removed from importants');
      document.priority = 0;
      setState(() {
        _iconData = Icons.bookmark_border;
      });
    } else {
      Fluttertoast.showToast(msg: 'Added to importants');
      document.priority = 1;
      setState(() {
        _iconData = Icons.bookmark;
      });
    }
  }

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) {
      return;
    }
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path;
    var fileName = basename(image.path);
    final File localImage = await image.copy('$path/$fileName');
    imagesFromCamera.add(localImage.path.toString());

    formDifferentSourceToImageList();
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: assetImages,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          autoCloseOnSelectionLimit: true,
          actionBarColor: "#ff1744",
          statusBarColor: "#ff1744",
          actionBarTitle: "Select an image",
          allViewTitle: "All Photos",
          useDetailsView: true,
          selectCircleStrokeColor: "#ff1744",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      assetImages = resultList;
      _error = error;
    });
    await getFileList();
    formDifferentSourceToImageList();
  }

  Future<void> getFileList() async {
    imagesFromGallery.clear();
    for (int i = 0; i < assetImages.length; i++) {
      String path =
          await FlutterAbsolutePath.getAbsolutePath(assetImages[i].identifier);
      var file = await getImageFileFromAsset(path);
      imagesFromGallery.add(file.path.toString());
      print(assetImages.length);
    }
  }

  Future<File> getImageFileFromAsset(String path) async {
    final file = File(path);
    return file;
  }

  void conversionOfListToString() {
    String g = images.toString();
    g.split(',');
  }

  void fontWeightSetterOfDescription(int index) {
    switch (index) {
      case 1:
        descriptionFontWeight = FontWeight.w100;
        break;
      case 2:
        descriptionFontWeight = FontWeight.w200;
        break;
      case 3:
        descriptionFontWeight = FontWeight.w300;
        break;
      case 4:
        descriptionFontWeight = FontWeight.w400;
        break;
      case 5:
        descriptionFontWeight = FontWeight.w500;
        break;
      case 6:
        descriptionFontWeight = FontWeight.w600;
        break;
      case 7:
        descriptionFontWeight = FontWeight.w700;
        break;
      case 8:
        descriptionFontWeight = FontWeight.w900;
        break;
      case 9:
        descriptionFontWeight = FontWeight.w900;
        break;
    }
    setState(() {});
  }

  void descriptionFontStyleSetter() {
    if (descriptionFontStyle == FontStyle.normal) {
      setState(() {
        descriptionFontStyle = FontStyle.italic;
        document.descriptionFontStyle = 1;
      });
    } else {
      setState(() {
        descriptionFontStyle = FontStyle.normal;
        document.descriptionFontStyle = 0;
      });
    }
  }

  bool isItalicSet(FontStyle style) {
    if (style == FontStyle.normal) {
      return false;
    }
    return true;
  }

  formDifferentSourceToImageList() {
    setState(() {
      images = imagesFromCamera + imagesFromGallery;
    });
  }

  void save(AllDocumentBloc bloc, BuildContext context) async {
    if (formScaffoldKey.currentState.validate()) {
      document.description = descriptionController.text;
      document.title = titleController.text;
      if (images.length == 0) {
        document.images = null;
      } else {
        String temp = images.toString().substring(1);
        document.images = temp.substring(0, temp.length - 1);
        document.noOfImages = images.length;
      }

      await timeSetterOfDocument();
      if (document.id == null) {
        bloc.add(document);
      } else {
        Fluttertoast.showToast(msg: 'Note updated');
        documentBloc.update(document);
      }
      Navigator.pop(context);
    }
  }

  Future<void> timeSetterOfDocument() async {
    DateTime current = DateTime.now();
    if (current.hour > 12) {
      document.period = 'PM';
      document.hour = current.hour - 12;
    } else {
      document.period = 'AM';
      document.hour = current.hour;
    }
    document.minute = current.minute;
    document.day = current.day;
    document.month = current.month;
    document.year = current.year;
  }

  void addDaysInList(String index) {
    switch (index) {
      case 'Mon':
        days.add(Day.Monday);
        break;
      case 'Tue':
        days.add(Day.Tuesday);
        break;
      case 'Wed':
        days.add(Day.Wednesday);
        break;
      case 'Thu':
        days.add(Day.Thursday);
        break;
      case 'Fri':
        days.add(Day.Friday);
        break;
      case 'Sat':
        days.add(Day.Saturday);
        break;
    }
  }

  void saveAndSetNotification(TimeOfDay time, DateTime dateTime,
      Document document, BuildContext context) async {
    NotificationHandler notificationHandler = NotificationHandler();
    switch (currentValueOfRepeat) {
      case 'Once':
        notificationHandler.singleNotification(
            document.title,
            document.id,
            'hi',
            dateTime.year,
            dateTime.day,
            dateTime.month,
            time.hour,
            time.minute);
        break;
      case 'Daily':
        notificationHandler.dailyNotification(
            Time(time.hour, time.minute), document.title, document.id, 'hi');
        break;
      case 'Weekly':
        notificationHandler.showNotificationOnSpecificWeekday(
            Time(time.hour, time.minute),
            document.title,
            document.id,
            'Hi',
            days);
        break;
    }
    Navigator.pop(context);
  }
}
