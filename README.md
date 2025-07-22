To-Do App
A Flutter-based to-do application for managing tasks with user authentication and task assignment features. The app integrates with a Laravel backend to provide a seamless experience for creating, updating, deleting, and assigning tasks to users. It supports light and dark themes and uses Riverpod for state management.
Features

User Authentication: Login and sign-up functionality with email/username and password.
Task Management:
Create, update, and delete tasks.
Assign tasks to multiple users.
View task details, including progress, status, and activity logs.


Theme Switching: Toggle between light and dark themes.
Responsive UI: Clean, Material Design-based interface for task management.
State Management: Uses Riverpod for efficient state handling.
API Integration: Communicates with a Laravel backend using Sanctum authentication.

Prerequisites

Flutter: Version 3.0.0 or higher.
Dart: Version 2.17.0 or higher.
Node.js: For running the Laravel backend (if applicable).
PHP: For the Laravel backend (version 8.0 or higher recommended).
MySQL/PostgreSQL: For the backend database.

Setup Instructions
1. Clone the Repository
git clone https://github.com/your-username/to-do-app.git
cd to-do-app

2. Install Flutter Dependencies
Ensure Flutter is installed. Run the following to install dependencies:
flutter pub get

The project requires the following dependencies in pubspec.yaml:
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.0.0
  http: ^0.13.0
  flutter_dotenv: ^5.0.0

3. Configure Environment Variables
Create a .env file in the root of the Flutter project and add the backend API URL:
BASE_URL=http://your-backend-url:8000

Replace http://your-backend-url:8000 with your Laravel backend's URL. For local development, this is typically http://127.0.0.1:8000.
Run the following to load the environment variables:
flutter pub run build_runner build

4. Set Up the Laravel Backend

Clone the backend repository (if separate) or ensure the backend is set up.

Install PHP dependencies:
composer install


Configure the backend .env file with your database credentials and Sanctum settings.

Run migrations to set up the database:
php artisan migrate


Start the Laravel development server:
php artisan serve



5. Run the Flutter App
Ensure an emulator or physical device is connected, then run:
flutter run

The app will connect to the backend API specified in the .env file.
Usage

Login/Sign Up: 
Use the login screen to authenticate with a username/email and password.
Sign up with your details to create a new account.


Task List:
View all tasks you created or are assigned to.
Tap the Floating Action Button (FAB) to create a new task.
Tap a task to view its details.


Create Task:
Enter a title, optional description, and select a status (pending, in_progress, completed).
Submit to create the task.


Task Details:
Edit the task's title, description, progress, or status.
Delete the task using the delete button in the AppBar.
Assign users to the task via the "Assign Users" button.


Assign Users:
Select users from the list to assign them to the task.
Submit to update the task's assigned users.


Theme Toggle:
Use the theme toggle button in the task list's AppBar to switch between light and dark modes.



Project Structure
to-do-app/
├── lib/
│   ├── model/
│   │   ├── tasks.dart          # Task and Activity models
│   │   ├── user.dart           # User model
│   ├── provider/
│   │   ├── task_notifier.dart  # Task state management
│   │   ├── user_notifier.dart  # Authentication state management
│   │   ├── theme_notifier.dart # Theme state management
│   │   ├── providers.dart      # Riverpod providers
│   ├── services/
│   │   ├── api_service.dart    # API service for backend communication
│   ├── task_list_page.dart     # Main task list screen
│   ├── task_create_page.dart   # Task creation form
│   ├── task_details_page.dart  # Task details and edit screen
│   ├── assign_users_page.dart  # User assignment screen
├── .env                        # Environment variables
├── pubspec.yaml                # Flutter dependencies
└── README.md                   # This file

Screenshots
### Task List Screen:
![Server Up](screenshots/image1.png)

### Task Creation Screen:
![Database Setup](screenshots/image2.png)

### Task Details Screen:
![Task Details Screen](screenshots/task_details.png)

### Before creating tasks:
![Assign Users Screen](screenshots/image3.pngg)

### creating task:
![Task Details Screen](screenshots/image4.png)

### result:
![Assign Users Screen](screenshots/image6.png)

### Getting tasks:
![Task Details Screen](screenshots/image5.png)

### Assign Users Screen:
![Assign Users Screen](screenshots/assign_users.png)


Contributing

Fork the repository.
Create a feature branch (git checkout -b feature/your-feature).
Commit your changes (git commit -m 'Add your feature').
Push to the branch (git push origin feature/your-feature).
Open a pull request.

License
This project is licensed under the MIT License. See the LICENSE file for details.
Contact
For issues or questions, please open an issue on the GitHub repository or contact [your-email@example.com].