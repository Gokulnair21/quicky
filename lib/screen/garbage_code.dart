
//  Widget addNewValCard({double width, String label, IconData icon}) {
//    return SizedBox(
//      height: 130,
//      width: width,
//      child: Card(
//          color: Theme.of(context).iconTheme.color.withAlpha(10),
//          elevation: 0,
//          shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.circular(20),
//          ),
//          child: Center(
//              child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Icon(icon, color: Colors.red, size: 35),
//              SizedBox(
//                height: 3,
//              ),
//              Text(
//                label,
//                style: GoogleFonts.lato(
//                  fontSize: 12,
//                  fontWeight: FontWeight.w900,
//                ),
//              )
//            ],
//          ))),
//    );
//  }


//  Widget importantList(Document document, int index) {
//    return Container(
//      margin: EdgeInsets.only(right: 5),
//      width: 150,
//      child: Card(
//          elevation: 1.0,
//          color: containerColor[colorIndexVal(index)],
//          shape:
//              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//          child: Container(
//            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              mainAxisAlignment: MainAxisAlignment.start,
//              children: <Widget>[
//                SizedBox(
//                  height: 20,
//                ),
//                SizedBox(
//                  child: Text(
//                    '${document.title}',
//                    maxLines: 1,
//                    style: GoogleFonts.lato(
//                        fontWeight: FontWeight.w600,
//                        fontSize: 16,
//                        color: white),
//                  ),
//                ),
//                SizedBox(
//                  height: 5,
//                ),
//                CustomDivider(
//                  padding: 0,
//                ),
//                SizedBox(
//                  height: 10,
//                ),
//                SizedBox(
//                  child: Text(
//                    '${document.description}',
//                    maxLines: 5,
//                    style: GoogleFonts.lato(
//                        fontWeight: FontWeight.w300,
//                        fontSize: 14,
//                        color: white),
//                  ),
//                ),
//              ],
//            ),
//          )),
//    );
//  }
//
//  Widget importantPaintNote(Document document, int index) {
//    return Container(
//      margin: EdgeInsets.only(right: 5),
//      width: 150,
//      child: Card(
//          elevation: 1.0,
//          color: containerColor[colorIndexVal(index)],
//          shape:
//              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//          child: Container(
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              mainAxisAlignment: MainAxisAlignment.start,
//              children: <Widget>[
//                SizedBox(
//                  height: 20,
//                ),
//                Container(
//                  padding: EdgeInsets.only(
//                    left: 10,
//                    right: 10,
//                  ),
//                  child: Text(
//                    '${document.title}',
//                    maxLines: 1,
//                    style: GoogleFonts.lato(
//                        fontWeight: FontWeight.w600,
//                        fontSize: 16,
//                        color: white),
//                  ),
//                ),
//                SizedBox(
//                  height: 13,
//                ),
//                Container(
//                  decoration: BoxDecoration(
//                      color: white,
//                      borderRadius: BorderRadius.only(
//                          bottomRight: Radius.circular(10),
//                          bottomLeft: Radius.circular(10))),
//                  height: 120,
//                  width: 150,
//                  child: Image.file(
//                    File(document.images),
//                    fit: BoxFit.fill,
//                  ),
//                )
//              ],
//            ),
//          )),
//    );
//  }

//  Widget popUpMenuInAppbar() {
//    return PopupMenuButton(
//        icon: Icon(
//          Icons.view_agenda,
//          color: black,
//        ),
//        tooltip: 'More',
//        onSelected: (index) => popUpMenuFunction(index),
//        itemBuilder: (context) => [
//              PopupMenuItem(
//                value: 1,
//                child: Text(
//                  'Add to important',
//                  style: GoogleFonts.lato(
//                    fontSize: 15,
//                    color: black,
//                    fontWeight: FontWeight.w600,
//                  ),
//                ),
//              ),
//              PopupMenuItem(
//                value: 2,
//                child: Text(
//                  'Select all',
//                  style: GoogleFonts.lato(
//                    fontSize: 15,
//                    color: black,
//                    fontWeight: FontWeight.w600,
//                  ),
//                ),
//              ),
//              PopupMenuItem(
//                value: 3,
//                child: Text(
//                  'Cancel',
//                  style: GoogleFonts.lato(
//                    fontSize: 15,
//                    color: black,
//                    fontWeight: FontWeight.w600,
//                  ),
//                ),
//              )
//            ]);
//  }