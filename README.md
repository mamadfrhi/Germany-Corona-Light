# Germany Corona Light 🇩🇪🚦🦠

![Banner](https://user-images.githubusercontent.com/28094207/166139760-7d46f069-5f5b-4685-91b7-1caa113b5aed.jpeg)


## This iOS app shows you the status of Corona and related limitations in your current location within a charming traffic light!



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

- To test the app in 🇩🇪 do the following in the simulator...

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

<img src=https://user-images.githubusercontent.com/28094207/166139899-d74549cc-aa55-4a4d-9d26-bc76aebfb09d.jpeg widht="300"  height="200"/>

</br>

# Screenshots 📱

#### English 🇬🇧

<p float="left">
<img src=https://user-images.githubusercontent.com/28094207/166139802-4d89bf03-7289-4f65-8fe0-489fe5cbd59c.png widht="100"  height="200"/>  <img src=https://user-images.githubusercontent.com/28094207/166139852-b99b3742-0c01-428f-8502-0e0941d4bbee.png widht="100"  height="200"/>
</p>

#### German 🇩🇪

<p float="left">
<img src=https://user-images.githubusercontent.com/28094207/166139810-be314eb3-a92c-467f-b13e-9066f4382d47.png widht="100"  height="200" />  <img src=https://user-images.githubusercontent.com/28094207/166139996-e6a9653e-6cf9-4ebb-b155-50d92351e96e.png widht="100"  height="200" />
</p>


# Video 🎥



https://user-images.githubusercontent.com/28094207/166139678-5fcd311a-adcc-40da-85b1-4b1c72e0c05c.mp4




# API Documents 📄

[Click here to see API docs](https://npgeo-corona-npgeo-de.hub.arcgis.com/datasets/917fc37a709542548cc3be077a786c17_0)

</br>

# How to use for other states in Germany? 🔁🇩🇪

This app is currently designed for use at **_Bavaria._**

**If you want to use it in other states of Germany do the following.**

1. Open `.../Resources/Info.plist`

2. find `stateName = Bayern;`

3. Replace `Bayern` with the name of your desired state.

---

🚧**Pay attention:** In this file you must replace it with a local name (German name).

For example:

❌ (English) = ~~Bavaria~~

✅  (German) = Bayern

---
#### You can download app desing in AdobeXD [here!](https://github.com/mamadfrhi/Germany-Corona-Light/raw/main/Corona%20Light/Resources/Corona%20Status%20Design.xd)
