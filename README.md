
# Todolist

A todolist app created with flutter and firebase.
To build this app from the source code do the following steps:

1. Get the dependencies `flutter pub get`
2. You will see that there is only the android directory it is because I built this app for android only. If you want to do for iOS platform first run `flutter create .` in the root and see these https://firebase.flutter.dev/docs/installation/ios
3. Add firebase to the project https://firebase.flutter.dev/docs/overview
4. In the firebase console enable email signin .
> 👆 Do not enable the passwordless signin in firebase console

5. make a file called secrets.json and put your pixabay API key
``
{
  "pixabayAPIKey": "your pixabay api key"
}
``
