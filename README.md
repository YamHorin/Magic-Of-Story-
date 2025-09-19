
# 📚 Magic of Story 

* a Flutter app combine with FLASK server connected with mongo DB
 * allows you to create, explore, and search for personalized books
 *  combining AI to generate images and text based on your responses. 
 * The book is built in an open format that simulates a real book, with a two-page interface, arrow navigation, and interactive page-turning animation. 
 * user can submit books , read them , rate and make a comment 
 * Users can create Children Stories, share them with the world, and read them with music or with a voiceover. The system consists of an application in the Dart language
 *  a server in Python that operates with AI models to create text and images according to prompt


 

<a href = "https://github.com/AmitIshay/flask_PJ_books" > link to the original git hub repo - SERVER </a>


<a href = "https://github.com/AmitIshay/AI_books_project" > link to the original git hub repo - APP FLUTTER</a>

----

### 📖 Reading Book Feature (`BookReaderScreen`)
- Read your created stories with **page-flipping navigation**.
- Swipe or tap to move between pages.
- Display **text and generated images** for each page.
- Responsive layout for both **text-only** and **image+text** stories.
- Button to return to the main story screen or home.


> 🔗 *<a href = "https://github.com/AmitIshay/AI_books_project/blob/master/lib/bookPages/double_page_viewer.dart"> Double Page Book Viewer file code </a>*



---

### 📝 Create Your Own Story
- Write custom text for each page of the story.
- Features buttons: Add Page, Delete Page, Create Story.
- Send the story to the Flask server to generate content, including images.

> 🔗 *<a href = "https://github.com/AmitIshay/flask_PJ_books/blob/main/ai_utils/childrenStoryMaker.py"> part in the server that makes the book object pages and images (from line 80 -175 ) </a>*


> 🔗 *<a href = "https://github.com/AmitIshay/flask_PJ_books/main/APP/lib/features/create_own_story.dart"> part in the code that that is the app interface (all the file)  </a>*

---

### 🤖 Guiding Questions (`BookQuestionsScreen`)
- Questions grouped by categories: Idea, Characters, Conflict, Message, and more.
- Text fields for answering each question.
- Responses are stored in a map to build the story based on your answers.

> 🔗 *<a href = "https://github.com/AmitIshay/flask_PJ_books/blob/main/ai_utils/childrenStoryMaker.py"> part in the server that makes the book object pages and images (from line 175 - 250 ) </a>*

> 🔗 *<a href = "https://github.com/AmitIshay/AI_books_project/blob/main/APP/lib/features/create_story_assistance.dart"> part in the code that that is the app interface (all the file)  </a>*

---

### 🔍 Search and Discover (`SequelToStory`)
- Search dynamically for book titles or author names.
- Tags: *Your Books*, *Genre*, *News*.
- Filter results based on live text input.
- Grid view for book genres and list view for accurate search results.
- Navigation to detailed search screens (`SearchForceView`) and filter options (`SearchFilterView`).

> 🔗 *<a href = "https://github.com/AmitIshay/AI_books_project/blob/main/APP/lib/features/sequel_to_story.dart"> Search Viewer (all the file)  </a>*  


> 🔗 *<a href = "https://github.com/AmitIshay/AI_books_project/blob/main/APP/lib/common_widget/history_row.dart"> part in the profile book screen (that can launch the new story screen after select the book (from line 20  all the way the and )</a>*

> 🔗 *<a href = "https://github.com/AmitIshay/flask_PJ_books/blob/main/ai_utils/childrenStoryMaker.py"> part in the server that makes the book object pages and images (from line 287 -426 ) </a>*


> 🔗 *<a href = "https://github.com/AmitIshay/AI_books_project/blob/main/APP/lib/search/search_fiter_view.dart"> part in the filter the search part (all the file) </a>*




---
### more important links :
> 🔗 *<a href = "https://github.com/AmitIshay/AI_books_project/blob/main/APP/lib/bookPages/double_page_viewer.dart"> Double Page Book Viewer (all the file)  </a>*  


> 🔗 *<a href = "https://github.com/AmitIshay/AI_books_project/main/SERVER/ai_utils/imageAIMaker.py"> part in the code that makes the images from AI (all the file)  </a>*



## 🧱 Technologies

- Flutter + Dart
- REST API (to create the story on the server)
- MONGO DB for storage 
- Local management with Shared Preferences
- UI built with `ExpansionTile`, `TextField`, `GridView`, and more.

---
## TESTING
| Kind of Test                      | Function                                                                                                                                                                                                                                                                                             | Script Testing                                                                                                                                                                                                                                                                                                                                                                                                               | Link to the Code |
|----------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|
| **Usability**                    | Users should be able to find a book in the community libraries within 2 minutes using search.                                                                                                                                                                                                       | Given that the database is full of children's books written in the past, a loop will go through five book names that are definitely in the database. Inside the loop, we will run a timer from the moment the book name is entered into the search input until the book is displayed. At the end of the loop, we will verify that the average search time is under 2 minutes.                | [Test (line 15)](https://github.com/AmitIshay/AI_books_project/blob/main/APP/integration_test/non_functional_testing_1.dart) |
| **Performance**                  | The system should start text-to-speech narration within 1 second of clicking the speaker icon.                                                                                                                                                                                                     | Given that the database is full of children's books, a loop will go through five books in the database. Inside the loop, we will click on the "Read" option for each book and start a timer from the moment the button is pressed until reading begins. We will calculate the average time and ensure it is between 1 and 1.5 seconds.                                                       | [Test (line 16)](https://github.com/AmitIshay/AI_books_project/blob/main/APP/integration_test/non_functional_testing_2.dart) |
| **Performance**                  | The system should generate a complete AI-generated book (text and illustrations) within 60 seconds.                                                                                                                                                                                                | Log in as a returning user, click on "Create a story with AI", start a timer. After the story is created and the confirmation screen appears, stop the timer. Ensure the total time does not exceed 60 seconds.                                                                                                                                    | [Test (line 17)](https://github.com/AmitIshay/AI_books_project/blob/main/APP/integration_test/non_functional_testing_3.dart) |
| **Process Testing**              | Creating a new story from scratch.                                                                                                                                                                                                                                                                   | Log in as a new user. Click "Create a new story manually", choose one of the options, enter text based on the selected option, upload new images to the system using descriptive text, and wait for the new children's book to be generated.                                                                                                      | [Test (line 17)](https://github.com/AmitIshay/AI_books_project/blob/main/APP/integration_test/functional_testing_1.dart)     |
| **Process Testing**              | Reading a book in the app.                                                                                                                                                                                                                                                                           | Log in as a returning user. Click "Create a new book reading", choose one of the two read-aloud options. Check that the book is readable, that page transitions are smooth, and that there are no missing texts or images.                                                                                                                        | [Test (line 17)](https://github.com/AmitIshay/AI_books_project/blob/main/APP/integration_test/functional_testing_2.dart)     |
| **Process + Database Testing**   | Creating a sequel to an existing story.                                                                                                                                                                                                                                                              | Log in as a returning user. Click "Create a sequel to a children's book", select an existing book, insert a new page with text and an image, and wait for approval and display of the updated book.                                                                                                                                             | [Test (line 15)](https://github.com/AmitIshay/AI_books_project/blob/main/APP/integration_test/functional_testing_3.dart)     |


---
## ✅ How to Run 
---
1. install dart  with this <a href ="https://dart.dev/get-dart"> link </a>

2. install dart  with this <a href ="https://flutter.dev/"> link </a>

3. in the server create a vrtual environment 
```python
 python -m venv 
```
dowload <a href  = "https://drive.google.com/file/d/1MaxcvpYvbKu5WQ3pVnU_H_9yr2w3LLoR/view?usp=sharing">this</a> json file (it's API key so it's not contain in the repo)

4. enter the  vrtual environment 
```python
 ./.venv/scripts/activate   
```
5. run the data maker python script and install requirements
```python
python dataMaker.py
```
```
pip install -r requirements.txt
```

6. run the server:
```python
python app.py 
```

7.  copy the ip adress of the local server

```python
copy this               |	 
                        v
 Running on http://10.0.0.8:5000
```

8.  in the app , enter the ip adress in the ` config .dart `  file :


```dart
class Config {  
  static const String baseUrl = 'http://10.0.0.8:5000';  
}
```

9.  run the app
```dart
dart run main.dart
```
9.1 to run the test file run 
```dart
dart run name of the test file from the intergration foulder 
```


## 📁 important parts in the code:

| part | Description |link in the code 
|------|------------|------|
| story maker part  | Story creation with ai  ,  |לינק לשרת ולאפליקציה 
| image AI maker |generate images with AI | לינק לשרת ולאפליקציה 
| book collection intergration| intergration with mongo DB |לינק לשרת ולאפליקציה 
|  reading a book | Advanced reading application |לינק לשרת ולאפליקציה 

---
## photos 

### welcome screen 
<img style="margin: 45px" src="https://gcdnb.pbrd.co/images/74rl2oGGH7lk.png?o=1" alt="photo1"  height="600" />

### main screen 

<img style="margin: 45px" src="https://gcdnb.pbrd.co/images/7gfVyMFTqeQX.png?o=1" alt="photo1"  height="600" />

### create your story screen 

<img style="margin: 45px" src="https://gcdnb.pbrd.co/images/V0XsDWDFBgtE.png?o=1" alt="photo1"  height="600" />

### story screen 

<img style="margin: 45px" src="https://gcdnb.pbrd.co/images/1qUDpIGi4fBL.png?o=1" alt="photo1"  height="600" />



<img style="margin: 45px" src="https://gcdnb.pbrd.co/images/bT5GxCsUkZ5X.png?o=1" alt="photo1"  height="600" />


<img style="margin: 45px" src="https://gcdnb.pbrd.co/images/vN2gv0upF9XM.png?o=1" alt="photo1"  height="600" />

### create story with assistance

<img style="margin: 45px" src="https://gcdnb.pbrd.co/images/Qgcg74DOVI4x.png?o=1" alt="photo1"  height="600" />



---

