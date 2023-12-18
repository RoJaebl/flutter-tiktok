import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/password_screen.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';
import 'package:tiktok_clone/shared/slide_route.dart';

class EmailScreenArgs {
  final String username;

  EmailScreenArgs({
    required this.username,
  });
}

final emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

class EmailScreen extends StatefulWidget {
  static String routeURL = "email";
  static String routeName = "email";

  final String username;

  const EmailScreen({
    super.key,
    required this.username,
  });

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  String _email = "";

  @override
  void initState() {
    super.initState();
    _emailcontroller.addListener(() {
      setState(() => _email = _emailcontroller.text);
    });
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    super.dispose();
  }

  String? _emailValidText() =>
      _email.isEmpty || emailRegExp.hasMatch(_email) ? null : "Email not valid";

  void _onScaffoldTap() => FocusScope.of(context).unfocus();

  void _onSubmit() => _email.isNotEmpty && _emailValidText() == null
      ? Navigator.push(
          context,
          slideRoute(screen: const PasswordScreen()),
        )
      : null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
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
              Text(
                "What is your email, ${widget.username}?",
                style: const TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v16,
              TextField(
                controller: _emailcontroller,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                onEditingComplete: _onSubmit,
                decoration: InputDecoration(
                  hintText: "Email",
                  errorText: _emailValidText(),
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
                onTap: _onSubmit,
                child: FormButton(
                    disabled: _email.isEmpty || _emailValidText() != null),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
