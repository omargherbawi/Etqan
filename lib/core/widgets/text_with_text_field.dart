import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import 'package:tedreeb_edu_app/core/enums/text_style_enum.dart';
import 'package:tedreeb_edu_app/core/widgets/custom_form_field.dart';
import 'package:tedreeb_edu_app/core/widgets/custom_text_widget.dart';

class TextWithTextField extends StatefulWidget {
  const TextWithTextField({
    super.key,
    required this.text,
    required this.controller,
    this.textStyle,
    this.errorString,
    this.hintText,
    this.isPass,
    this.keyType,
    this.maxLength,
    this.maxLines = 1,
    this.radius,
    this.contentPadding,
    this.verticalPadding,
    this.validator,
    this.focusNode,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onChanged,
    this.filled = true,
    this.boldLabel = true,
    this.fillColor,
    this.hasBorderSide = true,
    this.enabled,
    this.width = double.infinity,
    this.suffix,
    this.prefix,
    this.labelColor,
    this.inputFormatters,
    this.textInputAction,
    this.numbersOnly,
    this.hideLabel = false,
    this.bottomPadding = true,
    this.isLocalize = true,
  });

  final String text;
  final TextStyle? textStyle;
  final TextEditingController controller;
  final String? errorString;
  final String? hintText;
  final bool? isPass;
  final bool boldLabel;
  final TextInputType? keyType;
  final int? maxLength;
  final int? maxLines;
  final double? radius;
  final double? contentPadding;
  final double? verticalPadding;
  final FormFieldValidator? validator;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final dynamic Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final bool? filled;
  final Color? fillColor;
  final bool? hasBorderSide;
  final bool? enabled;
  final double? width;
  final Widget? suffix;
  final Widget? prefix;
  final bool? numbersOnly;
  final Color? labelColor;
  final bool hideLabel;
  final bool bottomPadding;
  final bool isLocalize;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<TextWithTextField> createState() => _TextWithTextFieldState();
}

class _TextWithTextFieldState extends State<TextWithTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.bottomPadding ? 10.h : 0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.hideLabel) ...[
            widget.errorString != null
                ? Row(
                  children: [
                    CustomTextWidget(
                      isLocalize: widget.isLocalize,
                      text: widget.text,
                      fontWeight: FontWeight.w500,
                      textThemeStyle: TextThemeStyleEnum.labelSmall,
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: CustomTextWidget(
                        isLocalize: widget.isLocalize,
                        text: widget.errorString!,
                        color: Colors.red,
                      ),
                    ),
                  ],
                )
                : CustomTextWidget(
                  text: widget.text,
                  fontWeight: FontWeight.w400,
                  color:
                      widget.labelColor ??
                      Theme.of(context).colorScheme.inverseSurface,
                  isLocalize: widget.isLocalize,
                  textThemeStyle: TextThemeStyleEnum.bodyMedium,
                ),
            SizedBox(height: 5.h),
          ],
          SizedBox(
            width: widget.width ?? MediaQuery.of(context).size.width * (0.4.w),
            child: CustomFormField(
              hintText: widget.hintText?.tr(context: context),
              controller: widget.controller,
              isPass: widget.isPass,
              maxLines: widget.maxLines,
              inputFormatters: widget.inputFormatters,
              keyType: widget.keyType,
              textInputAction: widget.textInputAction,
              maxLength: widget.maxLength,
              radius: widget.radius,
              numbersOnly: widget.numbersOnly,
              contentPadding: widget.contentPadding ?? 10,
              verticalPadding: widget.verticalPadding,
              validator: widget.validator,
              focusNode: widget.focusNode,
              onEditingComplete: widget.onEditingComplete,
              onFieldSubmitted: widget.onFieldSubmitted,
              onChanged:
                  (widget.onChanged != null)
                      ? widget.onChanged
                      : (widget.errorString != null)
                      ? (p0) {
                        setState(() {});
                      }
                      : null,
              filled: widget.filled,
              filledColor:
                  widget.fillColor ?? Theme.of(context).colorScheme.onSurface,
              hasBorderSide:
                  GetPlatform.isDesktop ? widget.hasBorderSide : false,
              enabled: widget.enabled,
              suffix: widget.suffix,
              prefix: widget.prefix,
            ),
          ),
        ],
      ),
    );
  }
}
