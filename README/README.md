# README:

Created by: Jun Neng
Created time: May 28, 2023 1:44 PM

# User Guide for Milestone 3

GitHub Repository: [https://github.com/ryanongwx/pawfection](https://github.com/ryanongwx/pawfection)

Deployed Application for Testing: [https://appetize.io/app/kvelvxcfe2ymjkmjtdmdjzk3wi](https://appetize.io/app/kvelvxcfe2ymjkmjtdmdjzk3wi)

**Milestone 3**

User Guide (Manager Workflow):

1. Log in with manager account
Username: ryan@gmail.com
Password: ryanongwx
2. Create pets
3. Edit and delete pets
4. Create tasks with and without assigning of volunteers
5. Edit and delete tasks
6. Manual assignment of volunteers (Person icon on each task item on “Open” tab)
7. Auto assignment of volunteers (Top right person icon)
8. Creating of volunteer account (Remember the email used, access code will be sent to that email)

User Guide (Volunteer Workflow):

1. Check for access code email to the email provided
2. Sign up for volunteer account using access code given by manager and with email that was registered
3. If unable to sign up, use this volunteer account
Username: admin@pawfection.com
Password: pawfection
4. Edit profile and indicate availability
5. Request tasks (Person icon on each task item on “Open” tab)
6. Complete tasks and provide feedback (Click on task item and scroll down)

# Motivation

I am a frequent volunteer at an animal welfare shelter. Six months ago, I was following my usual routine at the shelter, and was about to bring Grunt, my favourite dog, on his mandatory routine walk. After putting on his leash, he sat there staring at me and was reluctant to move at all! I was later informed that another volunteer had just taken him for a walk 30 minutes ago.

Existing systems that have been employed within animal welfare shelters consist of many **fragmented processes.** Videos on how to apply treatment on animals are stored on Google Drive and specific information about each pet is listed extensively within spreadsheets (see Figure 1.1 and 1.2). Additionally, coordination between volunteers and managers are done through different direct/group text messages on Telegram. A lapse like what I had encountered was a benign one but imagine the impact of more significant lapses eg. an overdose in medication administered.

![ Figure 1.1: Spreadsheet of medical conditions of pet](README%20f843c470d7dd435fa34c06f05d795d84/Screenshot_2023-05-27_at_11.18.00_AM.png)

 Figure 1.1: Spreadsheet of medical conditions of pet

![Figure 1.2: Volunteer videos stored in Google Drive](README%20f843c470d7dd435fa34c06f05d795d84/drive.jpeg)

Figure 1.2: Volunteer videos stored in Google Drive

# Aim

We aim to address the poor coordination in the assignment of tasks by managers with volunteers and the lack of proper dissemination and retrieval of information for volunteers within animal care centres. The application will also seek to ease the workload of managers through its auto-assign feature and all-in-one dashboard to track the status of tasks.

# User Stories

- As a manager, I want to be able to keep track of the status of the tasks that need to be done in the animal shelter so that there is no need to ask volunteers individually on the status of their assigned tasks.
- As a manager, I want to be able to disseminate new information to my volunteers on any new information pertaining to the pets or specific tasks in a centralised location that is easily accessible so that I do not need to send these information to the volunteers individually.
- As a manager, I want to be able to assign tasks to my volunteers quickly, and if possible, automatically on a daily basis so that there is no need for me to individually send out messages on a daily basis.
- As a volunteer, I would like to be able to view open tasks, indicate my interest as to which task I prefer to take on and also indicate my availability all using one platform instead of using different mediums so that I will not be confused as to where I need to do certain preparations.
- As a volunteer, I want to be able to retrieve information on the tasks that I am assigned to and pets that I will be handling without having to access multiple platforms so that I can easily find the relevant information quickly when I need it.

# Features

## User Authentication

### User Registration

This allows users to create a new account by providing their email address, username and a password to a manager, and thereafter being assigned an access token through email using an EmailJS API. The creation of an account will be done in-app by the manager. Validation is required for the user's email/username to ensure that they are unique and not already in use. Both volunteer and manager accounts can be created by manager accounts.

![Create User Tab](README%20f843c470d7dd435fa34c06f05d795d84/Untitled.png)

Create User Tab

### Login/Sign Up

To sign up for their account, users will receive an access code to the email that they have provided. After inputing the email they have provided and a password of their own, they will be prompted to enter the access code that was provided.

![Registration Page](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%201.png)

Registration Page

In order to login, the user will provide their email address and passwords, which will then be validated against the entries in the database to grant them entry into the app and their respective profiles.

### Password Reset

This will allow users who have forgotten their passwords to reset them. It will involve sending a password reset link to the user’s registered email account for them to create a new password. 

![Password Reset Page](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%202.png)

Password Reset Page

## Volunteer Interface

### Task Dashboard

Volunteers will be able to view the tasks assigned to them along with the detailed instruction on which pet to conduct the task on, as well as how to execute the task. On the dashboard, the category and the pet assigned to the task is displayed for ease of task identification. Only tasks assigned to the volunteer will be visible in the “Pending” and “Completed” tabs. Tasks that are unassigned will be displayed on the “Open” tab.

![Task Dashboard](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%203.png)

Task Dashboard

![Task Description](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%204.png)

Task Description

### Complete Task

Volunteers can update the status of their tasks once they have completed them. Volunteers can also provide feedback to the manager based on their experience executing the task upon completion of the task. Completed tasks are moved to the “Completed” tab as archive.

![Complete Task Page](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%205.png)

Complete Task Page

### Request Task

Volunteers can request to do certain tasks under the ‘open’ task tab by clicking on the add icon. Their requests can then be seen my managers during the assignment of tasks.

![“Open” Task Dashboard](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%206.png)

“Open” Task Dashboard

### Profile (Add/Edit)

This is where all the information about a volunteer is displayed. Volunteers will be able to edit their profile to include information about themselves, indicate the type of tasks they prefer to do, their experience in doing certain tasks and their available days for volunteering.

![My Profile Page](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%207.png)

My Profile Page

## Manager Interface

### Pet/Task/Volunteer Dashboard

Similar to the volunteer task dashboard, managers will be able to view the tasks filtered by the respective statuses of the tasks (pending, completed, open) on the task dashboard. All tasks created will be visible to the manager. 

![Task Dashboard](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%208.png)

Task Dashboard

![Task Description](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%204.png)

Task Description

Additionally, the manager interface will also have a pet dashboard and volunteer dashboard. The pet and volunteer dashboard will list out the pets and volunteers at the shelter and provide detailed information on each pet and volunteer respectively.

![Pet Dashboard](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%209.png)

Pet Dashboard

![Volunteer Dashboard](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%2010.png)

Volunteer Dashboard

### Create/Edit Pet

Managers can create new pets should any new animals be accepted into the animal shelter. The profile will contain detailed information about the pet such as its picture, breed, among other important notes.

After creating the task, the manager can edit the pet information from the pet dashboard page.

![Create Pet Page](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%2011.png)

Create Pet Page

### Create/Edit Task

Managers can create new tasks for each individual/group of pets. The task will include the task execution details, which can be in the form of videos/photos/texts, when the task should be completed by, as well as the pet which the task is designated for. The manager can choose to assign a specific volunteer for the task or delegate the assignment to the auto-assignment algorithm that we will develop later on. 

After creating the task, the manager can edit the task information from the task dashboard page.

![Create Task Page](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%2012.png)

Create Task Page

![Edit Task Page](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%2013.png)

Edit Task Page

### Manual Task Assignment

On the “Open” task dashboard, managers can click on the add-person icon to manually assign available volunteers to each task. Only available volunteers will be listed, hence, if there are no volunteers in the list, there are no volunteers available during the time allocated to the task.

![“Open” Task Dashboard](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%2014.png)

“Open” Task Dashboard

![List of Available Volunteers](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%2015.png)

List of Available Volunteers

## Auto-Assignment

The auto-assignment feature serves the same purpose as the manual task assignment feature. However, the auto-assignment feature will be able recommend a task-to-volunteer assignment mapping with just one click. If the manager is not satisfied with the task assignments, the manager can manually change the assignments in the auto-assignment screen.

![Auto-assignment Confirmation Page](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%2016.png)

Auto-assignment Confirmation Page

The auto-assignment algorithm first assigns a list of available volunteers to each task. Next, a load balancing function will ensure the task allocation to be as equal as possible to reduce the load on one single volunteer.

# Software Project Management

## Version Control System (VCS) & Workflow

We have chosen to utilise **Git** as our VCS and **GitHub** as our primary cloud-based repository. We will be using the ****************************************Git Feature Branch Workflow,**************************************** see Figure, for our VCS workflow. The Git Feature Branch Workflow was chosen due to the smaller scale of our project and to allow for easier consolidation of code.

Our Git Feature Branch Workflow has a central remote repository shared by our team that consists of a `main` branch, that has the **most updated code**, and multiple feature branches. Feature branches will branch out from the `main` branch and merged back to the `main` branch upon completion. Each feature branch will be named in a standardised manner - `branch-<FeatureName>` , where the feature name and type are written in Pascal Case. Features consist of **bug fixes** discovered in the `main` branch, ****************************minor updates,**************************** **smaller widgets** or **larger components**. Note that the **feature names for bug fixes** will be represented with numbers in the following manner - `branch-Issue11` and can be referred to with the [issue log](https://www.notion.so/ISSUE-LOG-c7be50b79d2f4e94b889eb76e5bc8301?pvs=21).

Upon completion of a feature, **pull requests** will be created on the remote repository and the **other member** in the team will **review** the request before **approval**.

![VCS Workflow](README%20f843c470d7dd435fa34c06f05d795d84/Main.png)

VCS Workflow

**Local repositories** should **pull** from the `main` branch only. **Merging** of feature branches to the main branch should only be done through **pull requests in the remote repository**.

## File Organisation

To organise our files into folders, we have utilised a combination of **folder-by-type** and **folder-by-layer.** The files are first split into their types - **models, services, repositories** and **layers.** The layers - manager screens and volunteer screens will each have a folder. 

![File Organisation](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%2017.png)

File Organisation

## Naming Convention

**Classes, enums, typedefs** and **extensions** should be named in `UpperCamelCase` . **Libraries, packages, directories,** and **source files** should be named in `snake_case(lowercase_with_underscores)` . **Variables, constants, parameters,** and **named parameters** should be named in `lowerCamelCase` .

# System Testing

We will utilise three types of testing - unit tests, widget tests and integration test at the end of every two-week sprint. Additional tests will be integrated into the test suite that have been conducted in the past sprints. Unit tests and widget tests will be implemented using [automated flutter tests](https://docs.flutter.dev/testing). Integration tests will be tested manually.

## Unit Test

Unit tests tests a single method or class. The tests mocks out other external dependencies and will verify the correctness of the unit at hand only.

The following is a code snippet of an automated unit test we have created on flutter:

![Automated unit test for addPetRepo](README%20f843c470d7dd435fa34c06f05d795d84/Screenshot_2023-06-25_at_5.03.32_PM.png)

Automated unit test for addPetRepo

**Test Suite**

| S/N | Unit  | Method | Test Case | Expected Result | Actual Output | Pass/ Fail |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | PetRepository | addPetRepo | Given a petJSON 
when passed into addPetRepo  | Then pet details is stored in FireStore petCollection | Pet details is stored in FireStore petCollection | Pass |
| 2 | PetRepository | updatePetRepo | Given a petJSON and referenceID
when passed into updatePetRepo  | Then pet details is updated in FireStore petCollection | Pet details is updated in FireStore petCollection | Pass |
| 3 | PetRepository | updatePetRepo | Given a petJSON and wrong referenceID
when passed into updatePetRepo  | Firestore error: Document not found | Firestore error: Document not found | Pass |
| 4 | PetRepository | deletePetRepo | Given a referenceID
when passed into deletePetRepo  | Then pet document with the corressponding referenceID is deleted from the FireStore petCollection | Pet document with the corressponding referenceID is deleted from the FireStore petCollection | Pass |
| 5 | PetRepository | deletePetRepo | Given an incorrect referenceID
when passed into deletePetRepo  | Firestore error: Document not found | Firestore error: Document not found | Pass |
| 6 | PetRepository | fetchAllPets |  | Then a snapshot of details of all pets will be returned | Snapshot of details of all pets will be returned | Pass |
| 7 | PetService | petFromJson | Given a petJSON 
when passed into petFromJson  | Returns a Pet object with correct properties | Correct Pet object returned | Pass |
| 8 | PetService | petToJson | Given a pet object 
when passed into petToJson  | Then returns a JSON object with correct pet properties | Correct json object returned | Pass |
| 9 | PetService | fromSnapshot | Given a snapshot object
when passed into fromSnapshot  | Then returns a Pet object with referenceId set within the snapshot | A snapshot with the Pet object returned | Pass |
| 10 | PetService | snapshotToPetList | Given a snapshot  (AsyncSnapshot<QuerySnapshot>) object
when passed into snapshotToPetList  | Then returns a list of Pets with correct properties | Pet List returned | Pass |
| 11 | PetService | snapshotToPetListModified | Given a snapshot (QuerySnapshot<Object?>) object
when passed into snapshotToPetListModified  | Then returns a list of Pets with correct properties | Pet List returned | Pass |
| 12 | PetService | updatePet | Given a pet object
when passed into updatePet  | Then updatePetRepo is called with the pet’s JSON object and its referenceId | Correct Pet details is updated | Pass |
| 13 | PetService | deletePet | Given a pet object
when passed into deletePet  | Then deletePetRepo is called with the pet’s referenceId | Pet details are removed from the database | Pass |
| 14 | PetService | addPet | Given a pet object
when passed into addPet  | Then addPetRepo is called with the pet’s JSON object | Pet details are added from the database | Pass |
| 15 | PetService | findPetByPetID | Given an existing  referenceID
when passed into findPetByPetID  | Then a pet object is returned whose referenceID corressponds to the referenceID provided | Return Pet object with the corressponding ID | Pass |
| 16 | PetService | findPetByPetID | Given an incorrect  referenceID
when passed into findPetByPetID  | Then null is returned  | Nill returned | Pass |
| 17 | UserRepository | addUserRepo | Given a userJSON 
when passed into addUserRepo  | Then user details is stored in FireStore userCollection | User details is stored in FireStore userCollection | Pass |
| 18 | UserRepository | updateUserRepo | Given a userJSON and referenceID
when passed into updateUserRepo  | Then user details is updated in FireStore userCollection | User details is updated in FireStore userCollection | Pass |
| 19 | UserRepository | updateUserRepo | Given a userJSON and wrong referenceID
when passed into updateUserRepo  | Firestore error: Document not found | Firestore error: Document not found | Pass |
| 20 | UserRepository | deleteUserRepo | Given a referenceID
when passed into deleteUserRepo  | Then user document with the corressponding referenceID is deleted from the FireStore userCollection | User document with the corressponding referenceID is deleted | Pass |
| 21 | UserRepository | deleteUserRepo | Given an incorrect referenceID
when passed into deleteUserRepo  | Firestore error: Document not found | Firestore error: Document not found | Pass |
| 22 | UserService | fetchAllUsers |  | Then a snapshot of details of all users will be returned | Snapshot of all Users returned | Pass |
| 23 | UserService | userFromJson | Given a userJSON 
when passed into userFromJson  | Returns a User object with correct properties | User object returned | Pass |
| 24 | UserService | userToJson | Given a user object 
when passed into userToJson  | Then returns a JSON object with correct user properties | Json object returned | Pass |
| 25 | UserService | fromSnapshot | Given a snapshot (AsyncSnapshot<QuerySnapshot>) object
when passed into fromSnapshot  | Then returns a User object with referenceId set | Snapshot object returned | Pass |
| 26 | UserService | snapshotToUserList | Given a snapshot (QuerySnapshot<Object?>) object
when passed into snapshotToUserList  | Then returns a list of Users with correct properties | Snapshot object returned | Pass |
| 27 | UserService | snapshotToUserListModified | Given a snapshot object
when passed into snapshotToUserListModified  | Then returns a list of Users with correct properties | Snapshot object returned | Pass |
| 28 | UserService | updateUser | Given a user object
when passed into updateUser | Then updateUserRepo is called with the user’s JSON object and its referenceId | Correct user is updated in database | Pass |
| 29 | UserService | deleteUser | Given a user object
when passed into deleteUser | Then deleteUserRepo is called with the user’s referenceId | Correct User deleted from database | Pass |
| 30 | UserService | addUser | Given a user object
when passed into addUser  | Then addUserRepo is called with the user’s JSON object | User is add to database | Pass |
| 31 | UserService | findUserByUUID | Given an existing  referenceID
when passed into findUserByUUID  | Then a user object is returned whose referenceID corressponds to the referenceID provided | User with corressponding ID is returned | Pass |
| 32 | UserService | findUserByUUIDs | Given an incorrect  referenceID
when passed into findUserByUUIDs  | Then null is returned  | Null returned | Pass |
| 33 | UserService | findUserByUsername | Given a username when passed into findUserByUsername | Then a user object whose username corressponds to the username provided will be returned | User with corressponding username is returned | Pass |
| 34 | UserService | findUserByUsername | Given an incorrect username when passed into findUserByUsername | Then null is returned | Null returned | Pass |
| 35 | UserService | currentUser | Given a Firebase auth instance object when passed into currentUser | Then the current user will be returned | Current User object returned | Pass |
| 36 | UserService | currentUser | Given a non-existent Firebase auth instance object when passed into currentUser | Then null is returned | Null is returned | Pass |
| 37 | TaskRepository | addTaskRepo | Given a taskJSON 
when passed into addTaskRepo  | Then task details is stored in FireStore taskCollection | Task details is stored in database | Pass |
| 38 | TaskRepository | updateTaskRepo | Given a taskJSON and referenceID
when passed into updateTaskRepo  | Then task details is updated in FireStore taskCollection | Task details is updated in database | Pass |
| 39 | TaskRepository | updateTaskRepo | Given a taskJSON and wrong referenceID
when passed into updateTaskRepo  | Firestore error: Document not found | Firestore error: Document not found | Pass |
| 40 | TaskRepository | deleteTaskRepo | Given a referenceID
when passed into deleteTaskRepo  | Then task document with the corressponding referenceID is deleted from the FireStore taskCollection | Task object deleted from database | Pass |
| 41 | TaskRepository | deleteTaskRepo | Given an incorrect referenceID
when passed into deleteTaskRepo  | Firestore error: Document not found | Firestore error: Document not found | Pass |
| 42 | TaskService | fetchAllTasks |  | Then a snapshot of details of all tasks will be returned | Snapshot object returned | Pass |
| 43 | TaskService | taskFromJson | Given a taskJSON 
when passed into userFromJson  | Returns a Task object with correct properties | Task object returned | Pass |
| 44 | TaskService | taskToJson | Given a task object 
when passed into taskToJson  | Then returns a JSON object with correct task properties | Json object returned | Pass |
| 45 | TaskService | fromSnapshot | Given a snapshot object
when passed into fromSnapshot  | Then returns a Task object  | Task object returned | Pass |
| 46 | TaskService | snapshotToTaskList | Given a snapshot (AsyncSnapshot<QuerySnapshot>) object
when passed into snapshotToTaskList  | Then returns a list of Tasks with correct properties | Task List returned | Pass |
| 47 | TaskService | snapshotToTaskListModified | Given a snapshot (QuerySnapshot<Object?>) object
when passed into snapshotToTaskListModified  | Then returns a list of Tasks with correct properties | Task List returned | Pass |
| 48 | TaskService | updateTask | Given a task object
when passed into updateTask | Then updateTaskRepo is called with the user’s JSON object and its referenceId | Task updated in databased | Pass |
| 49 | TaskService | deleteTask | Given a task object
when passed into deleteTask | Then deleteTaskRepo is called with the user’s referenceId | Task deleted from database | Pass |
| 50 | TaskService | addTask | Given a task object
when passed into addTask  | Then addTaskRepo is called with the user’s JSON object | Task added to database | Pass |
| 51 | TaskService | findTaskByTaskID | Given an existing  referenceID
when passed into findTaskByTaskID  | Then a task object is returned whose referenceID corressponds to the referenceID provided | Correct Task objec returned |  |

## Widget Test

A widget test tests a single widget/component. The goal of a widget test is to verify that the widget’s UI looks and interacts as expected. It separates more complex interactions that may require other components within the view layer.

In our app, we make use of FakeFirebaseFirestore to mock out the firebase database component of the widget such that external dependencies are removed and widget can be tested in isolation.

The following is a code snippet of an automated widget test on flutter:

![Screenshot 2023-07-22 at 10.43.49 PM.png](README%20f843c470d7dd435fa34c06f05d795d84/Screenshot_2023-07-22_at_10.43.49_PM.png)

![Screenshot 2023-07-22 at 10.46.38 PM.png](README%20f843c470d7dd435fa34c06f05d795d84/Screenshot_2023-07-22_at_10.46.38_PM.png)

**Test Suite**

| S/N | Widget | Method | Test Case | Expected Result | Actual Output | Pass/Fail |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | MDashboardScreen | build | Display tasks correctly | Tasks are displayed with correct names, status, and buttons | All expected text and objects are present | Pass |
| 2 | MDashboardScreen | build | Show loading indicator while waiting for data | Circular loading bar is observed during information loading | Loading bar indicator is present | Pass |
| 3 | MDashboardScreen | build | Verify presence of title, add task button, and logout button | Title, add task button, and logout button are displayed | All expected text and objects are present | Pass |
| 4 | MDashboardScreen - Searchable List | build | Enter “walking’ in any case into the search bar | Task List correctly displays all the entries whose prefix is “walking” | Only relevant Tasks are displayed | Pass |
| 5 | MDashboardScreen - ListTile | build | Tap on any List item | Dialog correctly appears with the correct task information displayed | Dialog and information correct | Pass |
| 6 | MPetScreen | build | Display pets correctly | Pets are displayed with correct names and profile pictures | All expected text and objects are present | Pass |
| 7 | MPetScreen | build | Show loading indicator while waiting for data | Circular loading bar is observed during information loading | Loading bar is present | Pass |
| 8 | MPetScreen | build | Verify presence of title, create pet button | Title and create pet button are displayed | All expected text and objects are present | Pass |
| 9 | MPetScreen - Searchable List | build | Enter “truffle’ in any case into the search bar | Pet List correctly displays all the entries whose prefix is “truffle” | All relevant pet items are correctly displayed | Pass |
| 10 | MPetScreen - ListTile | build | Tap on any List item | Dialog correctly appears with the correct pet information displayed | Dialog and information correct | Pass |
| 11 | MVolunteerListScreen | build | Display users correctly | Users are displayed with correct names and profile pictures | All expected text and objects are present | Pass |
| 12 | MVolunteerListScreen | build | Show loading indicator while waiting for data | Circular loading bar is observed during information loading | Loading bar is present | Pass |
| 13 | MVolunteerListScreen | build | Verify presence of title, create user button | Title and create user button are displayed | All expected text and objects are present | Pass |
| 14 | MVolunteerListScreen - Searchable List | build | Enter “truffle’ in any case into the search bar | Pet List correctly displays all the entries whose prefix is “truffle” | All relevant pets will be cirrectly displayed | Pass |
| 15 | MVolunteerListScreen - ListTile | build | Tap on any List item | Dialog correctly appears with the correct pet information displayed | Dialog and information displayed is correct | Pass |
| 16 | VDashboardScreen | build | Display tasks correctly | Tasks are displayed with correct names and statuses | All expected text and objects are present | Pass |
| 17 | VDashboardScreen | build | Show loading indicator while waiting for data | Circular loading bar is observed during information loading | Loading bar present | Pass |
| 18 | VDashboardScreen | build | Verify presence of title | Title is displayed | Title is present | Pass |
| 19 | TaskItem | build | Display task information correctly | Task name and icon are displayed correctly | All expected text and objects are present | Pass |
| 20 | TaskItem | build | Show add or remove request icon based on task status and user | Correct icon is displayed based on task status and user's request status | Correct icon displayed | Pass |
| 21 | TaskItem | build | Tap on any Taskitem | Dialog correctly appears with the correct task information displayed | DIalog and information correctly displayed | Pass |
| 22 | VProfileScreen | build | Display user profile information correctly | User profile information is displayed correctly | User profile information is displayed correctly | Pass |
| 22 | VProfileScreen | build | Show loading indicator while waiting for user data | Circular loading bar is observed during information loading | Loading bar present | Pass |
| 23 | VProfileScreen | build | Verify presence of app bar title and logout button | App bar title and logout button are displayed | All text and objects are present | Pass |
| 26 | VProfileScreen | build | Navigate to profile update screen on update profile button click | Profile update screen is navigated to on button click | Correct navigation | Pass |
| 29 | VProfileScreen | build | Navigate to availability update screen on update availability button click | Availability update screen is navigated to on button click | Correct navigation | Pass |
| 30 | VProfileScreen | build | Display user bio correctly | User bio is displayed correctly | User bio displayed correctly | Pass |
| 31 | VProfileScreen | build | Display user preferences correctly | User preferences are displayed correctly | User preferences displayed correctly | Pass |
| 32 | VProfileScreen | build | Display user experiences correctly | User experiences are displayed correctly | User experiences displayed correctly | Pass |

## Integration Test

An integration test tests the complete application through application-wide workflows. We will refer to the workflows as elaborated upon in the activity diagram section below to conduct these tests.

As our login interface uses an open sourced package, the test fields could not be accessed. As such, we opted to execute integration testing manually.

**Test Suite**

| S/N | Interface | Test Case | Test Case Implementation | Expected Result | Pass/Fail |
| --- | --- | --- | --- | --- | --- |
| 1 | Login | Check the interface link between the Login and Volunteer/Manager interface | Enter login credentials and click on the Login button | Manager accounts should correctly be directed to the manager interface and volunteer accounts should correctly be directed to the volunteer interface | Pass |
| 2 | MDashboardScreen/MVolunteerlistScreen/MpetScreen | Check the interface link between the respective screens and dialogs | Click on the ListItems on each of the screens | The respective dialogs will be displayed upon clicking on the listitems, showing more information on the item clicked on | Pass |
| 4 | Logout | Check the interface link between the Logout page and Volunteer/Manager interface | Click on the logout icon located in the app bar | Both Manage and Volunteer accounts should be redirected back to the login page without any option to return to their previous page | Pass |

# User Acceptance Testing

We utilised alpha and beta testing for our user acceptance tests. 

Alpha testing, carried out by ourselves, will be done after the end of the next 2 week sprint to identify any errors and bugs when all features have been finalised.

Beta testing was carried out before Milestone 2 to check for the relevance of features and possible improvements to match the needs of our target audience. The testing will be done by a tester who is a seasoned volunteer at an animal pet shelter.

## Alpha Testing

Alpha testing is to be carried out by testers within an organisation. However, we have combined alpha testing with developer testing where the testers for alpha testing are the developers.

The following bugs and feedback were provided in the alpha testing pre-Milestone 2:

| Bugs | Details |
| --- | --- |
| Update User is not able to access the Firestore database as the referenceId of the document and the referenceId of the user is not the same | This issue has arose due to the manager user creation functionality. As user creation in the user database is separate from the user creation in the Firebase Authentication, the docId of the user created in the user database does not corresspond to the UUID of the user in the Firebase Authentication |
| Available dates initialvalue is not set to what is saved in the database | The value of avaliable dates should be loaded in from the database as soon as the user clicks on the update available dates button. The initial value displayed on the calendar should be the dates previously saved in the database |

## Beta Testing

The user guide and user feedback questionnaire are given to the beta tester for testing. Beta testing was **conducted once at Milestone 2 and at Milestone 3**

### User Feedback Questionnaire

User Experience (UI/UX)

1. General User Experience ( Poor / Average / Good )
2. Intuitiveness of UI/UX ( Poor / Average / Good )

Manager Workflow

1. Volunteer Account Creation Workflow ( Poor / Average / Good )
2. Dashboard Utility ( Adequate / Insufficient )
3. Pet Creation/Update Interaction ( Poor / Average / Good )
4. Task Creation/Update Interaction ( Poor / Average / Good )
5. Manual Task Assignment ( Poor / Average / Good )

Volunteer Workflow

1. Volunteer Registration Workflow ( Poor / Average / Good )
2. Dashboard Utility ( Adequate / Insufficient )
3. Task Request Interaction ( Poor / Average / Good )
4. Profile and Availability Update Interaction ( Poor / Average / Good )

General Relevance

1. What are the features that are unnecessary?
2. Which features can be further improved for practicality?
3. What necessary features should be added?

### User Feedback

**Milestone 2**

User Guide (Manager Workflow):

1. Log in with manager account
2. Create pets
3. Edit and delete pets
4. Create tasks with and without assigning of volunteers
5. Edit and delete tasks
6. Manual assignment of volunteers
7. Creating of volunteer account

User Guide (Volunteer Workflow):

1. Sign up for volunteer account using access code given by manager
2. Edit profile and indicate availability
3. Request tasks
4. Complete tasks and provide feedback

**Tester Feedback**

Feature Improvements:

1. Task creation should allow for multi-selection volunteer and pet assignment to reduce repeat creations.
2. Change volunteer preferences to expertise instead, where expertise categories can be customised by managers. Expertise should not be taken into consideration during auto-assignment but can be seen by managers for manual assignment.
3. Tasks and volunteers should be categorised into tiers based on experience level. Volunteers will be allowed to only complete tasks within their experience tier.
4. Volunteer availability should include timing.
5. Volunteer access code can be emailed to volunteers instead.

Unnecessary Features:

1. Task preferences are unnecessary as animal shelters prioritise qualifications and equal distribution of tasks over preferences.
2. Volunteer “About me” is unnecessary, only avenues for contact should be required.

Overall Comments:

There is an existing problem for not just animal shelters but also non-governmental organisations that are working with animal sanctuaries and zoos in terms of the efficiency in task management. It will definitely be useful for these organisations.

**Milestone 3**

User Guide (Manager Workflow):

1. Log in with manager account
2. Create pets
3. Edit and delete pets
4. Create tasks with and without assigning of volunteers
5. Edit and delete tasks
6. Manual assignment of volunteers
7. Auto assignment of volunteers
8. Creating of volunteer account

User Guide (Volunteer Workflow):

1. Check for access code email
2. Sign up for volunteer account using access code given by manager 
3. Edit profile and indicate availability
4. Request tasks
5. Complete tasks and provide feedback

**Tester Feedback**

Feature Improvements:

1. Everyone does the same thing at the same time, topological → because need to do one task before you can move on to the next 
2. Availability and pet profiles will be good
3. Pet profiles for the website (for random people to see and adopt)

Unnecessary Features:

1. Most tasks are already known to the volunteers and they already know what they have to do, so perhaps the assignment of tasks may be necessary only when there are “special” tasks that have to be done.

Possible Developments:

1. A list of animals in the pet shelter for anyone to view for possible adoption.

Overall Comments:

The task dashboard may not be very applicable to experienced volunteers as they already know what to do on a routine basis, however, if there are new/special tasks, it can still be useful. The pet dashboard and update availability features are extremely relevant.

# Software Architecture & Design

## Overall Structure

![Software Design Pattern](README%20f843c470d7dd435fa34c06f05d795d84/Untitled_Diagram.drawio_(1).png)

Software Design Pattern

We utilised a **view-service-repository-model** pattern which separates business logic from visual displays and repository handling. The **********************view layer********************** contains the widgets and displays the user interface. The ****************************service layer**************************** contains the functions that conduct business logic. The **********************************repository layer********************************** is the only layer that is allowed to interact with the database. The ************************model layer************************ contains the classes for display on the view layer and provides the schema for storing in the database. 

Note that the **repository layer should not be able to access any of the functions in the service layer** as all business logic should be handled in the service layer.

**Resource intensive functions** were deployed on [Firebase’s Cloud Functions](https://firebase.google.com/docs/functions) to reduce the stress on the deployed machine. The auto-assignment function was deployed on Cloud Functions.

## Database ERD Diagram

![Pawfection ERD.jpg](README%20f843c470d7dd435fa34c06f05d795d84/Pawfection_ERD.jpg)

## UML Activity Diagrams

### Account Creation & Login Diagram

![Account Creation & Login Diagram](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%2018.png)

Account Creation & Login Diagram

Account creation can only be done by manager accounts. This is done on the volunteer dashboard where an access token will be sent to the volunteer upon creation. The volunteer will then be able to create an account using the access token and log in after.

### Task Completion Diagram (Volunteer)

![Task Completion Diagram (Volunteer)](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%2019.png)

Task Completion Diagram (Volunteer)

After completing a task, the volunteer will update the status of the task on the task dashboard and provide feedback on the task that can be reviewed by a manager.

### Task Request Diagram (Volunteer)

![Task Request Diagram (Volunteer)](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%2020.png)

Task Request Diagram (Volunteer)

On the “Open” task dashboard, volunteers can request to be assigned tasks that are not assigned yet. This request can be taken into consideration by the manager during the assignment of tasks.

### Edit Profile Diagram (Volunteer)

![Edit Profile Diagram (Volunteer)](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%2021.png)

Edit Profile Diagram (Volunteer)

After the creation of their accounts, volunteers will be able to edit their profile to include information about themselves, indicate the type of tasks they prefer to do, their experience in doing certain tasks and their available days for volunteering. These will then by reflected on the volunteer dashboard on the manager interface.

### Create Pet Diagram (Manager)

![Create Pet Diagram (Manager)](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%2022.png)

Create Pet Diagram (Manager)

Creating of pets can only be done by a manager account. This can be done by navigating to the pet dashboard and inputing the required pet details. The pet details will then be pushed to the database.

### Edit Pet Diagram (Manager)

![Edit Pet Diagram (Manager)](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%2023.png)

Edit Pet Diagram (Manager)

Editing of pets details can only be done by manager accounts. This can be done by navigating to the pet dashboard and editing the existing pet details. Upon confirming of the updated pet details, it will then be pushed to the database.

### Create Task Diagram (Manager)

![Create Task Diagram (Manager)](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%2024.png)

Create Task Diagram (Manager)

Creating of tasks can only be done by manager accounts. This can be done by navigating to the task dashboard and inputing the required details. In the create task page, the manager can choose to assign the task to a volunteer immediately or to leave the field empty for assignment at a later time. The tasks that are assigned will be displayed to its respective volunteers, while tasks that are not assigned will be displayed on the “Open” Task Dashboard to all volunteers.

### Edit Task Diagram (Manager)

![Edit Task Diagram (Manager)](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%2025.png)

Edit Task Diagram (Manager)

Editing of tasks can only be done by manager accounts. This can be done by navigating to the task dashboard and editing the existing task details. Upon confirming of the updated task details, it will then be pushed to the database and displayed on the volunteers’ task dashboard.

### Task Assignment Diagram (Manager)

![Untitled](README%20f843c470d7dd435fa34c06f05d795d84/Untitled%2026.png)

Assignment of tasks can only be done by manager accounts. On the “Open” task dashboard, a manager can either manually assign each task to one volunteer or utilise the auto-assignment feature to generate a task-to-volunteer mapping for all tasks that have available volunteers. The manager can modify the mapping generated on the auto-assignment page. The auto assignment function is called on Firebase’s Cloud Functions.

## UML Class Diagrams

### Login View Diagram

![Login View Class Diagram](README%20f843c470d7dd435fa34c06f05d795d84/loginView.png)

Login View Class Diagram

Our Login View diagram consists of the `LoginView`, `UserRepository` and `FirebaseAuth`. `FirebaseAuth` is abstracted as Firebase Authentication is an inbuilt feature on Firebase, [see here](https://firebase.google.com/docs/auth) for the documentation. `UserRepository` is utilised by `LoginView` to render either the manager view or volunteer view based on the assigned role of the user logging in.

### Task Dashboard Diagram (Volunteer)

![TaskDiagram.png](README%20f843c470d7dd435fa34c06f05d795d84/TaskDiagram.png)

A list of `TaskItem` objects representing each task is displayed on the Volunteer`DashboardView`. On the `ManagerDashboardView`, `TaskRepository` was used to get a “stream” of Task JSON objects from the database in order to constantly get the latest list of tasks. `TaskService` was used to convert the list of Task JSON objects to `Task` objects. 

Each `TaskItem` requires `Task`, for displaying the task name and task category, and `PetService`, for displaying the profile picture of the pet that is tagged to the task. `TaskItem` is a stateful widget which requires the use of `TaskItemState` due to the task request function.

### Profile Diagram (Volunteer)

![loginView.png](README%20f843c470d7dd435fa34c06f05d795d84/loginView%201.png)

The profile diagram includes the profile, profile update, update availability and profile picture update view. `ProfileView` requires the use of `FirebaseAuthUser` to identify the current user that is logged in, `User` and `UserService` for the displaying of the fields.

`ProfileUpdateView` is similar to `ProfileView` but does not utilise `FirebaseAuthUser` as the `User` model is passed from `ProfileView`.

`UpdateAvailabilityView` uses the `User` model to display a user’s availability and `UserService` to update the availability field of users.

`ProfilePictureUpdateView` updates the profile picture of users and stores the image using `StorageRepository`.

### Create/Edit Task Diagram (Manager)

![TaskDiagram.png](README%20f843c470d7dd435fa34c06f05d795d84/TaskDiagram%201.png)

The create task and edit task views utilise all services with the exception of the `FunctionsService`. The input fields of tasks include the pet assigned and user assigned to the task which utilises the `PetService` and `UserService` and `StorageRepository` is used for the uploading of image resources. `TaskService` is used for the creation and update of tasks.

### Task Dashboard Diagram (Manager)

![loginView.png](README%20f843c470d7dd435fa34c06f05d795d84/loginView%202.png)

A list of `TaskItem` objects representing each task is displayed on the `ManagerDashboardView`. On the `ManagerDashboardView`, `TaskRepository` was used to get a “stream” of Task JSON objects from the database in order to constantly get the latest list of tasks. `TaskService` was used to convert the list of Task JSON objects to `Task` objects. 

Each `TaskItem` requires `Task`, for displaying the task name and task category, and `PetService`, for displaying the profile picture of the pet that is tagged to the task.

### Create/Edit Pet Diagram (Manager)

![loginView.png](README%20f843c470d7dd435fa34c06f05d795d84/loginView%203.png)

The create and edit pet views only utilise the `PetService` for the creation of `Pet` objects to store in the database.

### Pet Dashboard Diagram (Manager)

![TaskDiagram.png](README%20f843c470d7dd435fa34c06f05d795d84/TaskDiagram%202.png)

A list of `PetItem` objects representing each task is displayed on the `PetDashboardView`. On the `PetDashboardView`, `PetRepository` was used to get a “stream” of Pet JSON objects from the database in order to constantly get the latest list of pets. `PetService` was used to convert the list of Pet JSON objects to `Pet` objects. 

Each `PetItem` requires `Pet`, for displaying the pet name and pet profile picture.

### Volunteer List Diagram (Manager)

![TaskDiagram.png](README%20f843c470d7dd435fa34c06f05d795d84/TaskDiagram%203.png)

A list of `UserItem` objects representing each task is displayed on the `VolunteerListView`. On the `VolunteerListView`, `UserRepository` was used to get a “stream” of User JSON objects from the database in order to constantly get the latest list of users. `UserService` was used to convert the list of User JSON objects to `User` objects. 

Each `UserItem` requires `User`, for displaying the username and user profile picture.

### Auto Assignment Dialog Diagram (Manager)

![loginView.png](README%20f843c470d7dd435fa34c06f05d795d84/loginView%204.png)

The `AutoAssignDialogView` utilises the `FunctionService` for the use of the `autoAssign()` method deployed on Firebase Cloud Functions. `UserService` was used for the displaying of User objects in the dropdown menu, `TaskService` was used for the displaying of the task name and `PetService` was used for the displaying of the pet profile pictures.

# Flutter Open-source Packages

We have utilised multiple open-source flutter packages for the UI/UX design of our application:

| Gems Used | Link/Repo |
| --- | --- |
| List View | https://fluttergems.dev/packages/searchable_listview/   |
| Top Tab Bar (Pending, Open, Completed) | https://fluttergems.dev/packages/flutter_advanced_segment/ |
| Bottom Navigation Bar | https://fluttergems.dev/packages/animated_notch_bottom_bar/ |
| Volunteer Profile | https://flutterawesome.com/create-a-flutter-user-profile-page-ui-where-you-can-access-and-edit-your-user-8217-s-information-within-your-flutter-app/  |
| Datepicker | https://fluttergems.dev/packages/calendar_date_picker2/ |
| Login | https://fluttergems.dev/packages/flutter_login/ |
| Create User | https://pub.dev/packages/flutter_fast_forms |

# Post Milestone 3 Objectives

We aim to achieve Minimum Viable Product 1 by addressing the following issues:

Feature Improvements

- Improve task dashboard UI to include other important information like deadline
- Improve task dashboard UX for greater ease of “Completing” Task
- Improve task dashboard logic for more experienced volunteers who may not need as much information for routined tasks
- Improve update availability to include exact timing
- Add task feature where tasks will be automatically generated if routined
- Add routine auto-assignment feature for routined task (managers do not have to assign tasks that are routined unless volunteers are not available)
- Possible “Adopt-an-animal” feature that can be accessed by any users of the application

System Improvements

- To allow for continuous integration (CI), we will utilise fastlane with flutter as a CI service
- Look for solutions for multi-tenancy for deployment of app for multiple shelters

Pilot Testing

- We also aim to conduct pilot testing upon completion of MVP 1 at [Animal Lovers League](https://www.animalloversleague.com/).

# Tech Stack

1. Flutter (Frontend)
2. Firebase
3. Node.js