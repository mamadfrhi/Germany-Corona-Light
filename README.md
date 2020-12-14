# Germany Corona Light 🇩🇪🚦🦠

![Banner](https://s17.picofile.com/file/8417404042/banner.jpg)

<br/>

## This iOS app shows ***you the current status of corona*** and ***related limitations*** in your current location within a charming traffic light!

<br/>

## Currently, it is designed to use in Germany, Bavaria. 🇩🇪

<br/>
<br/>

# Installation ✅

1. [Download the project](https://github.com/mamadfrhi/Germany-Corona-Light/archive/main.zip) first!

2. Install packages (using terminal) 👇🏼

```bash
3. $ cd .../project directory/Corona Light

4. $ pod update
```

5. Open `Corona Light.xcworkspace`

6. Press `Cmd + R` and see how it works

<br/>

# Testing 🔁

### Simulate Location on iOS simulator (macOS BigSur)

1. Select simluator
2. Choose `Feature > Location > Custom Location... > Set following...`

- Lat: `49.763138`
- Long: `10.697828`
- It refers to **Erlangen-Höchstadt**

<br/>

### Test Localization 🇩🇪🇬🇧

- In order to test the app in 🇩🇪 do the following in simulator...

- `Settings > General > Language & Region > Deutsch`

<br/>

# Code style 🛠

Used **MVVM** architecture by the use of **RX**

This app completely **localized for use in Germany.**

<br/>

**Design patterns** ⚙️

- State
- Template
- Coordinator
- Singleton
- Adapter
- Delegate
- Decorator
- Facade
- ...

<br/>

**Principles** 💎

- OOP
- SOLID
- POP
- Clean Code

<br/>

### **Used Frameworks** ➕

#### **Natives** 👴🏼

- UIKit 🎭
- CoreLocation 📍
- NotificationCenter ⚠️

#### **Pods** 🧔🏻

##### **_Network_** 🌐

- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
- [Moya](https://github.com/SwiftyJSON/SwiftyJSON)

##### **_View_** 🎭

- [JGProgressHUD](https://github.com/JonasGessner/JGProgressHUD)
- [SwiftMessages](https://github.com/SwiftKickMobile/SwiftMessages)
- [SnapKit](https://github.com/SnapKit/SnapKit)

##### **_RX_** 🐟

- [RxSwift](https://github.com/ReactiveX/RxSwift)
- [RxCocoa](https://github.com/ReactiveX/RxSwift/tree/main/RxCocoa)

<br/>

# Main Classes Diagrams

Heart❤️ of the app

<br/>

<img src=https://s17.picofile.com/file/8417382568/Corona_Status.jpeg widht="300"  height="200"/>

</br>

# Screenshots 📱

#### English 🇬🇧

<img src=https://s17.picofile.com/file/8417399450/1.png widht="100"  height="200"/>  <img src=https://s16.picofile.com/file/8417399476/2.png widht="100"  height="200"/>

#### Germany 🇩🇪

<img src=https://s16.picofile.com/file/8417399634/1.png widht="100"  height="200" />  <img src=https://s16.picofile.com/file/8417399692/2.png) widht="100"  height="200" />

</br></br>

# Video 🎥

[Click here to see app in use](https://youtu.be/jXjny-TFchc)

</br>

# API Documents 📄

[Click here to see API docs](https://npgeo-corona-npgeo-de.hub.arcgis.com/datasets/917fc37a709542548cc3be077a786c17_0)

</br>

# How to use for other states in Germany? 🔁🇩🇪

This app is currently designed for use at **_Bavaria._**

**If you want to use it in other states of Germany do the following.**

1. Open `.../Resources/Info.plist`

2. find `stateName = Bayern;`

3. Replace `Bayern` with name of your desired state.

---

🚧**Pay attention:** In this file you must replace it with a local name (German name).

For example:

❌ (English) = ~~Bavaria~~

✅  (German) = Bayern

---
#### You can download desing of app in AdobeXD [here!](https://github.com/mamadfrhi/Germany-Corona-Light/raw/main/Corona%20Light/Resources/Corona%20Status%20Design.xd)