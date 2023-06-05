# Aliefy
Group project in application development, by [Martin Nordebäck](https://github.com/Martin-Nordeback) and [Filip Hertzman](https://github.com/https://github.com/FilipHertzman).
# SwiftUI Chat Application
<img src="https://github.com/Martin-Nordeback/ChatOrganizer/assets/113906826/105fcbc9-50df-4a09-94d5-7313816f6e31" alt="Alt Text" width="400" height="400" />  

### Overview
This SwiftUI-based chat application is integrated with OpenAI. It allows users to ask questions and receive responses, with features including search, query history, and data persistence across app launches. The views are designed with SwiftUI's layout system, utilizing state variables and environment objects to manage data flow.

### Demonstration
https://github.com/Martin-Nordeback/ChatOrganizer/assets/113906826/6b83a2ad-dabb-4e3f-8154-2513ab07bf9a

### Key Features:
- Registration of new users with email or Google services, along with password handling.
- User query input and response retrieval.
- Progress indicator during response searches.
- Query history view with an option to clear history.
- Option to save specific queries to a designated folder.
- Query history persistence across app launches.
- UI/UX screens such as animated tutorial screens and splash screen.
- Async/await, making the asynchronous code easier to read and maintain.

### Key Components
- MainSearchView: User input and search interface, with options to view history and save queries.
- HistoryView: Displays user query history and provides a clear history feature.
- QuestionAnswerHistoryView: Details of a specific query.
- FolderViewModel Manages Folder and Message entities, interfacing with Core Data and ensuring the UI is updated with any changes.
- AuthViewModel: Authentication using Firebase and Google Sign-In and interfaces with Core Data for local data persistence.

### Dependencies
This application relies on certain dependencies that aren't included in the code provided, including the network calls fetching user query responses and injected views dependencies.
