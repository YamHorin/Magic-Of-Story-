
# 📚 Magic of Story 

* a Flutter app combine with FLASK server connected with mongo DB
 * allows you to create, explore, and search for personalized books
 *  combining AI to generate images and text based on your responses. 
 * The book is built in an open format that simulates a real book, with a two-page interface, arrow navigation, and interactive page-turning animation. 
 * user can submit books , read them , rate and make a comment 
 * Users can create Children Stories, share them with the world, and read them with music or with a voiceover. The system consists of an application in the Dart language
 *  a server in Python that operates with AI models to create text and images according to prompt
 
----


## ✨ MAIN Features

### 📝 Create Your Own Story
- Write custom text for each page of the story.
- Features buttons: Add Page, Delete Page, Create Story.
- Send the story to the Flask server to generate content, including images.
- link to the part in the code 

### 🤖 Guiding Questions (`BookQuestionsScreen`)
- Questions grouped by categories: Idea, Characters, Conflict, Message, and more.
- Text fields for answering each question.
- Responses are stored in a map to build the story based on your answers.
- link to the part in the code 

### 🔍 Search and Discover (`SequelToStory`)
- Search dynamically for book titles or author names.
- Tags: *Your Books*, *Genre*, *News*.
- Filter results based on live text input.
- Grid view for book genres and list view for accurate search results.
- Navigation to detailed search screens (`SearchForceView`) and filter options (`SearchFilterView`).
-  link to the part in the code 

---

## 🧱 Technologies

- Flutter + Dart
- REST API (to create the story on the server)
- MONGO DB for storage 
- Local management with Shared Preferences
- UI built with `ExpansionTile`, `TextField`, `GridView`, and more.

---
## TESTING
| kind of test| function | script testing | link to the code|
| -------- | ------- | ------- | ------- | ------- |
| Usability|Users should be able to find a book in the community libraries within 2 minutes using search|Given that the database is full of children's books written in the past  , A loop that will go through five names of children's books that are definitely in the database , Inside the loop, we will run a timer from the beginning of entering the book name in the search input until the book is displayed , At the end of the loop, we will check that the average search time for a book was 2 minutes  |לינק 1 
| Performance| The system should start text-to-speech narration within 1 second of clicking the speaker icon.| Given that the database is full of children's books that were written in the past A loop that will go through five children's books that are in the database. Inside the loop, we click on the "Read" option for each book and start a timer from the moment the button is pressed until the moment the reading begins. We calculate the average time and make sure that it is between a second and a second and a half. |לינק 2
|Performance| The system should generate a complete AI-generated book (text and illustrations) within 60 seconds.   | Log in to the app as a non-new user, click Create a story with AI, start a timer, after the story is created and a confirmation screen appears, stop the timer | לינק 3 
|Process testing | making a new Story from Scratch |We will enter a new user into the system, click on the option "Create a new story manually" We will choose one of the two options, we will enter text into the system according to the selection, we will enter new images into the system from the server by means of a descriptive text accordingly, we will wait for a new children's book to be received | לינק 4 
|Process testing | reading a bookin the app | We will enter a non-new user into the system, click on the "Create a new book reading" option, select one of the two reading aloud options, and check the reading of the book (that the screen is clear to read, the page transitions are smooth, and there is no lack of text/images) | לינק 5
|Process testing  + database testing |sequel_to_story |Log in with a non-new user to the system. Click on the option "Create a sequel to a children's book." Accordingly, select a children's book. Insert a new page with text and an image accordingly. Wait for approval and display of the book. | לינק 6 

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
5. run the data maker python script 
```python
python dataMaker.py
```

6. run the server:
```python
python app.py 
```

7.  copy the ip adress of the local server

```python
copy this                 |	 
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


## 📁 Main Files

| File | Description |link in the code 
|------|------------|------|
| `create_own_story.dart` | Story creation screen with pages |לינק לשרת ולאפליקציה 
| `book_questions_screen.dart` | Guiding questions screen | לינק לשרת ולאפליקציה 
| `sequel_to_story.dart` | Book search and filter screen |לינק לשרת ולאפליקציה 
| `search_force_view.dart` | Advanced search by keywords |לינק לשרת ולאפליקציה 
| `search_filter_view.dart` | Filter by categories or genre |לינק לשרת ולאפליקציה 

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

