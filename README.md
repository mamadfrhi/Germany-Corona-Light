# Germany Corona Light 🇩🇪🚦🦠

It shows **you the current *status* of corona** and **related limitations** in your current location within a charming traffic light!

Currently, it is designed to use in Germany, Bavaria.🇩🇪

## Installation ✅

[Download the project](https://github.com/mamadfrhi/Germany-Corona-Light) first!

 Install packages
```
cd .../project directory/Corona Light
pod update
```
Open ```Corona Light.xcworkspace```
Press ```Cmd + R``` and see how it works
#### Simulate Location (Macos BigSur)
Select simluator
```Feature > Location > Custom Location... > Set following...```
Lat: ```49.763138```
Long: ```10.697828```
It refers to **Erlangen-Höchstadt**

#### Test Localization
In order to test localization in Deutsch do the following in simulator...
```Settings > General > Language & Region > Deutsch```


## Code style 🛠
Used **MVVM** architecture by the use of **RX**
This app completely **localized for use in Germany.**

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

**Principles** 💎
- OOP
- SOLID
- POP
- Clean Code

**Main Classes Diagrams** (Heart of the app)
![Semantic description of image](https://s17.picofile.com/file/8417382568/Corona_Status.jpeg "Diagrams")

# Screenshots 📱
#### English 🇬🇧
![English Page 1](https://s16.picofile.com/file/8417389392/1.png)
![English Page 2](https://s17.picofile.com/file/8417389476/2.png)
#### Germany 🇩🇪
![German Page 1](https://s16.picofile.com/file/8417389768/1.png)
![German Page 2](https://s16.picofile.com/file/8417389934/2.png)

# Video

# API Reference
[Click here to see API docs](https://npgeo-corona-npgeo-de.hub.arcgis.com/datasets/917fc37a709542548cc3be077a786c17_0)

# How to use for other states in Germany? 🔁🇩🇪
This app is currently designed for use at ***Bavaria.***
**If you want to use it in other states of Germany do the following.**

Open ```.../Resources/Lozalizable.strings (English)```
find ```"stateName" = "Bavaria";```
Replace ```Bavaria``` with name of your desired state.

Do it again for ```Lozalizable.strings (German)```
🚧**Pay attention:** In this file you must replace it with a local name.
For example:
(English) = Bavaria
(German) = Bayern




