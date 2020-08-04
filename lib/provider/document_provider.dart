import 'package:note_app/bloc/document_all_values_bloc.dart';

import 'package:flutter/material.dart';

class DocumentProvider with ChangeNotifier {
  AllDocumentBloc _bloc;

  DocumentProvider() {
    _bloc = AllDocumentBloc();
  }

   get documentBloc => _bloc;
}
