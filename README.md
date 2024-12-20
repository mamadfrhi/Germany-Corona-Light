# Germany Corona Light 🇩🇪🚦🦠

![Swift](https://img.shields.io/badge/Swift-5.6.1-orange) ![RxSwift](https://img.shields.io/badge/RxSwift-6.5.0-blue) ![build](https://img.shields.io/badge/build-passing-brightgreen)

![Banner](https://user-images.githubusercontent.com/28094207/166139760-7d46f069-5f5b-4685-91b7-1caa113b5aed.jpeg)

## Overview
Germany Corona Light is a meticulously designed iOS app that elegantly displays the current status of COVID-19 restrictions and alerts in Germany using a traffic light metaphor. Built with cutting-edge technologies and clean architecture, it serves as a perfect example of a scalable, user-focused application.

## Features 🚀
- **Real-Time Location-Based Status**: Displays COVID-19 rules and restrictions based on your location.
- **Localization**: Fully localized for English 🇬🇧 and German 🇩🇪.
- **Interactive UI**: Intuitive design with smooth animations and visual feedback.
- **Extensibility**: Easily adaptable for other states in Germany.

## System Architecture
Designed with scalability and maintainability in mind, the architecture employs **MVVM+C** with RxSwift and incorporates multiple design patterns for an optimal codebase.

![System Architecture](system-architecture-uml.png)

# Installation ✅

1. [Download](https://github.com/mamadfrhi/Germany-Corona-Light/archive/main.zip) or Clone the project:
```bash
$ git clone https://github.com/mamadfrhi/Germany-Corona-Light.git
```

2. Install dependencies using CocoaPods:
```bash
$ cd .../project_directory/Corona_Light
$ pod update
```

3. Open `Corona_Light.xcworkspace` and run the app:
```bash
Cmd + R
```

# Testing 🔁

### Simulate Location
1. Select the iOS simulator.
2. Navigate to `Feature > Location > Custom Location...`.
3. Enter the following:
    - Lat: `49.763138`
    - Long: `10.697828`

### Test Localization
Switch to German in the simulator:
```bash
Settings > General > Language & Region > Deutsch
```

# Code Style 🛠
This project demonstrates expertise in clean architecture and SOLID principles, emphasizing scalability and maintainability.

## Design Patterns ⚙️
- State
- Template
- Coordinator
- Singleton
- Adapter
- Delegate
- Decorator
- Facade

## Principles 💎
- Object-Oriented Programming (OOP)
- Protocol-Oriented Programming (POP)
- SOLID Principles
- Clean Code

## Frameworks Used ➕

### Native 📱
- **UIKit**
- **CoreLocation**
- **NotificationCenter**

### Pods 🧑‍💻
- **Networking**:
  - [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
  - [Moya](https://github.com/Moya/Moya)
- **UI**:
  - [JGProgressHUD](https://github.com/JonasGessner/JGProgressHUD)
  - [SwiftMessages](https://github.com/SwiftKickMobile/SwiftMessages)
  - [SnapKit](https://github.com/SnapKit/SnapKit)
- **Reactive Programming**:
  - [RxSwift](https://github.com/ReactiveX/RxSwift)
  - [RxCocoa](https://github.com/ReactiveX/RxSwift/tree/main/RxCocoa)

# Main Classes Diagrams

The core logic of the application is illustrated below:

<img src="https://user-images.githubusercontent.com/28094207/166139899-d74549cc-aa55-4a4d-9d26-bc76aebfb09d.jpeg" width="500" height="300"/>

![alt text](system-architecture-uml.png)

# Screenshots 📱

### English 🇬🇧
<p float="left">
<img src="https://user-images.githubusercontent.com/28094207/166139802-4d89bf03-7289-4f65-8fe0-489fe5cbd59c.png" width="200" />
<img src="https://user-images.githubusercontent.com/28094207/166139852-b99b3742-0c01-428f-8502-0e0941d4bbee.png" width="200" />
</p>

### German 🇩🇪
<p float="left">
<img src="https://user-images.githubusercontent.com/28094207/166139810-be314eb3-a92c-467f-b13e-9066f4382d47.png" width="200" />
<img src="https://user-images.githubusercontent.com/28094207/166139996-e6a9653e-6cf9-4ebb-b155-50d92351e96e.png" width="200" />
</p>

# Video 🎥

Watch the app in action:
[![Watch Video](https://img.youtube.com/vi/abc123/default.jpg)](https://user-images.githubusercontent.com/28094207/166139678-5fcd311a-adcc-40da-85b1-4b1c72e0c05c.mp4)

# API Documents 📄

[Click here to see API docs](https://npgeo-corona-npgeo-de.hub.arcgis.com/datasets/917fc37a709542548cc3be077a786c17_0)

# Extensibility 🔁🇩🇪

To use this app for other German states:

1. Open `.../Resources/Info.plist`.
2. Locate `stateName = Bayern;`.
3. Replace `Bayern` with the desired state's name (in German).

Example:
- ❌ English: `Bavaria`
- ✅ German: `Bayern`

# Contribution 💖
Contributions are welcome! Please feel free to discuss ideas or submit pull requests.

### Resources
You can download the app design in Adobe XD [here](https://github.com/mamadfrhi/Germany-Corona-Light/raw/main/Corona%20Light/Resources/Corona%20Status%20Design.xd).
