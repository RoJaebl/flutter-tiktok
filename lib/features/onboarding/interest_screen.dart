import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

const interests = [
  "Daily Life",
  "Comedy",
  "Entertainment",
  "Animals",
  "Food",
  "Beauty & Style",
  "Drama",
  "Learning",
  "Talent",
  "Sports",
  "Auto",
  "Family",
  "Fitness & Health",
  "DIY & Life Hacks",
  "Arts & Crafts",
  "Dance",
  "Outdoors",
  "Oddly Satisfying",
  "Home & Garden",
  "Daily Life",
  "Comedy",
  "Entertainment",
  "Animals",
  "Food",
  "Beauty & Style",
  "Drama",
  "Learning",
  "Talent",
  "Sports",
  "Auto",
  "Family",
  "Fitness & Health",
  "DIY & Life Hacks",
  "Arts & Crafts",
  "Dance",
  "Outdoors",
  "Oddly Satisfying",
  "Home & Garden",
];

class InterestScreen extends StatelessWidget {
  const InterestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Choose your interests"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: Sizes.size16,
            left: Sizes.size24,
            right: Sizes.size24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v32,
              const Text(
                "Choose your interests",
                style: TextStyle(
                  fontSize: Sizes.size40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gaps.v20,
              const Text(
                "Get better video recommendations",
                style: TextStyle(
                  fontSize: Sizes.size20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gaps.v64,
              Wrap(
                runSpacing: Sizes.size14 + Sizes.size1,
                spacing: Sizes.size14 + Sizes.size1,
                children: [
                  for (var interest in interests)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: Sizes.size16,
                        horizontal: Sizes.size24,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(Sizes.size32),
                          border: Border.all(
                            color: Colors.black.withOpacity(0.1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              spreadRadius: 5,
                            )
                          ]),
                      child: Text(
                        interest,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.only(
          bottom: Sizes.size16,
          top: Sizes.size16,
          left: Sizes.size24,
          right: Sizes.size24,
        ),
        elevation: 1,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: const Stack(
            alignment: Alignment.center,
            children: [
              Text(
                "Next",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Sizes.size16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
