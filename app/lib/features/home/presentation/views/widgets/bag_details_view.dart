import 'package:flutter/material.dart';
import 'package:stylebox/generated/l10n.dart';
import '../../../../../constant.dart';

class BagDetailsView extends StatelessWidget {
  const BagDetailsView({super.key});
  static const routeName = '/bag-details';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// 🔹 الصورة فوق
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Image.asset(
              "assets/images/onboarding_image1.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// 🔹 الجزء الأبيض
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? KdarkModeCardColor
                    : KlightModeCardColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "5.0",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? KdarkModeTextColor
                                    : KlightModeTextColor,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(Icons.star, color: KaccentColor),
                          ],
                        ),
                        Text(
                          S.of(context)!.bagDetailsTitle,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? KdarkModeTextColor
                                : KlightModeTextColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Text(
                      S.of(context)!.bagDetailsPriceLabel,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? KdarkModeTextSecondary
                            : KlightModeTextSecondary,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      S.of(context)!.bagDetailsCurrentPrice,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? KdarkModeTextColor
                            : KlightModeTextColor,
                      ),
                    ),

                    Text(
                      S.of(context)!.bagDetailsOldPrice,
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? KdarkModeTextSecondary
                            : KlightModeTextSecondary,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      S.of(context)!.bagDetailsWhatInsideTitle,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? KdarkModeTextColor
                            : KlightModeTextColor,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      S.of(context)!.bagDetailsDescription,
                      style: TextStyle(
                        height: 1.5,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? KdarkModeTextSecondary
                            : KlightModeTextSecondary,
                      ),
                    ),

                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: KprimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          S.of(context)!.bagDetailsReservePickup,
                          style: TextStyle(
                            fontSize: 18,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? KprimaryColorLight
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
