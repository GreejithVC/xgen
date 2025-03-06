import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/Notes.dart';
import '../../constants/app_theme.dart';

class NoteTile extends StatelessWidget {
  const NoteTile({
    required this.note,
    super.key,
  });

  final Note note;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      titleAlignment: ListTileTitleAlignment.titleHeight,
      tileColor: AppColors.tileColor,
      leading: _leadingIconView(),
      subtitle: _bodyView(),
      minVerticalPadding: 10,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _titleView('Title', note.title),
          const SizedBox(height: 4),
          _titleView(
            'Content',
             note.content,
          ),
          const SizedBox(height: 2),
        ],
      ),
    );
  }

  Widget _leadingIconView() {
    return CircleAvatar(
      radius: 23,
      backgroundColor: AppColors.greyColor,
      child: Text(
        note.title?.isNotEmpty == true ? note.title![0].toUpperCase() : '',
        style: appTheme.textTheme.titleMedium,
      ),
    );
  }

  Widget _titleView(final String title, final String? value) {
    return RichText(
      text: TextSpan(
        style: appTheme.textTheme.labelMedium,
        children: <TextSpan>[
          TextSpan(
            text: '$title : ',
            style: appTheme.textTheme.bodyMedium?.copyWith(
                color: AppColors.greyColor, fontStyle: FontStyle.italic),
          ),
          TextSpan(
            text: value ?? '',
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _bodyView() {
    return Text(
      note.content ?? '....',
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
      style: appTheme.textTheme.bodyMedium,
    );
  }
}
