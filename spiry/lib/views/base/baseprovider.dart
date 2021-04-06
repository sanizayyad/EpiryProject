import 'package:spiry/services/firebase/abstracts/databaseservice.dart';
import 'package:spiry/services/firebase/remotedata/firestoredatabase.dart';
import 'package:spiry/services/navigation/navigationservice.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';


enum ViewState{Idle, Busy, Success}

class BaseProviderModel extends ChangeNotifier{
  final FireStoreService fireStoreService = locator<DatabaseService>();
  final NavigationService navigationService = locator<NavigationService>();

  ViewState _viewState = ViewState.Idle;

  ViewState get viewState => _viewState;

  void setViewState(state){
    _viewState = state;
    notifyListeners();
  }

}