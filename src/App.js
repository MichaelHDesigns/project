import React, { useState } from 'react';
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';
import Create_Account from './components/Create_Account';
import Dashboard from './components/Dashboard';
import Edit_Profile from './components/Edit_Profile';
import LandingPage from './components/LandingPage';
import Login from './components/Login';
import Profile from './components/Profile';
import CreateNFTPage from './components/CreateNFTPage';
import Marketplace from './components/Marketplace';
import './css/App.css';
import './css/index.css';


function App() {
  const [loggedIn, setLoggedIn] = useState(false);

  return (
    <Router>
      <div className="App">
        <Switch>
          <Route exact path="/" component={LandingPage} />
          <Route
            exact
            path="/login"
            render={() => <Login setLoggedIn={setLoggedIn} />}
          />
          <Route exact path="/dashboard" component={Dashboard} />
          <Route exact path="/create_account" component={Create_Account} />
          <Route exact path="/profile">
            <Profile setLoggedIn={setLoggedIn}>
              <Edit_Profile setLoggedIn={setLoggedIn} />
            </Profile>
          </Route>
          <Route exact path="/create_nft" component={CreateNFTPage} />
          <Route exact path="/marketplace" component={Marketplace} />
        </Switch>
      </div>
    </Router>
  );
}

export default App;
