# Flutter Clean Architecture Template for KoDetective

This template is designed to minimize the effort of new project creation and configuration. It provides pre-installed packages, flavors, and base helper classes following clean architecture principles.

## HOW TO USE TEMPLATE

### 1. COPY FILES TO THE NEW PROJECT
1. **.run and .vscode folder** to the root of the project
2. **localization_gen.sh** to the root of the project
3. **lib folder** to the root of the project
4. **assets and fonts folder** to the root of the project
5. **desired content from pubspec.yaml** to the pubspec.yaml

### 2. GET PACKAGES
Run `flutter pub get` to install all dependencies.

### 3. FIX IMPORTS ACCORDING TO THE NEW PROJECT
Update import paths to match your new project structure.

### 4. CONFIG STYLES (FONTS, COLORS, PIXEL RESIZER..)
Customize styles in the `/core/style` directory to match your design requirements.

### 5. CONFIG APP_CONFIG.DART
Update API endpoints and environment configurations in `app_config.dart`.

### 6. DELETE EVERYTHING YOU DO NOT NEED
Remove sample features and unused components.

# About KoDetective

KoDetective is a coding education application built with Flutter using clean architecture principles. The app features:

- User authentication (login/register)
- Coding tests and challenges
- Language selection for programming exercises
- Leaderboard system to track user progress
- AI-powered assistance for coding questions
- User profiles with completed test history

## Flavors

This project has **prod** and **dev** flavors installed. They are imported to the development environment via **.run** & **.vscode** folders. Configuration for each flavor can be customized in **app_config.dart** file.

IOS flavors need to be additionally configured in XCode. [This article can be used.](https://medium.com/@animeshjain/build-flavors-in-flutter-android-and-ios-with-different-firebase-projects-per-flavor-27c5c5dac10b)

## Packages
**The core packages are:**
- [dio](https://pub.dev/packages/dio) (HTTP client)
- [get_it](https://pub.dev/packages/get_it) (service locator)
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) (state management)
- [shared_preferences](https://pub.dev/packages/shared_preferences) (local storage)
- [equatable](https://pub.dev/packages/equatable) (value equality)
- [internet_connection_checker](https://pub.dev/packages/internet_connection_checker) (for internet error processing)

**The helper packages:**
- [easy_localization](https://pub.dev/packages/easy_localization) & [easy_localization_loader](https://pub.dev/packages/easy_localization_loader) (localization)
- [responsive_sizer](https://pub.dev/packages/responsive_sizer) (responsive UI)
- [bot_toast](https://pub.dev/packages/bot_toast) (context-free notifications)
- [flutter_svg](https://pub.dev/packages/flutter_svg) (SVG rendering)
- [url_launcher](https://pub.dev/packages/url_launcher) (opening URLs)
- [mask_text_input_formatter](https://pub.dev/packages/mask_text_input_formatter) (text input formatting)
- [flutter_native_splash](https://pub.dev/packages/flutter_native_splash) (splash screen)
- [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) (app icons)
- [flutter_animate](https://pub.dev/packages/flutter_animate) (animations)
- [wave](https://pub.dev/packages/wave) (wave animations used in auth screens)
- [flutter_code_editor](https://pub.dev/packages/flutter_code_editor) (code editing capabilities)
- [flutter_markdown](https://pub.dev/packages/flutter_markdown) (markdown rendering)

## Helper classes
### Requests handling
There is a bunch of classes for handling requests:

**/core/errors** & **core/models** - models for error handling and **RepositoryRequestHandler**. The models folder stores general models for the whole project.

**/core/interceptors** - request interceptors such as **ErrorLoggerInterceptor** or **TokenInterceptor** for authorization which connects to the shared preferences repository.

**/core/network** - a tool for internet connection checking.

### Style classes
**/core/style** - colors, paddings, borders, text styles etc. *Example of text style usage: Text("My text", style: fontInstanse.s14.w600.black).*

### Other helper tools
**/core/helper** - storage config, images and icons listing, extensions, text masks etc.

**/core/util** - tools for opening URLs, pop ups, bottom sheets, showing notifications via bot_toast etc. 
There is also a **PaginationScrollController** [class for infinite pagination on scroll.](https://medium.com/@m1nori/flutter-pagination-without-any-packages-8c24095555b3)

There is a tool in the root of the project called **localization_gen.sh** - it can be used to make translations generation process easier. Run it in the terminal after you've added a new key-value pair to a translation file.

### Widgets
**/core/widgets** is used to store general widgets, like base app bars, text fields, pop up templates etc. It includes **BaseTextField**, **PrimaryButton**, and custom app bars for consistent UI.

## Feature Structure

The app follows a feature-first organization with clean architecture layers:

- **presentation**: UI components, screens, and BLoC/Cubit state management
- **domain**: Business logic, entities, and repository interfaces
- **data**: Repository implementations, data sources, and models

### Authentication Feature
- Login and registration screens with wave animations
- User profile management
- Token-based authentication

### Tests Feature
- Coding tests and challenges
- Language selection
- AI-powered assistance for questions
- Leaderboard and user progress tracking

Each feature maintains separation of concerns with its own injection container for dependency injection.

