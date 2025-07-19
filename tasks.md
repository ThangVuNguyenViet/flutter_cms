# Flutter CMS Project Task List

This document outlines the necessary steps to build a Content Management System (CMS) using Flutter.

## Phase 1: Project Setup & Foundation

- [ ] **Initialize Flutter Project:** Create a new Flutter project.
  ```bash
  flutter create flutter_cms
  ```
- [ ] **Choose State Management:** Decide on a state management solution (e.g., BLoC, Riverpod, Provider).
- [ ] **Define Project Structure:** Organize the codebase into a scalable structure (e.g., feature-first or layer-first).
- [ ] **Setup Navigation:** Implement a routing solution (e.g., `go_router`, `auto_route`).
- [ ] **Theme & Styling:** Define the app-wide theme, including colors, typography, and widget styles.
- [ ] **Add Dependencies:** Add initial dependencies to `pubspec.yaml` (e.g., state management, router, HTTP client).

## Phase 2: Supabase Backend & Database Setup

- [ ] **Set up Supabase Project:**
    - [ ] Create a new project on the Supabase dashboard.
    - [ ] Store your project URL and anon key securely.
- [ ] **Integrate Supabase into Flutter:**
    - [ ] Add the `supabase_flutter` package to your `pubspec.yaml`.
    - [ ] Initialize Supabase in your `main.dart` file.
- [ ] **Design Database Schema in Supabase:**
    - [ ] Use the Supabase table editor to create your tables.
    - [ ] **Users Table:** Supabase provides a `users` table automatically with its authentication product. You can add a `profiles` table to store additional user data.
    - [ ] **Content Types Table:** To define the structure of different content (e.g., a "Blog Post" type has a title, body, and author).
    - [ ] **Content Items Table:** To store the actual content, linked to a content type.
    - [ ] **Media/Assets Table:** Use Supabase Storage to manage uploaded files (images, videos, etc.).
- [ ] **Implement API Services:** Create services or repositories in the Flutter app to communicate with the Supabase API using the `supabase_flutter` client.

## Phase 3: User Authentication

- [ ] **Login Screen UI:** Design and build the login interface.
- [ ] **Implement Login Logic:** Connect the UI to the authentication service.
- [ ] **Session Management:** Handle user sessions, token storage (secure storage), and auto-logout.
- [ ] **Role-Based Access Control (RBAC):**
    - [ ] Define user roles (e.g., Admin, Editor, Viewer).
    - [ ] Protect routes and actions based on the logged-in user's role.
- [ ] **(Optional) Registration Screen:** Create a flow for new user registration if needed.

## Phase 4: Admin Panel (Core CMS Features)

- [ ] **Main Dashboard/Layout:**
    - [ ] Create a persistent navigation rail or drawer for top-level sections.
    - [ ] Build a dashboard screen to show key metrics or recent activity.
- [ ] **Content Type Builder:**
    - [ ] UI to create/edit content types (e.g., name it "Products").
    - [ ] UI to add/remove fields to a content type (e.g., add fields like "Name" (text), "Price" (number), "Image" (file)).
- [ ] **Content Management:**
    - [ ] **List View:** A screen that lists all content items for a selected content type.
    - [ ] **Create/Edit Form:** A dynamic form that generates input fields based on the selected content type's schema.
    - [ ] **Delete Functionality:** Implement logic to safely delete content items.
- [ ] **Media Library:**
    - [ ] UI to display all uploaded media.
    - [ ] Functionality to upload new files.
    - [ ] Functionality to select media to link to a content item.

## Phase 5: Frontend Integration (Displaying the Content)

*This phase might be part of the same app or a separate "viewer" app.*

- [ ] **API Endpoints for Public Content:** If using a custom backend, create public-facing API endpoints to fetch content.
- [ ] **Content Rendering Service:** Create a service in the frontend to fetch and parse content from the CMS.
- [ ] **Dynamic Widget Renderer:** Build widgets that can take the CMS data (in a format like JSON) and render the appropriate Flutter widgets.

## Phase 6: Testing & Deployment

- [ ] **Unit Tests:** Write tests for business logic (state management, services).
- [ ] **Widget Tests:** Write tests for individual widgets and screens.
- [ ] **Integration Tests:** Test end-to-end user flows.
- [ ] **Build & Deploy Backend:** Deploy your backend service.
- [ ] **Build & Deploy Flutter App:**
    - [ ] **Web:** Deploy the admin panel to a web hosting service (Firebase Hosting, Netlify, Vercel).
    - [ ] **Desktop:** Create installers for macOS, Windows, and Linux.
    - [ ] **Mobile:** Publish to the Apple App Store and Google Play Store.
