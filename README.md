# ProfsChezVous

A **mobile app for booking tutoring sessions**, developed with **Flutter** (frontend) and **Django** (backend).

 ![ProfsChezVous Banner](https://github.com/user-attachments/assets/889dfbcc-5f85-4c77-b477-84350906f933)




---

## Table of Contents

- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
  - [Backend Setup (Django)](#backend-setup-django)
  - [Frontend Setup (Flutter)](#frontend-setup-flutter)
- [Screenshots](#-screenshots)
- [Features](#-features)
- [Technologies Used](#-technologies-used)
- [License](#-license)

---

## Project Structure

```
.
├── ProfsChezVous_Backend # Django backend
│   ├── api
│   ├── home
│   ├── user
│   ├── media
│   ├── static/assets
│   ├── templates
│   ├── db.sqlite3
│   ├── manage.py
│   ├── requirements.txt
│   ├── nginx
│   └── .gitignore
├── profschezvousfrontend # Flutter frontend
│   ├── android
│   ├── ios
│   ├── lib
│   ├── assets/screenshots
│   ├── pubspec.yaml
│   ├── pubspec.lock
│   ├── test
│   ├── web
│   ├── linux
│   ├── windows
│   ├── macos
│   ├── .gitignore
│   └── README.md
├── LICENSE
└── README.md # Main README
```

---

## Getting Started

### Backend Setup (Django)

#### Prerequisites:
- Python 3.x
- Pip
- Virtual Environment (recommended)

#### Installation:
```bash
cd ProfsChezVous_Backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
python manage.py migrate
python manage.py createsuperuser  # Create admin user
python manage.py runserver
```

### Frontend Setup (Flutter)

#### Prerequisites:
- Flutter SDK
- Dart

#### Installation:
```bash
cd profschezvousfrontend
flutter pub get
flutter run
```

---

## Screenshots

-  **Authentication & forgot password**
  - ![Login Page (Mobile) & forgot password](https://github.com/user-attachments/assets/12434615-4381-407b-885d-1337ad00f57e)

-  **Welcome Screen & Registration**
  - ![Home Screen](https://github.com/user-attachments/assets/8eea363d-d134-49f8-89da-ba8b8b81d10d)
  - ![Parent's Child](https://github.com/user-attachments/assets/6b42bbb9-cf8c-4401-86bb-0c6821f1e160)
  - ![image](https://github.com/user-attachments/assets/df64e8e9-aa8c-488b-acd4-76e6d36498c7)
  - ![image](https://github.com/user-attachments/assets/5c9b2d67-33db-42fe-9331-ccb05d00dbbe)




-  **Parent Profiles**
  - ![Parent Profile](https://github.com/user-attachments/assets/95e08f1b-802d-4dc5-94eb-3c6f5dc511e5)
 
-  **Professor Profiles**
  - ![Professor Profile](https://github.com/user-attachments/assets/7e69b108-7a46-46e5-8c67-79294b380d14)

  

-  **Transactions**
  - ![Transactions](https://github.com/user-attachments/assets/de8eb302-a2be-4670-bffc-be22c25f3209)



-  **Notifications**
  - ![Notifications](https://github.com/user-attachments/assets/cc48b36e-a186-40b5-a66e-9061fc4adda9)
    
-  **Scheduling**
  - ![Add Availability](https://github.com/user-attachments/assets/53fdd167-2cfe-4c3b-8ade-3c05d4cc319a)


-  **Course Management**
  - ![Student Sign-up](https://github.com/user-attachments/assets/fce73358-8817-43f3-9067-d74d66396eb7)


-  **Additional Screenshots**

  - ![Contact Us](https://github.com/user-attachments/assets/94453cfa-ca4c-4ce5-be27-75ee67213318)
  - ![Confirm](https://github.com/user-attachments/assets/4d4289bc-280c-447a-8600-f113a64fa995)
  - ![4](https://github.com/user-attachments/assets/36c9b8cc-2aef-4d11-a2f3-4f8657f33b2a)
  - ![image](https://github.com/user-attachments/assets/8c9edca8-3054-4b7e-980e-bae75ea856b2)

  - ![image](https://github.com/user-attachments/assets/c6a40678-74f8-492f-9ab2-993ee5e08760)
  - ![Home](https://github.com/user-attachments/assets/15c3bc19-5857-4057-984a-707dae04c021)
  - ![Subject Selection](https://github.com/user-attachments/assets/264693f5-22c5-4b18-bb33-b8ff1b8945c9)

---
**Backend**
  - ![Backend Login](https://github.com/user-attachments/assets/9b68fb8a-58a8-44b0-a71a-e54c5b8e2e82)
  - ![Backend Dashboard](https://github.com/user-attachments/assets/a4398253-68ee-49a8-b526-19b60aca3bca)
  - ![image](https://github.com/user-attachments/assets/d2ce66ef-9896-438a-8a10-ffc5f3de9475)
  - ![image](https://github.com/user-attachments/assets/40e2552a-11eb-4eaf-8082-cc685b874aed)



## Features
- **User Authentication:** Secure login and registration system.
- **Profile Management:** Separate profiles for parents and professors.
- **Course Management:** Easy management of booked and available classes.
- **Notifications:** Alerts for important events and updates.
- **Scheduling:** Simple interface for adding and managing availability.
- **Transactions:** Detailed view of all transactions and their statuses.
- **Backend Admin:** Admin interface for managing the application backend.


## Technologies Used

- **Frontend:** Flutter, Dart
- **Backend:** Django, Django REST Framework
- **Database:** SQLite (can be switched to PostgreSQL)
- **Authentication:** JWT Authentication
- **Server:** Nginx

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

