import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xgen/controllers/notes_controller.dart';

import '../../constants/app_validators.dart';
import '../../constants/enums.dart';
import '../../controllers/auth_controller.dart';
import '../../main.dart';
import '../../utils/widgets/app_button.dart';
import '../../constants/app_strings.dart';
import '../../utils/widgets/app_textformfield.dart';
import '../../constants/app_theme.dart';

class AddNoteScreen extends StatelessWidget {
  AddNoteScreen({super.key});

  final NotesController controller =
  Provider.of<NotesController>(navigatorKey.currentContext!, listen: false);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _titleView(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child: Form(
            key: _formKey,
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  _nameView(),
                  const SizedBox(height: 16),
                  _contentlView(),
                  const SizedBox(height: 50),
                  _buttonView(),
                  const SizedBox(height: 10),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleView() {
    return Text(
      "Add New Note",
      style: appTheme.textTheme.headlineMedium?.copyWith(color: Colors.white),
    );
  }

  Widget _nameView() {
    return AppTextFormField(
      controller: controller.titleTC,
      label: AppStrings.title,
      validator: AppValidators.empty,
    );
  }

  Widget _contentlView() {
    return AppTextFormField(
      controller: controller.contentTC,
      label: AppStrings.content,
      validator: AppValidators.empty,
      minLines: 5,
    );
  }



  Widget _buttonView() {
    return Selector<NotesController, PageState>(
        selector: (buildContext, controller) => controller.pageState,
        builder: (context, data, child) {
          return AppButton(
              title: AppStrings.submit,
              isLoading: data == PageState.loading,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  controller.addNote();
                }
              });
        });
  }

}
