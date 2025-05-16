__Book Beauty Salon__

This project is a Beauty Salon App developed for my university. It includes both mobile and desktop components.

* Mobile Application: Built with Flutter, it supports Android and iOS (though not the primary focus). Designed for customers, it includes functionalities such as shopping, PayPal payments, appointment reservations, favorites, product ratings, viewing average ratings, adding comments on products, viewing others' comments, editing profiles, and viewing appointment and order history.

* Desktop Application: Built with Flutter, developed for Windows, with Linux support available but not guaranteed. Designed for administrators and hairdressers, it includes functionalities such as: adding new hairdressers and deleting existing ones (admin only), viewing reports displayed as a graph of the best-selling products by category, with the ability to print, share, or save them, viewing reviews, orders, and products with filtering options. It also allows managing order details and status, editing services and products, adding new news, and viewing old news. Additionally, there is a screen displaying appointments in a calendar table format with the option to view reserved services for a selected day 

* Technologies that are used: ASP.NET, SQL, Flutter, RabbitMQ, Docker.

__Setup Instructions__

*Prerequisites*

Ensure that you have the following installed:

* Docker (Ensure Docker Desktop is running)
* Flutter
* Android Emulator (e.g., Android Studio)

**Backend Setup**

* Start Docker Desktop
	Ensure Docker is running on your machine.

* Run the Backend Services
	In your terminal, navigate to the project directory and execute:

	 docker-compose up --build 

	Wait for Docker to finish composing the services.

**Frontend Setup (Mobile & Desktop)**

_Desktop application_
  Run desktop_app.exe from Release folder in the zipped archive fit-build-2025-05-16.zip

 * Administrator
	
Username: admin | Password: test


* Hairdresser
  
Username: hairdresser | Password: test

Username: melihakazic	| Password: hairdresser

_Mobile Application_

Open Android Studio and run Emulator
Drag and drop the app-release.apk file (from flutter-apk folder in the zipped archive fit-build-2025-05-16.zip) into the Emulator, in order to install the application
Manually run the application in the Emulator

* User
  
Username: customer | Password: test

Username: zehrasekic | Password: customer

Username: lejlakovacevic | Password: customer

__PayPal Credentials__

Email: customer-bookbeauty@personal.example.com
Password: customer-bookbeauty

__Notes__

* Environment Variables: The application uses environment variables instead of hardcoded routes and ports. You can modify settings like RabbitMQ and database credentials in the env file.

* On the backend, the StateMachine design pattern is implemented for the Product entity. As a result, editing and adding new products works differently than usual. When adding a new product from the desktop application, you need to activate it by clicking the Activate button on the product screen. When editing an existing product, you must first hide it, then transition it from the hidden state to the editing state, and once the edit is complete, you need to activate it again. Each product has buttons that represent allowed actions based on its current state.

* Cross-Platform Support: While the app can be run on iOS (for mobile) and Linux (for desktop), these platforms were not the primary focus during development. As a result, you may experience unexpected behaviors, errors, and bugs.

