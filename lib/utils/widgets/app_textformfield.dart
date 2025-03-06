import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_theme.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField(
      {super.key, this.controller, this.label, this.validator,this.minLines= 1});

  final TextEditingController? controller;
  final String? label;
  final FormFieldValidator<String>? validator;
  final int? minLines ;

  @override
  Widget build(final BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: null,
      minLines:minLines ,
      decoration: InputDecoration(
        label: Text(
          label ?? '',
          style: appTheme.textTheme.bodyMedium,
        ),
        fillColor: AppColors.buttonTextColor,
        filled: true,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
