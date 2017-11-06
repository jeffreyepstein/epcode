/** This is the main React App page from my API demo. The whole thing is too fat to fit onto Github but I can dropbox it if somebody really wants to see the whole thing. 
-Jeff Epstein, November 2017

*/


import React, { Component } from 'react';
import './App.css';

class App extends Component {
	
	constructor(props) {
		super(props);
		this.state  = {
			fakedata:{}
		}
	}

  componentDidMount() {
	  
	fetch('/fakedata').then(res => {
	  if(res.status === 200) return res.json();
	  else return { error: 'ALERT: There was an error with response' }
	}).then(fakedata => {
	  if(fakedata.error) {  
		console.log(fakedata.error)}
		else {this.setState({fakedata})}
		});
	}

  render() {
    return (
      <div className="App">
	  <div className="App-header">
       <div className="App-intro">Jeff Epstein API Demo<br />with Express and React</div>
	  </div>
	  <div className="label">The following message is a live response from "JSON Placeholder"</div>
		<div className="mainPanel">
			<b>ID:</b> {this.state.fakedata.id} <br /><br />
			<b>User Number:</b> {this.state.fakedata.userId}  <br /><br />
			<b>Title:</b> {this.state.fakedata.title}  <br /><br />
			<b>Body:</b> {this.state.fakedata.body}  <br /><br />
		</div>
	 </div>	
	);        
  }
}


export default App;
