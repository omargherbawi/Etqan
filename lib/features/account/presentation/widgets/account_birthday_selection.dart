import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/text_with_text_field.dart';

class AccountBirthdaySelection extends StatelessWidget {
  final ValueNotifier<String?> selectedBirthday;
  final ValueChanged<String?> onChanged;

  const AccountBirthdaySelection({
    super.key,
    required this.selectedBirthday,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: selectedBirthday,
      builder: (context, birthday, _) {
        DateTime initialDate = DateTime.now().subtract(
          const Duration(days: 365 * 5),
        );

        DateTime selectedDate = initialDate;
        return GestureDetector(
          onTap: () async {
            await showModalBottomSheet<Widget>(
              backgroundColor:
                  Theme.of(context).bottomSheetTheme.backgroundColor,
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: 300.h,
                  child: Column(
                    children: [
                      Container(
                        height: 50.h,
                        color:
                            Theme.of(context).bottomSheetTheme.backgroundColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: GestureDetector(
                                onTap: () {
                                  final formattedDate = DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(selectedDate);

                                  onChanged(formattedDate);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'choose',
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: CupertinoTheme(
                          data: CupertinoThemeData(
                            textTheme: CupertinoTextThemeData(
                              dateTimePickerTextStyle:
                                  Theme.of(context).textTheme.displayMedium,
                            ),
                            primaryColor:
                                Theme.of(
                                  context,
                                ).bottomSheetTheme.backgroundColor,
                            primaryContrastingColor:
                                Theme.of(
                                  context,
                                ).bottomSheetTheme.backgroundColor,
                            barBackgroundColor:
                                Theme.of(
                                  context,
                                ).bottomSheetTheme.backgroundColor,
                            scaffoldBackgroundColor:
                                Theme.of(
                                  context,
                                ).bottomSheetTheme.backgroundColor,
                          ),
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            dateOrder: DatePickerDateOrder.dmy,
                            initialDateTime: initialDate,
                            onDateTimeChanged: (dateTime) {
                              selectedDate = dateTime;
                            },
                            maximumYear: DateTime.now().year - 5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: AbsorbPointer(
            absorbing: true,
            child: TextWithTextField(
              text: "birthday",
              hintText: "birthday",
              controller:
                  birthday != null
                      ? TextEditingController(text: birthday.toString())
                      : TextEditingController(),
              suffix: Icon(
                CupertinoIcons.calendar,
                size: 20.sp,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
          ),
        );
      },
    );
  }
}
