import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tedreeb_edu_app/config/app_colors.dart';
import 'package:tedreeb_edu_app/core/utils/responsive.dart';

class CustomFormField extends StatelessWidget {
  final String? hintText;
  final TextEditingController controller;
  final bool? isPass;
  final TextInputType? keyType;
  final int? maxLength;
  final double? radius;
  final double? contentPadding;
  final double? verticalPadding;
  final FormFieldValidator? validator;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final bool? filled;
  final Color? filledColor;
  final bool? hasBorderSide;
  final bool? enabled;
  final Widget? suffix;
  final Widget? prefix;
  final bool? numbersOnly;
  final TextInputAction? textInputAction;
  final Color? inputColor;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;

  const CustomFormField({
    super.key,
    this.hintText,
    required this.controller,
    this.isPass,
    this.keyType,
    this.maxLength,
    this.radius,
    this.contentPadding,
    this.verticalPadding,
    this.validator,
    this.focusNode,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.filled,
    this.filledColor,
    this.hasBorderSide = true,
    this.enabled,
    this.onChanged,
    this.suffix,
    this.prefix,
    this.numbersOnly,
    this.textInputAction,
    this.inputColor,
    this.inputFormatters,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: inputColor ?? Colors.black87),
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      inputFormatters:
          inputFormatters ??
          [if (numbersOnly == true) FilteringTextInputFormatter.digitsOnly],
      enabled: enabled ?? true,
      focusNode: focusNode,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      validator: validator,
      maxLength: maxLength,
      keyboardType: keyType,
      obscureText: isPass ?? false,
      controller: controller,
      textInputAction: textInputAction,
      maxLines: maxLines,
      decoration: InputDecoration(
        fillColor: filled != null && filledColor != null ? filledColor : null,
        suffixIcon: suffix,
        prefixIcon: prefix,
        filled: filled ?? false,
        errorMaxLines: 1,
        errorBorder: OutlineInputBorder(
          borderSide:
              hasBorderSide == true
                  ? const BorderSide(color: SharedColors.redColor)
                  : BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide:
              hasBorderSide == true
                  ? const BorderSide(color: Color(0XFFCBD5E1))
                  : BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              hasBorderSide == true ? const BorderSide() : BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide:
              hasBorderSide == true ? const BorderSide() : BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              hasBorderSide == true
                  ? const BorderSide(color: Color(0XFFCBD5E1))
                  : BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: contentPadding ?? 10,
          vertical:
              verticalPadding == null
                  ? Responsive.isTablet == true
                      ? 20.h
                      : 0
                  : verticalPadding!,
        ),
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderSide:
              hasBorderSide == true
                  ? const BorderSide(color: Color(0XFFCBD5E1))
                  : BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        ),
        hintText: hintText?.tr(context: context),
      ),
    );
  }
}
