import React, { useState } from "react";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";
import Create_Account from "./components/Create_Account";
import Dashboard from "./components/Dashboard";
import Edit_Profile from "./components/Edit_Profile";
import LandingPage from "./components/LandingPage";
import Login from "./js/Login";
import Profile from "./components/Profile";
import "./src/css/App.css";
import "./src/css/index.css";

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
          <Route exact path="/profile" component={Profile} />
          <Route exact path="/edit_profile" component={Edit_Profile} />
        </Switch>
      </div>
    </Router>
  );
}

export default App;
