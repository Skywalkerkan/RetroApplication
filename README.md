
<div align="center">
  <h1>Retrospective App - Turkcell Internship HW by Erkan Coşar</h1>
</div>

RetroApp is a sophisticated mobile application designed to enhance the efficiency and effectiveness of team retrospective meetings. The app provides a dynamic and interactive platform for teams to organize, manage, and review their retrospectives, fostering a collaborative environment that promotes continuous improvement.

## Table of Contents
- [Features](#features)
  - [Screenshots](#screenshots)
  - [Tech Stack](#tech-stack)
  - [Architecture](#architecture)
- [In App](#In-App)
- [Known Issues](#known-issues)
- [Improvements](#Improvements)

## Features

 **Discuss In One Click:**
- Create Sessions: You can create custom sessions for teams.
- Retro Styles: You can choose different retro styles and create custom boards for each style.
- Boards and Cards: You can add, edit, and delete boards and cards for each retro session.
- User Management: You can add and remove users from sessions.
- Timer and Settings: You can set timer settings for sessions and create sessions anonymously.


 ## Screenshots

| Image 1                | Image 2                | Image 3                |
|------------------------|------------------------|------------------------|
| ![1](https://github.com/user-attachments/assets/a71fbbf5-8ee9-464d-bfc1-784604efd495)| ![2](https://github.com/user-attachments/assets/2664589b-bcc4-44ae-acce-33f9e9351d2a)| ![3](https://github.com/user-attachments/assets/1de835be-0046-4af4-91ea-04de9f9b0e50)|

| Image 4                | Image 5                | Image 6                |
|------------------------|------------------------|------------------------|
| ![4](https://github.com/user-attachments/assets/c8a028ae-4342-4d73-9431-b2e778f42105)| ![5](https://github.com/user-attachments/assets/5c6021d0-8636-46df-bb7b-c938c9fad67d)| ![6](https://github.com/user-attachments/assets/6f5901cb-2637-4f77-a550-68df2a23f298) |


## Tech Stack
- **Xcode:** Version 15.4
- **Language:** Swift 5.10
- **Minimum iOS Version:** 17.0


## Architecture
![Viper](https://github.com/user-attachments/assets/bc7a5b81-de8a-42c9-aab5-8e907c83dcac)

## How MVVM Works
- Data Fetching: The ViewModel interacts with the Model to retrieve data, often through network requests or database queries.

- Displaying Data: The ViewModel publishes data changes using @Published properties. SwiftUI automatically updates the View with this data.

- User Interaction: User interactions (e.g., button presses) are reported to the ViewModel, which then updates the Model.

- Reflecting Changes: Changes in the ViewModel are reflected in the View because the View observes the ViewModel using @ObservedObject or @StateObject.

- MVVM helps to keep code organized by separating data logic from the UI, making it more testable and easier to manage.

## In App
- MVVM Architecture
- SWIFT UI
- Unit Testing
- Firebase Manager

## Known Issues
- There is little problems with the timer.

## Improvements
- New features can be added to main pages and details
- Settings Details can be improved by more ui
