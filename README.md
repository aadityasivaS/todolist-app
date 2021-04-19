
# Todolist (Not Ready)

A todolist app created with flutter and firebase.
To build this app from the source code complete the following steps:

1. Get the dependencies `flutter pub get`.
2. You will see that there is only the android directory it is because I built this app for android only. If you want to do for iOS platform first run `flutter create .` in the root and see these https://firebase.flutter.dev/docs/installation/ios.
3. Add firebase to the project https://firebase.flutter.dev/docs/overview.
4. In the firebase console enable email signin .
> 👆 Do not enable the passwordless signin in firebase console
5. Rename the `.env.help` file to `.env` and put your pixabay API key in that file.
6. Inable firestore in the firebase console.
7. Set this as the security rules.
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, update, delete: if request.auth != null && request.auth.uid == userId;
      allow create: if request.auth != null;
    }
    match /users/{userId}/lists/{id=**} {
      allow read, update, delete, create: if request.auth != null && request.auth.uid == userId;
    }
    match /users/{userId}/lists/{id}/tasks/{taskId=**} {
      allow read, update, delete, create: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```