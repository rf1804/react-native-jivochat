
# react-native-jivochat

## Getting started

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


## Usage
```javascript
import RNJivochat from 'react-native-jivochat';

// TODO: What to do with the module?
RNJivochat;
```
  