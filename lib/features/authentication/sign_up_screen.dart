import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:tiktok_clone/constants/gaps.dart';

import 'package:tiktok_clone/constants/sizes.dart';

import 'package:tiktok_clone/features/authentication/username_screen.dart';

import 'package:tiktok_clone/features/authentication/login_screen.dart';

import 'package:tiktok_clone/features/authentication/widgets/auth_button.dart';

import 'package:tiktok_clone/shared/slide_route.dart';
import 'package:tiktok_clone/utils.dart';
import 'package:flutter_gen/gen_l10n/intl_generated.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  void _onLoginTap(BuildContext context) => Navigator.of(context).push(
        slideRoute(screen: const LoginScreen()),
      );

  void _onEmailTap(BuildContext context) => Navigator.of(context).push(
        slideRoute(screen: const UserNameScreen()),
      );

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.size40),
              child: Column(
                children: [
                  Gaps.v80,
                  Text(
                    AppLocalizations.of(context)!.signUpTitle("TikTok"),
                    style: const TextStyle(
                      fontSize: Sizes.size24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Gaps.v20,
                  Opacity(
                    opacity: 0.7,
                    child: Text(
                      "Create a profile, follow other accounts, make your own videos, and more",
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Gaps.v40,
                  if (orientation == Orientation.portrait) ...[
                    AuthButton(
                        onTap: () => _onEmailTap(context),
                        icon: const FaIcon(FontAwesomeIcons.user),
                        text: "Use email & password"),
                    Gaps.v16,
                    const AuthButton(
                        icon: FaIcon(FontAwesomeIcons.apple),
                        text: "Continue with Apple"),
                  ],
                  if (orientation == Orientation.landscape)
                    Row(
                      children: [
                        Expanded(
                          child: AuthButton(
                              onTap: () => _onEmailTap(context),
                              icon: const FaIcon(FontAwesomeIcons.user),
                              text: "Use email & password"),
                        ),
                        Gaps.h16,
                        const Expanded(
                          child: AuthButton(
                              icon: FaIcon(FontAwesomeIcons.apple),
                              text: "Continue with Apple"),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: isDarkMode(context) ? null : Colors.grey.shade50,
            child: Padding(
              padding: const EdgeInsets.only(
                top: Sizes.size32,
                bottom: Sizes.size64,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  Gaps.h5,
                  GestureDetector(
                    onTap: () => _onLoginTap(context),
                    child: Text(
                      "Log in",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
