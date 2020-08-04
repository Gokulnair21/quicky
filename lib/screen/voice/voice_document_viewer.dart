import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/bloc/document_all_values_bloc.dart';
import 'package:note_app/model/document_model.dart';
import 'package:note_app/widget/text_input_controller_with_validator.dart';
import 'package:audioplayers/audioplayers.dart';

class VoiceNoteDocument extends StatefulWidget {
  final String appBarTitle;
  final Document document;

  VoiceNoteDocument({this.appBarTitle, this.document});

  @override
  _VoiceNoteDocumentState createState() => _VoiceNoteDocumentState();
}

class _VoiceNoteDocumentState extends State<VoiceNoteDocument>
    with SingleTickerProviderStateMixin {
  final Color red = Colors.red;
  final Color white = Colors.white;

  bool isPlaying;
  bool isPause;

  AudioPlayer advancedPlayer = AudioPlayer();
  final titleController = TextEditingController();

  AnimationController _playAndPauseController;

  File audio;

  Duration _duration = Duration();
  Duration _position = Duration();
  String currentTime = "0:00:00";
  String completeTime = "0:00:00";

  IconData _importantIcon;
  IconData _archiveIcon;

  final _voiceDocumentViewer = GlobalKey<FormState>();

  IconData iconDataPriority(int val) {
    if (val == 0) {
      return Icons.bookmark_border;
    }
    return Icons.bookmark;
  }

  IconData iconDataArchive(int val) {
    if (val == 0) {
      return Icons.archive;
    }
    return Icons.unarchive;
  }

  void initData() async {
    titleController.text = widget.document.title;
    audio = File(widget.document.images);
    _importantIcon = iconDataPriority(widget.document.priority);
    _archiveIcon = iconDataArchive(widget.document.archive);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _playAndPauseController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _playAndPauseController.reverse();
    isPlaying = false;
    isPause = false;
    initData();
    advancedPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        currentTime = duration.toString().split(".")[0];
        _position = duration;
        if (_position.inSeconds == _duration.inSeconds) {
          _playAndPauseController.reverse();
          isPlaying = false;
        }
      });
    });
    advancedPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        completeTime = duration.toString().split(".")[0];
        _duration = duration;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _playAndPauseController.dispose();
  }

  Future<bool> goBack() async {
    advancedPlayer.release();
    save();
    return true;
  }

  save() {
    if (_voiceDocumentViewer.currentState.validate()) {
      widget.document.title = titleController.text;
      documentBloc.update(widget.document);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: goBack,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () async {
              if (await goBack()) {
                Navigator.pop(context);
              }
            },
          ),
          title: Text(
            widget.appBarTitle,
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: <Widget>[
            IconButton(
              tooltip: 'Delete',
              onPressed: () {
                documentBloc.delete(widget.document.id);
                Navigator.pop(context);
              },
              icon: Icon(Icons.delete_outline),
            ),
            IconButton(
              tooltip: 'Add to important',
              onPressed: () {
                if (widget.document.priority == 0) {
                  widget.document.priority = 1;
                  _importantIcon = iconDataPriority(1);
                  Fluttertoast.showToast(msg: 'Added to importants');
                } else {
                  widget.document.priority = 0;
                  _importantIcon = iconDataPriority(0);
                  Fluttertoast.showToast(msg: 'Removed from importants');
                }
                setState(() {});
              },
              icon: Icon(_importantIcon),
            ),
            IconButton(
              tooltip: 'Archive',
              onPressed: () {
                if (widget.document.archive == 0) {
                  widget.document.archive = 1;
                  _archiveIcon = iconDataArchive(1);
                  Fluttertoast.showToast(msg: 'Archived');
                } else {
                  widget.document.archive = 0;
                  _archiveIcon = iconDataArchive(0);
                  Fluttertoast.showToast(msg: 'Unarchived');
                }
                setState(() {});
              },
              icon: Icon(_archiveIcon),
            ),

          ],
        ),
        body: Form(
          key: _voiceDocumentViewer,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: TextInputValidator(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    controller: titleController,
                    hintText: 'Title',
                    inputType: TextInputType.text,
                    color: Theme.of(context).iconTheme.color,
                    autoFocus: false,
                  ),),


                SliverFillRemaining(
                  hasScrollBody: false,
                    child: Container(
                      color: Colors.transparent,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 180,
                        margin: EdgeInsets.only(left: 5, right: 5, bottom: 20),
                        padding: EdgeInsets.only(
                            left: 10, right: 10, bottom: 20, top: 20),
                        decoration: BoxDecoration(
                            color: red,
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          children: <Widget>[
                            Container(
                                height: 40,
                                alignment: Alignment.center,
                                child: Slider(
                                    activeColor: white,
                                    min: 0,
                                    max: _duration.inSeconds.toDouble(),
                                    inactiveColor: white.withAlpha(100),
                                    value: _position.inSeconds.toDouble(),
                                    onChanged: (value) {
                                      setState(() {
                                        seekToSecond(value.toInt());
                                      });
                                    })),
                            Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              height: 20,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: white.withAlpha(50),
                                        borderRadius: BorderRadius.circular(50)),
                                    child: Center(
                                      child: Text(
                                        '\t$currentTime\t',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: white,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  Container(
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: white.withAlpha(50),
                                        borderRadius: BorderRadius.circular(50)),
                                    child: Center(
                                      child: Text(
                                        '\t$completeTime\t',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: white,
                                            fontSize: 12),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 60,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: white.withAlpha(50),
                                            shape: BoxShape.circle),
                                        child: Center(
                                          child: IconButton(
                                              icon: Icon(Icons.fast_rewind),
                                              onPressed: () => stopPlaying()),
                                        )),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: white.withAlpha(50),
                                        shape: BoxShape.circle),
                                    child: Center(
                                      child: IconButton(
                                        iconSize: 40,
                                        color: white,
                                        icon: AnimatedIcon(
                                            icon: AnimatedIcons.play_pause,
                                            progress: _playAndPauseController),
                                        onPressed: () {
                                          isPlaying = !isPlaying;
                                          if (isPlaying) {
                                            if (isPause) {
                                              resumePlaying();
                                            } else {
                                              playAudio();
                                            }
                                            _playAndPauseController.forward();
                                          } else {
                                            pausePlaying();
                                            _playAndPauseController.reverse();
                                          }
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: white.withAlpha(50),
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child: IconButton(
                                            icon: Icon(Icons.fast_forward),
                                            onPressed: () => seekForward()),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

      ),
    );
  }

  void playAudio() {
    advancedPlayer.play(audio.path, isLocal: true);
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    advancedPlayer.seek(newDuration);
  }

  void seekForward() {
    Duration newDuration = Duration(seconds: _position.inSeconds + 5);
    if (newDuration.inSeconds >= _duration.inSeconds) {
      advancedPlayer.seek(_duration);
    } else {
      advancedPlayer.seek(newDuration);
    }
  }

  void resumePlaying() {
    advancedPlayer.resume();
    isPause = false;
  }

  void pausePlaying() {
    advancedPlayer.pause();
    isPause = true;
  }

  void stopPlaying() {
    if (!isPlaying) {
      setState(() {
        isPlaying = true;
        _playAndPauseController.forward();
      });
    }
    advancedPlayer.stop();
    advancedPlayer.play(audio.path, isLocal: true);
  }

  void onPressPlayOrPause() {
    if (isPlaying) {
    } else {}
  }
}
