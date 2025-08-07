import 'package:flutter/material.dart';
import 'package:pjbooks/backend/config.dart';
import 'package:pjbooks/backend/user_prefs.dart';
import 'package:pjbooks/bookPages/book.dart';
import 'package:pjbooks/bookPages/home_screen.dart';
import 'package:pjbooks/backend/book_service.dart';
import 'package:pjbooks/common/color_extenstion.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class CreateOwnStory extends StatefulWidget {
  final Map<String, dynamic>? bookData;

  const CreateOwnStory({super.key, this.bookData});
  @override
  State<StatefulWidget> createState() => _CreateOwnStoryState();
}

class _CreateOwnStoryState extends State<CreateOwnStory> {
  List<TextEditingController> controllers = [TextEditingController()];
  TextEditingController titleController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    titleController.dispose();
    subjectController.dispose();
    descriptionController.dispose();
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void submitStory() async {


    final token = await UserPrefs.getToken();
    final author = await UserPrefs.getFullName() ?? "Unknown";

    if (token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("You must be logged in")));
      return;
    }

    if (titleController.text.trim().isEmpty ||
        subjectController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields")),
      );
      return;
    }

    List<String> pagesTexts =
        controllers
            .map((c) => c.text.trim())
            .where((text) => text.isNotEmpty)
            .toList();

    final aiStoryData = {
      "subject": subjectController.text.trim(),
      "numPages": pagesTexts.length,
      "auther": author,
      "description": descriptionController.text.trim(),
      "title": titleController.text.trim(),
      "text_to_voice": true,
      "resolution": "1024x898",
      "story_pages": pagesTexts,
      if (widget.bookData != null) ...{
        "title_previous": widget.bookData!["title"],
        "pages_previous": widget.bookData!["pages"],
      },
    };

    // בחר את ה-URL בהתאם אם זה המשך או ספר חדש
    final uri = Uri.parse(
      "${Config.baseUrl}/api/story-ai/MagicOfStory/Story" +
          (widget.bookData != null ? "/Sequel" : ""),
    );

    try {
      setState(() {
        isLoading = true;
      });

      final aiResponse = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(aiStoryData),
      );

      print(aiStoryData);

      if (aiResponse.statusCode != 200) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("AI story error: ${aiResponse.body}")),
        );
        return;
      }

      final responseData = jsonDecode(aiResponse.body);

      await context.read<BookService>().loadBooks();

      final Book newBook = Book(
        title: responseData["title"],
        coverImage: responseData["pages"]?[0]?["img_url"] ?? "",
        pages:
            (responseData["pages"] as List<dynamic>).map((page) {
                return BookPage(
                  imagePath: page["img_url"] ?? "",
                  text: page["text_page"] ?? "",
                  voiceUrl: page["voice_file_url"] ?? "",
                );
              }).toList()
              ..add(
                BookPage(
                  imagePath: "",
                  text: "",
                  voiceUrl: "",
                  isEndPage: true,
                ),
              ),
      );

      for (var page in newBook.pages) {
        if (page.imagePath.isNotEmpty) {
          await precacheImage(NetworkImage(page.imagePath), context);
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Book created successfully!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(book: newBook)),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
    setState(() {
      isLoading = false;
    });
  }

  void addTextField() {
    if (controllers.last.text.trim().isNotEmpty) {
      setState(() {
        controllers.add(TextEditingController());
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("The previous page is empty!")),
      );
    }
  }

  void deleteTextField(int index) {
    if (controllers.length > 1) {
      setState(() {
        controllers[index].dispose();
        controllers.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("you can't delete the last text")),
      );
    }
  }

  void showDeleteWarningDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete"),
          content: const Text("Are you sure?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                deleteTextField(index);
                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    if (isLoading) {
      return loadScreen();
    } else {
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
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                    top: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 70),

                      Text(
                        "Create your own story",
                        style: TextStyle(
                          color: TColor.text,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Write the story and we will create a book for you with the text you've written and with images.",
                        style: TextStyle(color: TColor.subTitle, fontSize: 15),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Each text box represents a page in the book. Write the text you want to appear on the page, and we will combine all the pages into a complete book.",
                        style: TextStyle(color: TColor.subTitle, fontSize: 15),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        key: Key("subject"),
                        controller: subjectController,
                        decoration: const InputDecoration(
                          labelText: "Subject",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        key: Key("Description"),
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: "Description",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        key: Key("Book Title"),
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: "Book Title",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // 🔽 שדות הטקסט
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controllers.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextField(
                                    key: Key("Page Number ${index + 1}"),
                                    controller: controllers[index],
                                    minLines: 1,
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      labelText: "Page Number ${index + 1}",
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Color.fromARGB(255, 244, 80, 68),
                                  ),
                                  onPressed:
                                      () => showDeleteWarningDialog(index),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // 🔽 הכפתורים
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            ElevatedButton.icon(
                              key: Key("Add Page"),
                              onPressed: addTextField,
                              icon: const Icon(Icons.add),
                              label: const Text("Add Page"),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton.icon(
                              key: Key("Create Story"),
                              onPressed: submitStory,
                              icon: const Icon(Icons.book),
                              label: const Text("Create Story"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios, color: TColor.primary),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  loadScreen() {
    return Scaffold(
      backgroundColor: TColor.primary,
      body: Center(
        child: SpinKitCircle(
          size: 140,
          itemBuilder: (context, index) {
            final colors = [Colors.white, Colors.pink, Colors.yellow];
            final color = colors[index % colors.length];
            return DecoratedBox(
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            );
          },
        ),
      ),
    );
  }
}
