Book Beauty Salon
This project is a Beauty Salon App developed for my university. It includes both mobile and desktop components.

Mobile Application: Built with Flutter, supports Android and iOS (though not the primary focus).
Desktop Application: Developed for Windows, and Linux support is available but not guaranteed.
Backend: Built with .NET, providing services for both the customer and salon staff (admins and hairdressers).
Key Features
Mobile Application (Customer Interface)
Browse available services
Book appointments
Make orders with PayPal payment integration
View booking history
Desktop Application (Admin and Hairdresser Interface)
Admin: Manage appointments, customer data, and critical salon tasks
Hairdresser: View customer details and manage appointments
Setup Instructions
Prerequisites
Ensure that you have the following installed:

Docker (Ensure Docker Desktop is running)
Flutter
Android Emulator (e.g., Android Studio)
Backend Setup
Start Docker Desktop
Ensure Docker is running on your machine.

Run the Backend Services
In your terminal, navigate to the project directory and execute:
docker compose up
Wait for Docker to finish composing the services.

Frontend Setup (Mobile & Desktop)

Install Dependencies
In the project directory, run the following commands:
flutter clean
flutter pub get

Run the Mobile Application
Choose your preferred Android emulator and run the application.

Run both Android and Windows Simultaneously
In the Run & Debug menu, select Android & Windows to run both platforms.

Important: When running both, modify the emulator ID in the launch.json file located in the .vscode folder.
User Credentials
Administrator
Username: admin
Password: admin
Hairdresser
Username: frizer

Password: frizer

Username: melihakazic

Password: frizer

User
Username: korisnik

Password: korisnik

Username: zehrasekic

Password: korisnik

Username: lejlakovacevic

Password: korisnik

PayPal Credentials
Email: customer-bookbeauty@personal.example.com
Password: customer-bookbeauty

Notes
Environment Variables: The application uses environment variables instead of hardcoded routes and ports. You can modify settings like RabbitMQ and database credentials in the env file.

Cross-Platform Support: While the app can be run on iOS (for mobile) and Linux (for desktop), these platforms were not the primary focus during development. As a result, you may experience unexpected behaviors, errors, and bugs.

