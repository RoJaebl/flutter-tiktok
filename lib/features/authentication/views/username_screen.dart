import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/common/shared/slide_route.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/views/email_screen.dart';
import 'package:tiktok_clone/features/authentication/view_models/signup_view_model.dart';
import 'package:tiktok_clone/features/authentication/views/widgets/form_button.dart';

class UserNameScreen extends ConsumerStatefulWidget {
  const UserNameScreen({super.key});

  @override
  ConsumerState<UserNameScreen> createState() => _UserNameScreenState();
}

class _UserNameScreenState extends ConsumerState<UserNameScreen> {
  final TextEditingController _usernamecontroller = TextEditingController();

  String _username = "";

  @override
  void initState() {
    super.initState();

    _usernamecontroller.addListener(() {
      setState(() => _username = _usernamecontroller.text);
    });
  }

  @override
  void dispose() {
    _usernamecontroller.dispose();

    super.dispose();
  }

  void _onTextTap() {
    ref.read(signUpForm.notifier).state = {
      "name": _username,
    };
    if (_username.isEmpty) return;
    Navigator.push(
      context,
      slideRoute(screen: EmailScreen(username: _username)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
              "Create username",
              style: TextStyle(
                fontSize: Sizes.size24,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gaps.v8,
            const Text(
              "You can always change this later",
              style: TextStyle(
                fontSize: Sizes.size16,
                color: Colors.black54,
              ),
            ),
            Gaps.v16,
            TextField(
              controller: _usernamecontroller,
              decoration: InputDecoration(
                hintText: "Username",
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
                child: FormButton(disabled: _username.isEmpty))
          ],
        ),
      ),
    );
  }
}
