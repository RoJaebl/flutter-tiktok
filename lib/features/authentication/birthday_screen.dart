import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/view_models/signup_view_model.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';

class BirthDayScreen extends ConsumerStatefulWidget {
  const BirthDayScreen({super.key});

  @override
  ConsumerState<BirthDayScreen> createState() => _BirthDayScreenState();
}

class _BirthDayScreenState extends ConsumerState<BirthDayScreen> {
  final TextEditingController _birthdaycontroller = TextEditingController();
  DateTime initDate = DateTime.now().subtract(const Duration(days: 365 * 12));

  @override
  void initState() {
    super.initState();
    _setTextFieldDate(initDate);
  }

  @override
  void dispose() {
    _birthdaycontroller.dispose();
    super.dispose();
  }

  void _onTextTap() {
    final state = ref.read(signUpForm.notifier).state;
    ref.read(signUpForm.notifier).state = {
      ...state,
      "birthday": _birthdaycontroller.text,
    };
    ref.read(signUpProvider.notifier).signUp(context);
    // context.goNamed(InterestScreen.routeName);
  }

  void _setTextFieldDate(DateTime date) =>
      _birthdaycontroller.value = TextEditingValue(
        text: date.toString().split(' ').first,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign up",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v40,
            const Text(
              "Whene's your birthday",
              style: TextStyle(
                fontSize: Sizes.size24,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gaps.v8,
            const Text(
              "Your birthday won't be shown publicly",
              style: TextStyle(
                fontSize: Sizes.size16,
                color: Colors.black54,
              ),
            ),
            Gaps.v16,
            TextField(
              enabled: false,
              controller: _birthdaycontroller,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              cursorColor: Theme.of(context).primaryColor,
            ),
            Gaps.v16,
            GestureDetector(
              onTap: _onTextTap,
              child: FormButton(disabled: ref.watch(signUpProvider).isLoading),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 250,
        child: SizedBox(
          height: 600,
          child: CupertinoDatePicker(
            maximumDate: initDate,
            initialDateTime: initDate,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: _setTextFieldDate,
          ),
        ),
      ),
    );
  }
}
