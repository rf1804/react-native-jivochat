import React, { Component } from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View,
  TouchableOpacity
} from 'react-native';
import RNJivochat from 'react-native-jivochat';

export default class App extends Component<Props> {
  constructor(props) {
    super(props);
    this.state = {};
  }
  openJivoChat = ()=> {
    RNJivochat.openJivoChat()
  }
  render() {
    return (
      <View style={styles.container}>
        <TouchableOpacity style={{width: 200, height: 40, backgroundColor: 'red', borderRadius: 8, justifyContent: 'center'}} onPress={this.openJivoChat}>
          <Text style={{color: 'white', fontSize: 16, textAlign: 'center'}}>Start Jivo Chat</Text>
        </TouchableOpacity>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
