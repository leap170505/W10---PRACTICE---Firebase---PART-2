* **Firebase DB: How will you update your Firebase database to handle the number of likes?**
  We will add an integer `likes` field to the Song.
* **HTTP Request: What kind of HTTP verb will you choose to increment the likes?**
  We use `PUT` to just update likes in song model.
* **Repository: Propose a method in the Song Repository to handle liking a song**
  * **Parameters:** `String songId` and `int currentLikes`.
  * **Return type:** `Future<void>` 
  * **Possible errors:** No internet connection `SocketException`, or `HttpException` if Firebase refuses the write.
* **Model View: How will you update the model view AsyncValues ?** 
  We should do an  **Optimistic Update** : Instantly increase the like counter on the ModelView’s local data and `notifyListeners()`, making the UI feel extremely fast. If the repository HTTP call fails, we revert the view model's state back.
* **View: What kind of screen or screen need to be updated?** The `LibraryItemTile` will be updated to display a Heart icon and a text counter showing `likes`.
