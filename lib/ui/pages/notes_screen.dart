import 'package:loadmore/loadmore.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xgen/models/Notes.dart';

import '../../constants/app_colors.dart';
import '../../controllers/notes_controller.dart';
import '../../constants/enums.dart';
import '../../main.dart';
import '../../utils/widget_utils.dart';
import '../components/custom_drawer.dart';
import '../components/note_tile.dart';
import '../components/shimmer_tile.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final NotesController controller = Provider.of<NotesController>(
    navigatorKey.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    super.initState();
    controller.initList();
  }

  @override
  Widget build(final BuildContext context) {
    return WillPopScope(
      onWillPop: () => WidgetUtils.showExitPopUp(context),
      child: Scaffold(
        appBar: AppBar(title: const Text('Notes')),
        body: Selector<NotesController, Tuple2<PageState, List<Note>>>(
          selector:
              (final context, final controller) =>
                  Tuple2(controller.pageState, controller.notes),
          shouldRebuild: (
            Tuple2<PageState, List<Note>> before,
            Tuple2<PageState, List<Note>> after,
          ) {
            return true;
          },
          builder: (final context, final data, final child) {
            if (data.item1 == PageState.loading) {
              return _loadingView();
            } else if (data.item2.isNotEmpty) {
              return _notesListView();
            } else {
              return _errorView();
            }
          },
        ),
        drawer: CustomDrawer(),
      ),
    );
  }

  Widget _notesListView() {
    return LoadMore(
      isFinish: controller.notes.length >= controller.totalCount,
      onLoadMore: controller.loadMore,
      textBuilder: DefaultLoadMoreTextBuilder.english,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: controller.notes.length,
        itemBuilder: (final context, final index) {
          return NoteTile(note: controller.notes[index]);
        },
        separatorBuilder: (final context, final index) {
          return const SizedBox(height: 12);
        },
      ),
    );
  }

  Widget _loadingView() {
    return Shimmer.fromColors(
      baseColor: AppColors.greyColor,
      highlightColor: AppColors.bgColor,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: 10,
        itemBuilder: (final context, final index) {
          return const ShimmerTile();
        },
        separatorBuilder: (final context, final index) {
          return const SizedBox(height: 12);
        },
      ),
    );
  }

  Widget _errorView() {
    return Center(child: Text(controller.error ?? 'Unexpected error occured'));
  }
}
