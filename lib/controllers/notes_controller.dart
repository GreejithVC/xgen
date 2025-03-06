import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import '../constants/enums.dart';
import '../models/Notes.dart';
import '../services/notes_service.dart';

class NotesController with ChangeNotifier {


  List<Note> notes = [];
  String? error;
  bool isLoadingMore = false;
  int totalCount = 500;
  int page = 1;

  PageState _pageState = PageState.loading;

  set pageState(final PageState value) {
    _pageState = value;
    notifyListeners();
  }

  PageState get pageState => _pageState;


  Future<bool> loadMore() async {
    if (totalCount > notes.length && isLoadingMore != true) {
      isLoadingMore = true;
      page++;
      return _fetchNotes();
    }
    return false;
  }

  initList() async {
    _pageState = PageState.loading;
    isLoadingMore = false;
    notes.clear();
    page = 1;
    _fetchNotes();
  }

  Future<bool> _fetchNotes() async {
    try {
      final response = await NotesService().fetchNotes();
      if (page == 1) {
        notes = response;
      } else {
        notes.addAll(response);
      }
      isLoadingMore = false;
      if (notes.isNotEmpty) {
        error = null;
        pageState = PageState.success;
      } else {
        error = 'No Data Available';
        pageState = PageState.error;
      }
      return true;
    } on SocketException {
      error = 'Network Issue';
      isLoadingMore = false;
      pageState = PageState.error;
      return false;
    } catch (e) {
      error = e.toString();
      isLoadingMore = false;
      pageState = PageState.error;
      return false;
    }
  }

}
