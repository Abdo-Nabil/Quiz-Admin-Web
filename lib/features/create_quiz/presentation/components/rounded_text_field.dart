import 'package:flutter/material.dart';

import '../../../../resources/app_margins_paddings.dart';
import '../../../../resources/colors_manager.dart';

class RoundedTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isGreenBorder;
  final int? minLines;
  final Function? onChange;
  final Function? validate;
  const RoundedTextField({
    required this.controller,
    this.isGreenBorder = false,
    this.validate,
    this.onChange,
    this.minLines,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        if (controller.text.isNotEmpty) {
          controller.selection = TextSelection(
              baseOffset: 0, extentOffset: controller.text.length);
        }
      },
      child: TextFormField(
        controller: controller,
        maxLines: 4,
        minLines: minLines ?? 1,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: isGreenBorder
                    ? Colors.lightGreenAccent
                    : ColorsManager.whiteColor),
            borderRadius: BorderRadius.circular(AppPadding.p32),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: isGreenBorder
                  ? Colors.lightGreenAccent
                  : ColorsManager.whiteColor,
            ),
            borderRadius: BorderRadius.circular(AppPadding.p32),
          ),
        ),

        style: const TextStyle(color: ColorsManager.whiteColor),
        //
        onChanged: (value) {
          if (onChange != null) {
            onChange!(value);
          }
        },
        validator: (value) {
          if (validate != null) {
            return validate!(value);
          } else {
            return null;
          }
        },
      ),
    );
  }
}
