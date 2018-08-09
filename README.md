
# react-native-jivochat

## Getting started

`$ yarn add react-native-jivochat`
                  or
`$ npm install react-native-jivochat --save`

### Mostly automatic installation

`$ react-native link react-native-jivochat`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-jivochat` and add `RNJivochat.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNJivochat.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainApplication.java`
  - Add `import com.jivochat.RNJivochatPackage;` to the imports at the top of the file
  - Add `new RNJivochatPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-jivochat'
  	project(':react-native-jivochat').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-jivochat/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-jivochat')
  	```

## For Smooth implementation kindly follow jivoChatExample folder

## SDK Configuration

The widget_id and site_id can be found by going to the admin panel and then into the settings section of your Mobile app SDK. If you didn't create one yet, go "Add communication channels -> Mobile app SDK" and after asigning a new name, the widget_id and site_id will be displayed.

The configuration settings for SDK can be located in the index.html file:

### Android

Loaction-> react-native-jivochat/android/src/main/assets/html/index_en.html

  ```
  jivo_config = {
        //widget_id - REPLACE with YOUR own!
        "widget_id": "xxxx",

        //site_id - REPLACE with YOUR own!
        "site_id": xxxxx,

        //the color of the submit button
        "plane_color":"red",

        //color of agent messages
        "agentMessage_bg_color":'green',

        //text color of the message agent
        "agentMessage_txt_color":'blue',

        //color of the client message
        "clientMessage_bg_color":'yellow',

        //text color of the client message
        "clientMessage_txt_color":'black',

        //active the invitation, if not use, leave blank
        "active_message": "Hello! Can I help you?",

        //link that will glow in the operator program
        "app_link":'Widget_Mobile',

        //The text in the input field
        "placeholder": "Enter message',

        //use secure connection
        "secure": true,

        //use for replace onEvent function
        //"event_func": function(event) {console.log(event)}
    }
  ```
## Usage
```
import RNJivochat from 'react-native-jivochat';

Call this function:
let userName: 'Tester'
let userEmail: 'test@gmail.com'
  RNJivochat.openJivoChat(userName, userEmail)
```
