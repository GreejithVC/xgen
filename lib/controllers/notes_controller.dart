import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xgen/main.dart';
import '../constants/enums.dart';
import '../models/Notes.dart';
import '../services/notes_service.dart';
import '../ui/pages/add_note_screen.dart';

class NotesController with ChangeNotifier {

  final NotesService _notesService = NotesService();
  List<Note> notes = [];
  String? error;
  bool isLoadingMore = false;
  int totalCount = 0;
  int page = 1;

  PageState _pageState = PageState.loading;

  set pageState(final PageState value) {
    _pageState = value;
    notifyListeners();
  }

  PageState get pageState => _pageState;

  final TextEditingController titleTC = TextEditingController();
  final TextEditingController contentTC = TextEditingController();


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
    totalCount = await _notesService.getTotalNotesCount();
    isLoadingMore = false;
    notes.clear();
    page = 1;
    _fetchNotes();
  }

  Future<bool> _fetchNotes() async {
    try {
      final response = await _notesService.fetchNotes();
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

  intiController({Note? note}) {
    _pageState = PageState.initial;
   note != null ?  (titleTC.text = note.title ??"" ) :  titleTC.clear();
    note != null ?  (contentTC.text = note.content ??"" ) :  contentTC.clear();
  }

  Future<void> loadAddNoteScreen({Note? note}) async {
    intiController(note: note);
    Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => AddNoteScreen(),
        ));
  }
  Future<void> addNote() async {
    _pageState = PageState.loading;
    try {
      await _notesService.addNote(titleTC.text, contentTC.text);
      titleTC.clear();
      contentTC.clear();
      initList();
      Navigator.pop(navigatorKey.currentContext!);
    } catch (e) {
      error = "Failed to add note: $e";
      pageState = PageState.error;
    }
  }

}


