# Pawfection

Pawfection is an all-in-one task management application aimed to address the poor coordination in the assignment of tasks by managers with volunteers and the lack of proper dissemination and retrieval of information for volunteers within animal care centres.

# Setup

Android (Debug)
- Clone the github repo at https://github.com/ryanongwx/pawfection
- Open Terminal in project directory
- Run flutter pub get
- Open device emulator in Android studio
- Run flutter run

Android (Release)
- Download the android apk located at build/app/outputs/flutter-apk/app-release.apk
- Install and run it on android device

IOS (Debug and Release)
- Clone the github repo at https://github.com/ryanongwx/pawfection
- Open Terminal in project directory
- Run flutter pub get
- Navigate into the ios directory
- Run pod install
- Open xcode simulator
- Run flutter run


# User Guide for Milestone 2

User Guide (Manager Workflow):

1. Log in with manager account
Username: ryan@gmail.com
Password: ryanongwx
2. Create pets
3. Edit and delete pets
4. Create tasks with and without assigning of volunteers
5. Edit and delete tasks
6. Manual assignment of volunteers
7. Creating of volunteer account (Remember to record the access code and remember the email used)

User Guide (Volunteer Workflow):

1. Sign up for volunteer account using access code given by manager and with email that was registered
2. If unable to sign up, use this volunteer account
Username: admin@pawfection.com
Password: pawfection
3. Edit profile and indicate availability
4. Request tasks
5. Complete tasks and provide feedback

If cloning to local device does not work, you may use this link to test the app. However, please note that the code is rendered online which will result in some delays in ap interaction. Link: https://appetize.io/app/ytoxssglwc3m4ckvfzbmmpyg5e?device=iphone14pro&osVersion=16.2&scale=75

Disclaimer: While testing, kindly refrain from sending in multiple queries to the database by limiting the number of times you click on the create user/pet/task as well as the signup functionality.


Disclaimer: While testing, kindly refrain from sending in multiple queries to the database by limiting the number of times you click on the create user/pet/task as well as the signup functionality.


