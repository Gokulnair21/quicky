import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/bloc/document_all_values_bloc.dart';
import 'package:note_app/model/document_model.dart';
import 'dart:ui';
import 'package:note_app/widget/text_input_controller_with_validator.dart';
import 'package:note_app/plugin/permission.dart';
import 'package:path_provider/path_provider.dart';

class PainterDetailedDocument extends StatefulWidget {
  final String appBarTitle;
  final ByteData imagePath;
  final Document document;

  PainterDetailedDocument({this.appBarTitle, this.imagePath, this.document});

  @override
  _PainterDetailedDocumentState createState() =>
      _PainterDetailedDocumentState();
}

class _PainterDetailedDocumentState extends State<PainterDetailedDocument> {
  final Color white = Colors.white;
  final Color black = Colors.black;
  final Color whiteVariant = Color(0xfff8f8f8);
  final _paintFormKey = GlobalKey<FormState>();

  final titleController = TextEditingController();

  IconData importantIcon;
  Document document = Document(title: '', images: '', priority: 0, archive: 0);

  IconData iconDataPriority(int val) {
    if (val == 0) {
      return Icons.bookmark_border;
    }
    return Icons.bookmark;
  }

  void initialValueSetter() {
    document = widget.document;
    titleController.text = document.title;
    importantIcon = iconDataPriority(document.priority);
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.document == null) {
      importantIcon = Icons.bookmark_border;
    } else {
      initialValueSetter();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            tooltip: 'Back',
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
            tooltip: 'Add to important',
            onPressed: () => addToImportant(),
            icon: Icon(importantIcon),
          ),
          IconButton(
            tooltip: 'Archive',
            onPressed: () {
              if (document.archive == 0) {
                document.archive = 1;
              } else {
                document.archive = 0;
              }
            },
            icon: Icon(Icons.archive),
          ),
          IconButton(
            tooltip: 'Save',
            onPressed: () => save(context),
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Form(
        key: _paintFormKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
                  color: Theme.of(context).iconTheme.color,
                  autoFocus: true,
                ),
                SizedBox(
                  width: double.infinity,
                  child: (widget.imagePath == null)
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          height: MediaQuery.of(context).size.height -
                              kToolbarHeight,
                          width: MediaQuery.of(context).size.width,
                          child: Image.file(
                            File(document.images),
                            fit: BoxFit.fill,
                          ))
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          height: MediaQuery.of(context).size.height -
                              kToolbarHeight,
                          width: MediaQuery.of(context).size.width,
                          child: Image.memory(
                            Uint8List.view(widget.imagePath.buffer),
                            fit: BoxFit.fill,
                          )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void save(BuildContext context) async {
    if (_paintFormKey.currentState.validate()) {
      document.title = titleController.text;
      if (document.id == null) {
        document.type = 3;
        DateTime now = DateTime.now();
        document.day = now.day;
        document.period = (now.hour > 12) ? 'PM' : 'AM';
        document.month = now.month;
        document.year = now.year;
        document.hour = (now.hour > 12) ? (now.hour - 12) : now.hour;
        document.minute = now.minute;
        document.description = '';
        document.backgroundColor = 0;
        document.textColor = 0;
        document.descriptionFontSize = 0;
        document.descriptionFontWeight = 1;
        document.descriptionTextDirection = 0;
        document.descriptionTextAlignment = 0;
        document.descriptionFontStyle = 0;
        if (await image(context)) {
          documentBloc.add(document);
          Fluttertoast.showToast(msg: 'Saved');
          Navigator.pop(context);
        } else {
          Fluttertoast.showToast(msg: 'Error in saving');
        }
      } else {
        documentBloc.update(document);
        Navigator.pop(context);
      }
    }
  }

  Future<bool> image(BuildContext context) async {
    if (await PermissionService().hasStoragePermission()) {
      String directoryName = 'Paint';
      DateTime now = DateTime.now();
      String name =
          'paint_${now.hour}${now.minute}${now.day}${now.month}${now.year}';
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path;
      await Directory('$path/$directoryName').create(recursive: true);
      File('$path/$directoryName/$name.png')
          .writeAsBytesSync(widget.imagePath.buffer.asInt8List());
      document.images = '$path/$directoryName/$name.png';
      document.noOfImages = 0;
      Fluttertoast.showToast(msg: 'saved');
      debugPrint('executed');
      return true;
    } else {
      askPermissionAgain(context);
    }
  }

  void askPermissionAgain(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content:
                Text('Activate Permission?', style: TextStyle(color: black)),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No', style: TextStyle(color: black)),
              ),
              FlatButton(
                onPressed: () {
                  PermissionService().requestStoragePermission(
                      onPermissionDenied: () {
                    Fluttertoast.showToast(msg: 'Permission denied!!!');
                  });
                  Navigator.pop(context);
                },
                child: Text('Yes', style: TextStyle(color: black)),
              ),
            ],
          );
        });
  }

  void addToImportant() {
    if (importantIcon == Icons.bookmark) {
      Fluttertoast.showToast(msg: 'Removed from importants');
      document.priority = 0;
      setState(() {
        importantIcon = Icons.bookmark_border;
      });
    } else {
      Fluttertoast.showToast(msg: 'Added to importants');
      document.priority = 1;
      setState(() {
        importantIcon = Icons.bookmark;
      });
    }
  }
}
