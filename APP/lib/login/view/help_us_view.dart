import 'package:pjbooks/login/provider/auth_provider.dart';
import 'package:pjbooks/login/widgets/auth_widgets.dart';
import 'package:pjbooks/common/color_extenstion.dart';
import 'package:flutter/material.dart';
import '../../common_widget/round_button.dart';

class HelpUsView extends StatefulWidget {
  final String userId;
  const HelpUsView({super.key, required this.userId});

  @override
  State<HelpUsView> createState() => _HelpUsViewState();
}

class _HelpUsViewState extends State<HelpUsView> {
  // List of genres and their selected state
  final Map<String, bool> topGenres = {
    "Fantasy": false,
    "Adventure": false,
    "Fairy Tales": false,
    "Mystery": false,
    "Bedtime Stories": false,
    "Science Fiction": false,
  };
  final Map<String, bool> otherGenres = {
    "Romance": false,
    "Horror": false,
    "Non-Fiction": false,
    "Biography": false,
    "History": false,
    "Thriller": false,
  };
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.8,
            child: Image.asset(
              "assets/img/blue-background-with-isometric-book.jpg",
              width: media.width,
              height: media.height,
              fit: BoxFit.cover,
            ),
          ),

          SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 70),
                      Text(
                        "Help Us To Help You",
                        style: TextStyle(
                          color: TColor.text,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Tell us what kind of stories you like.",
                        style: TextStyle(color: TColor.subTitle, fontSize: 15),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Based on what you like to read, we will suggest stories created by community members.",
                        style: TextStyle(color: TColor.subTitle, fontSize: 15),
                      ),
                      const SizedBox(height: 15),
                      const Text("Top Genres"),
                      const SizedBox(height: 15),
                      // List of genre checkboxes arranged horizontally
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children:
                            topGenres.keys.map((genre) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        topGenres[genre] = !topGenres[genre]!;
                                      });
                                    },
                                    key: Key(genre),
                                    icon: Icon(
                                      topGenres[genre]!
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      color:
                                          topGenres[genre]!
                                              ? TColor.primary
                                              : TColor.subTitle.withOpacity(
                                                0.3,
                                              ),
                                    ),
                                  ),
                                  Text(
                                    genre,
                                    style: TextStyle(
                                      color: TColor.text,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 10),
                      const Text("Other Genres"),
                      const SizedBox(height: 15),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children:
                            otherGenres.keys.map((genre) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    key: Key(genre),
                                    onPressed: () {
                                      setState(() {
                                        otherGenres[genre] =
                                            !otherGenres[genre]!;
                                      });
                                    },
                                    icon: Icon(
                                      otherGenres[genre]!
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      color:
                                          otherGenres[genre]!
                                              ? TColor.primary
                                              : TColor.subTitle.withOpacity(
                                                0.3,
                                              ),
                                    ),
                                  ),
                                  Text(
                                    genre,
                                    style: TextStyle(
                                      color: TColor.text,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // TextButton(
                          //   onPressed: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => const MainTabView(),
                          //       ),
                          //     );
                          //   },
                          //   child: Text(
                          //     "Skip",
                          //     style: TextStyle(color: TColor.primary),
                          //   ),
                          // ),
                          SizedBox(
                            width: media.width * 0.1,
                            child: RoundButton(
                              key: Key("save"),
                              title: "Save",
                              onPressed:
                                  () => handleSaveGenres(
                                    context: context,
                                    userId: widget.userId,
                                    topGenres: topGenres,
                                    otherGenres: otherGenres,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          buildBackButton(context),
        ],
      ),
    );
  }
}
