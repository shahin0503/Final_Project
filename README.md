# blogapp

This project is a versatile application that includes user authentication using Firebase, allowing users to register, login, and verify their email addresses. It also features a Portfolio Manager, Blog Manager, and Contact Form, providing a comprehensive user experience for managing portfolios, creating and managing blog posts, and contacting the owner respectively.

## Features

### 1. Firebase Authentication
Register:

New users can register using their email address and password.
Users receive a verification email after registration to verify their email address.
Login:

Registered users can log in using their email address and password.
Email Verification:

Users receive an email verification link upon registration.
Email addresses must be verified to access certain features of the application.

### 2. Portfolio Manager
Edit Portfolio (Self):

Authenticated users can edit their own portfolio information.
Users can update details such as username, email, projects, skills, and achievements.
View Others' Portfolios:

Users can view detailed information about other users' portfolios.
Portfolio details include username, email, projects, skills, and achievements.

### 3. Blog Manager
Add New Blog:

Authenticated users can create new blog posts.
Users can input a title and description for the new blog post.
Update and Delete Blogs:

Authenticated users can update the content of existing blog posts.
Users can also delete their own blog posts.
View Blogs:

Users can read existing blog posts.
Blog posts display titles and descriptions.

### 4. Contact Form

Contact the Owner:
Users can fill out a contact form to send messages to the owner.
Contact form includes fields for name, email, subject, and message.

## Firebase Authentication
### Firebase Project Setup:

Set up a Firebase project in the Firebase Console.
Enable Firebase Authentication and configure email/password authentication.

### Integration with Flutter:

Add the Firebase configuration files to the Flutter project.
Initialize Firebase in the Flutter application.
dart

' void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
} '

Implement Firebase authentication methods for registration, login, and email verification.

### Contact Form
#### Sending Messages:
Users can fill out the contact form located in the "Contact" section.
Contact form includes fields for name, email, subject, and message.
Users can send messages to the owner by clicking the "Send" button.

## Setup

### Clone the repository:

https://github.com/shahin0503/Final_Project

#### Install the project dependencies:

` flutter pub get `

#### Run the app:

`flutter run`

## Usage

### User Authentication:

Register a new account with an email address and password.
Verify the email address using the verification link sent to the registered email.
Log in with the registered email and password.

### Portfolio Manager:

Edit your own portfolio information by navigating to the "Profile" section.
View others' portfolios by browsing through the list of users and clicking on a user to view their detailed portfolio information.

### Blog Manager:

Add new blog posts in the "Blog" section by clicking on the "Add Blog" button.
Update or delete existing blog posts by clicking on the corresponding options in the blog details view.
Read existing blog posts by clicking on them in the "Blog" section.

### Contact Form:

Access the "Contact" section to fill out the contact form.
Provide your name, email, subject, and message.
Click the "Send" button to send messages to the owner.


## App Demo:



https://github.com/shahin0503/Final_Project/assets/144336102/3069f2d1-a5a5-4147-aae2-a300f88b3115



