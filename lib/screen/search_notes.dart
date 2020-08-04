import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/bloc/document_all_values_bloc.dart';
import 'package:note_app/helperclass/document_database_helper_class.dart';
import 'package:note_app/model/graph_data_model.dart';
import 'package:note_app/screen/paint/paint_notes.dart';
import 'package:note_app/screen/splashscreen/splashscreen_no_data.dart';
import 'package:note_app/screen/text/text_notes.dart';
import 'package:note_app/screen/voice/voice_notes.dart';
import 'package:note_app/widget/add_new_value_card.dart';
import 'package:note_app/widget/circular_progress_bar.dart';
import 'package:note_app/widget/graph_notes.dart';
import 'package:note_app/widget/important_paint_note.dart';
import 'package:note_app/widget/important_text_note.dart';
import 'package:note_app/widget/important_voice_note.dart';
import 'package:provider/provider.dart';
import 'package:note_app/model/document_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SearchNotes extends StatefulWidget {
  @override
  _SearchNotesState createState() => _SearchNotesState();
}

class _SearchNotesState extends State<SearchNotes> {
  final controller = TextEditingController();

  List<GraphData> values = [];

  bool isLoading;

  //GraphData(type: 'Text',noOfDocuments: 1,color: charts.MaterialPalette.green.shadeDefault),GraphData(type: 'Voice',noOfDocuments: 1,color:  charts.MaterialPalette.indigo.shadeDefault),GraphData(type: 'Paint',noOfDocuments: 1,color:  charts.MaterialPalette.purple.shadeDefault)
  initValuesForGraph() async {
    setState(() {
      isLoading = true;
    });
    int res1, res2, res3 = 0;
    res1 = await DatabaseHelper.db.getLengthOfDocuments(1);
    // values[0]=GraphData(noOfDocuments: res1);
    values.add(GraphData(
        type: 'Text',
        noOfDocuments: res1,
        color: charts.MaterialPalette.green.shadeDefault));
    res2 = await DatabaseHelper.db.getLengthOfDocuments(2);
    values.add(GraphData(
        type: 'Voice',
        noOfDocuments: res2,
        color: charts.MaterialPalette.indigo.shadeDefault));
    res3 = await DatabaseHelper.db.getLengthOfDocuments(3);
    values.add(GraphData(
        type: 'Paint',
        noOfDocuments: res3,
        color: charts.MaterialPalette.purple.shadeDefault));
    setState(() {
      isLoading = false;
    }); //
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initValuesForGraph();
    documentBloc.getSuggestedDocument('');
  }

  @override
  Widget build(BuildContext context) {
    // final docsBloc=Provider.of<DocumentProvider>(context).documentBloc;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              tooltip: 'Back',
              onPressed: () => Navigator.pop(context)),
          title: TextFormField(
              onChanged: (pattern) {
                documentBloc.getSuggestedDocument(pattern);
                setState(() {});
              },
              style:
                  GoogleFonts.lato(fontWeight: FontWeight.w600, fontSize: 15),
              keyboardType: TextInputType.text,
              maxLines: 1,
              autofocus: true,
              controller: controller,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    tooltip: 'Clear',
                    onPressed: () {
                      setState(() {
                        controller.clear();
                      });
                    }),
                border: InputBorder.none,
                hintText: 'Search...',
                hintStyle: GoogleFonts.lato(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ))),
      body: (controller.text == null || controller.text == '')
          ? noSearchTextPlaceHolder(context)
          : Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: StreamBuilder(
                  stream: documentBloc.suggestedDocuments,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if(snapshot.data.length==0){
                        return SplashScreenNoData(label: 'Nothing found!',);
                      }
                      return StaggeredGridView.countBuilder(
                        shrinkWrap: true,
                        staggeredTileBuilder: (int index) =>
                            StaggeredTile.fit(2),
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        physics: ScrollPhysics(),
                        crossAxisCount: 4,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          Document docs = snapshot.data[index];
                          if (docs.type == 1) {
                            return ImportantTextNote(
                              col: Theme.of(context).appBarTheme.color,
                              fontColor: Theme.of(context).iconTheme.color,
                              document: docs,
                            );
                          }else if(docs.type==2){
                            return ImportantVoiceNote(
                              col: Theme.of(context).appBarTheme.color,
                              fontColor: Theme.of(context).iconTheme.color,
                              document: docs,
                            );
                          }
                          return ImportantPaintNote(
                            fontColor: Theme.of(context).iconTheme.color,
                            col: Theme.of(context).appBarTheme.color,
                            document: docs,
                          );
                        },
                      );
                    }
                    return CentreCircularProgressIndicator();
                  }),
            ),
    );
  }

  Widget noSearchTextPlaceHolder(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              height: 20,
              child: Text(
                'Types',
                style: GoogleFonts.lato(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Theme.of(context).iconTheme.color.withAlpha(100)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>TextNote()));
                      },
                      child: AddNewValueCard(
                        icon: Icons.book,
                        label: 'Text\tNote',
                        height: 140,
                        width: double.infinity,
                        iconSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>VoiceNote()));
                      },
                      child: AddNewValueCard(
                          icon: Icons.keyboard_voice,
                          label: 'Voice\tNote',
                          height: 140,
                          width: double.infinity,
                          iconSize: 23),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>PaintNote()));
                      },
                      child: AddNewValueCard(
                          icon: Icons.image,
                          label: 'Paint\tNote',
                          height: 140,
                          width: double.infinity,
                          iconSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              height: 20,
              child: Text(
                'Overview',
                style: GoogleFonts.lato(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Theme.of(context).iconTheme.color.withAlpha(100)),
              ),
            ),
            (isLoading)
                ? CentreCircularProgressIndicator()
                : Container(
                    height: 200,
                    width: double.infinity,
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          flex: 2,
                          child: GraphOfNotes(values: values),
                        ),
                        Flexible(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              graphDetails('Text\tNotes', Colors.green),
                              graphDetails('Voice\tNotes', Colors.indigo),
                              graphDetails('Paint\tNotes', Colors.purple),
                            ],
                          ),
                        )
                      ],
                    ))
          ],
        ),
      ),
    );
  }

  Widget graphDetails(String label, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: 15,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 15,
            child: Container(
              decoration: BoxDecoration(
                  color: color,
                  border: Border.all(
                      color: Theme.of(context).iconTheme.color, width: 0.5)),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  style: GoogleFonts.lato(
                      fontSize: 12, fontWeight: FontWeight.w500),
                )),
          )
        ],
      ),
    );
  }
}
