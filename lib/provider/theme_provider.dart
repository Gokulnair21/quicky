import 'package:note_app/bloc/theme_bloc.dart';

import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  SettingsBloc _bloc;

  SettingsProvider() {
    _bloc = SettingsBloc();

    _bloc.loadPreferences();
  }

  SettingsBloc get bloc => _bloc;
}
