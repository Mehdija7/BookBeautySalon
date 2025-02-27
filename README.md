__Book Beauty Salon__

This project is a Beauty Salon App developed for my university. It includes both mobile and desktop components.

* Mobile Application: Built with Flutter, it supports Android and iOS (though not the primary focus). Designed for customers, it includes functionalities such as shopping, PayPal payments, appointment reservations, favorites, product ratings, viewing average ratings, adding comments on products, viewing others' comments, editing profiles, and viewing appointment and order history.

* Desktop Application: Built with Flutter, developed for Windows, with Linux support available but not guaranteed. Designed for administrators and hairdressers, it includes functionalities such as: adding new hairdressers and deleting existing ones (admin only), viewing reports displayed as a graph of the best-selling products by category, with the ability to print, share, or save them, viewing reviews, orders, and products with filtering options. It also allows managing order details and status, editing services and products, adding new news, and viewing old news. Additionally, there is a screen displaying appointments in a calendar table format with the option to view reserved services for a selected day 

* Backend: Built with .NET, providing services for both the customer and salon staff (admins and hairdressers).

__Setup Instructions__

*Prerequisites*
Ensure that you have the following installed:

* Docker (Ensure Docker Desktop is running)
* Flutter
* Android Emulator (e.g., Android Studio)

_Backend Setup_

* Start Docker Desktop
	Ensure Docker is running on your machine.

* Run the Backend Services
	In your terminal, navigate to the project directory and execute:

	docker compose up

	Wait for Docker to finish composing the services.

_Frontend Setup (Mobile & Desktop)_

* Install Dependencies
	In the project directory, run the following commands:

	flutter clean
	flutter pub get

* Run the Mobile Application
	Choose your preferred Android emulator and run the application.

Run both Android and Windows Simultaneously
In the Run & Debug menu, select Android & Windows to run both platforms.

**Important**: When running both, modify the emulator ID in the launch.json file located in the .vscode folder.

__User Credentials__

* Administrator
	
Username: admin | Password: admin


* Hairdresser
  
Username: frizer | Password: frizer

Username: melihakazic	| Password: frizer


* User
  
Username: korisnik | Password: korisnik

Username: zehrasekic | Password: korisnik

Username: lejlakovacevic | Password: korisnik



__PayPal Credentials__

Email: customer-bookbeauty@personal.example.com
Password: customer-bookbeauty

__Notes__

* Environment Variables: The application uses environment variables instead of hardcoded routes and ports. You can modify settings like RabbitMQ and database credentials in the env file.

* On the backend, the StateMachine design pattern is implemented for the Product entity. As a result, editing and adding new products works differently than usual. When adding a new product from the desktop application, you need to activate it by clicking the Activate button on the product screen. When editing an existing product, you must first hide it, then transition it from the hidden state to the editing state, and once the edit is complete, you need to activate it again. Each product has buttons that represent allowed actions based on its current state.

* Cross-Platform Support: While the app can be run on iOS (for mobile) and Linux (for desktop), these platforms were not the primary focus during development. As a result, you may experience unexpected behaviors, errors, and bugs.

