# Project name

App name

#### Run these commands:

1. `flutter pub get`
2. `dart run build_runner build --delete-conflicting-outputs`

> File structure:

- api
    - **api_client** - dio client with retrofit, interceptors
    - **API Constants**
    - **API Response**

- core
    - **enum**
    - **models**
    - **themes** - app theme, colors, text styles
    - **utils** - animation, dialog, loader, extension, methods, validator, logger
    - **widgets** - app widgets & generally used widgets, bottom sheet (image picker & app)

- gen - assets generated files

- localization - app localized strings

- pages
    - page
    - controller (business logic)
    - bindings (controller initialization)

- repository
    - local repository (Local storage)
    - remote repository (API Implementation)

- routes
    - **app_routes.dart** - path names of screens
    - **app_pages.dart** - router setup for navigation

- services
    - **internet_service.dart** - internet connectivity check
    - **location_service.dart** - location services (handle permission & current address)
    - **notification_service.dart** - notification setup & notification related methods


-

## Links

Design :

## Development SDK

- Flutter 3.27.4
- Dart 3.6.2