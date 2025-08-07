
import 'package:pjbooks/common/color_extenstion.dart';
import 'package:flutter/material.dart';

import '../../backend/book_service.dart';
import '../../bookPages/book.dart';
import '../../bookPages/home_screen.dart';
import '../../common_widget/top_picks_cell.dart';
import 'main_tab_view.dart';

class GenreView extends StatefulWidget {
  final String genre;

  const GenreView({super.key,required this.genre});

  @override
  State<GenreView> createState() => _GenreViewState();
}

class _GenreViewState extends State<GenreView> {

  List books_genre = [];


  @override
  void initState() {
    super.initState();
    load_book_by_genre();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Align(
                      child: Transform.scale(
                        scale: 1.5,
                        origin: Offset(0, media.width * 0.8),
                        child: Container(
                          width: media.width,
                          height: media.width,
                          decoration: BoxDecoration(
                            color: TColor.primary,
                            borderRadius: BorderRadius.circular(media.width * 0.5),
                          ),
                        ),
                      ),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          leading: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios, color: TColor.showMessage),
                          ),
                          actions: [
                            IconButton(
                              key: const Key("menu"),
                              onPressed: () {
                                sideMenuScaffoldKey.currentState?.openEndDrawer();
                              },
                              icon: const Icon(Icons.menu, size: 30),
                            ),
                          ],
                        )

                        ,Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // SizedBox(height: media.width * 0.1),

                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Text(
                                    widget.genre.toString(),
                                    style: TextStyle(
                                      color: TColor.text,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: books_genre.map<Widget>((item) {
                              final bObj = item as Map? ?? {};

                              return GestureDetector(
                                onTap: () {
                                  openBookById(bObj["id"],context);
                                },
                                child: TopPicksCell(iObj: bObj),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),

                  ],
                ),]
          ),
        )
    );
  }

  void load_book_by_genre()
  async{
    BookService service = BookService();
    await service.loadBooksBaseOnGenre(widget.genre);
    setState(() {
      books_genre = service.books_genre;
    });
  }

  void openBookById(String bookId, BuildContext context) {
    var fullBook = books_genre.firstWhere(
          (book) => book['id'] == bookId,
      orElse: () => <String, dynamic>{},
    );

    if (fullBook.isEmpty) {
      // אפשר להציג הודעת שגיאה
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Book not found.")));
      return;
    }

    final Book newBook = Book(
      title: fullBook["title"] ?? "",
      coverImage: fullBook["pages"]?[0]?["img_url"] ?? "",
      pages:
      (fullBook["pages"] as List<dynamic>? ?? []).map((page) {
        return BookPage(
          imagePath: page["img_url"] ?? "",
          text: page["text_page"] ?? "",
          voiceUrl: page["voice_file_url"] ?? "",
        );
      }).toList()
        ..add(
          BookPage(imagePath: "", text: "", voiceUrl: "", isEndPage: true),
        ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(book: newBook)),
    );
  }

}
