# Task Manager App (SwiftUI + Core Data)

## Overview

The **Task Manager App** is a simple and intuitive task management application built using **SwiftUI** for the user interface and **Core Data** for persistent storage. This app allows users to create, manage, and organize tasks efficiently, with features like task filtering, sorting, and animations for an enhanced user experience.

## Features
- **Add, edit, and delete tasks**: Manage tasks with ease, ensuring that all your to-dos are tracked.
- **Persistent storage with Core Data**: All tasks are saved locally using Core Data, providing a smooth and fast experience even when offline.
- **Task sorting and filtering**: Users can sort tasks by priority or due date and filter tasks by status (e.g., pending, completed).
- **Animated transitions**: Enjoy smooth, visual feedback with task completion animations.
- **SwiftUI**: Built entirely using SwiftUI for modern, declarative UI design.

## Technologies Used
- **SwiftUI**: Used for the user interface, leveraging declarative syntax.
- **Core Data**: Persistent storage solution for saving tasks locally.
- **Xcode**: IDE used for developing the app.

## Setup Instructions

### Prerequisites
- **Xcode 12.0** or later (Xcode 14+ recommended)
- **iOS 14.0** or later
- **macOS 11.0** or later

### Steps to Run the Project Locally

1. **Clone the repository:**

   Open your terminal and clone the project using the following command:

   ```bash
   git clone https://github.com/lovlamba/Task_Manager.git

2. **Open the project:**

   Navigate to the directory where the project is cloned and open the `.xcodeproj` file:

   ```bash
   cd Task_Manager
   open Task Manager.xcodeproj

3. **Build the project:**

   In Xcode, select the iOS simulator or a connected device, then click the "Run" button (or press `Cmd + R`) to build and run the app.

4. **Explore the app:**
  - Create new tasks by tapping the "Add Task" button.
  - Edit or delete existing tasks.
  - Mark tasks as completed and enjoy the smooth animation feedback.
  - Filter or sort tasks by using the filtering and sorting buttons in the UI.

## Core Data Setup
The project uses **Core Data** for persistent storage. The `Task` entity is defined in the data model with the following key attributes:
- `title`: The title of the task.
- `taskDescription`: The description for the task.
- `dueDate`: The date the task is due (optional).
- `type`: A String indicating task priority (e.g., low, medium, high).
- `isCompleted`: A string flag indicating if the task is completed.
- `colour`: A string assigning task colour.
Core Data relationships and attributes are managed through a @FetchRequest in the SwiftUI views, ensuring the data is updated and displayed in real-time.

## Design Rationale
### 1. SwiftUI for UI/UX
SwiftUI was chosen for its declarative syntax and powerful state management capabilities. It allows for a highly responsive user interface with minimal boilerplate code. The dynamic nature of SwiftUI makes it easier to manage UI updates and display live data.

### 2. Core Data for Persistence
Core Data is a robust solution for managing the app’s persistent storage needs. By utilizing Core Data, we ensure that all tasks created by the user are stored persistently, meaning users can access their tasks even after closing the app. The integration with SwiftUI's @FetchRequest allows for seamless UI updates whenever the Core Data context changes.

### 3. Task Sorting and Filtering
The sorting and filtering functionalities are built using Core Data's NSSortDescriptor and NSPredicate. This approach ensures that sorting and filtering are efficient and fast, directly leveraging Core Data's optimized querying mechanisms. Users can sort tasks by due date or priority and filter tasks based on their completion status (e.g., pending or completed).

### 4. Animations for User Feedback
To provide users with visual feedback, animations were incorporated into key interactions, such as marking a task as complete. SwiftUI's built-in animation capabilities make it easy to create smooth, delightful transitions, enhancing the user experience.

## Future Enhancements
- Task Categories: Allow users to organize tasks into categories or projects.
- Notifications/Reminders: Add the ability to set notifications for tasks based on due dates.
- Cloud Sync: Sync tasks across devices using CloudKit or other cloud storage solutions.
- UI Improvements: Enhance the design with more customization options, such as themes.

## Contributions
Contributions are welcome! Please fork the repository and submit a pull request for any features, improvements, or bug fixes.
1. Fork the project.
2. Create your feature branch (git checkout -b feature/YourFeature).
3. Commit your changes (git commit -m 'Add some feature').
4. Push to the branch (git push origin feature/YourFeature).
5. Open a pull request.
