# Weather To Rock

Weather To Rock was developed as a test project for the mobile software engineer position at CloudWalk, this app offers real-time weather updates and forecasts.

## Table of Contents

- [Project Description](#project-description)
- [Getting Started](#getting-started)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Features](#features)
- [Running the Tests](#running-the-tests)
- [Test Coverage](#test-coverage)
- [Built With](#built-with)
- [Author](#author)
- [Contact Information](#contact-information)

## Project Description

Weather to Rock is the right choice to check the perfect weather for rock n' roll!

## Getting Started

These instructions will help you get a copy of the project up and running on your local machine for development and testing purposes.

## Prerequisites

Before installing the project, ensure that your system meets these requirements:

Operating System: Windows/Linux to test on Android or MacOS to test on iOS.

Flutter: Version 3.0 or higher.

## Installation

Follow these steps to set up the project:

Install Project Dependencies:

```bash
flutter pub get
```

Install iOS Dependencies: (MacOS only)

```bash
  cd ios && pod install --repo-update
```

Setup Environment:

Rename `env.example` to `.env`.

Fill in the environment constants. For testing, use:

```makefile
API_URL = "https://api.openweathermap.org/data/2.5/"
API_KEY = "466d33491caccc7eeb2b2bacabf94f0c"
```

## Features

- Real-Time Weather Updates: Get the latest weather updates and forecasts for selected city with an internet connection.

- Offline Access: Save weather data for offline viewing, ensuring access to information even without an internet connection.

- City Search: Easily search for cities by name to find their current weather conditions.

| Search City | Get Weather | Offline Weather |
| --- | --- | --- |
| ![untitled3](https://github.com/GabrielPeresBernes/weather-to-rock/assets/20260561/d1e83bd0-7333-495a-b4bf-991a6ed63c53) | ![untitled99](https://github.com/GabrielPeresBernes/weather-to-rock/assets/20260561/366f5173-9864-4ce0-925b-c0b25a590fa2) | ![untitled999](https://github.com/GabrielPeresBernes/weather-to-rock/assets/20260561/935a4a3a-868e-4b2d-ae5f-0a0fe40ace39) |

## Running the Tests

Unit and Widget Tests:

```bash
flutter test
```

These tests ensure that individual units of the code work as expected.

Integration Tests:

```bash
flutter test integration_test/<file_test.dart> -d <DEVICE_ID>
```

These tests check the app's performance as a whole.

## Test Coverage

To evaluate the test coverage:

```bash
flutter test --coverage
```

Then, generate a coverage report:

```bash
genhtml coverage/lcov.info -o coverage/html
```

Open index.html in the coverage directory to view the report.

![2024-01-29_01-12](https://github.com/GabrielPeresBernes/weather-to-rock/assets/20260561/cde853e9-32ef-48de-aa19-78ec1f1e9ba9)

## Built With

- [Bloc](https://pub.dev/packages/bloc) - State management
- [GetIt](https://pub.dev/packages/get_it) - Dependency injection
- [GoRouter](https://pub.dev/packages/go_router) - Routing
- [Dartz](https://pub.dev/packages/dartz) - Functional programming
- [Http](https://pub.dev/packages/http) - Networking

## Author

Gabriel Peres Bernes

## Contact Information

For additional questions or comments, feel free to contact me at:

Email: bernes.dev@gmail.com

LinkedIn: https://www.linkedin.com/in/gabriel-peres-bernes/
