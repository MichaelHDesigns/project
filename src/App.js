
import React, { useState } from 'react';
import { BrowserRouter as Router, Switch, Route, Link } from 'react-router-dom';
import Create_Account from './components/Create_Account';
import Dashboard from './components/Dashboard';
import EditProfile from './components/ProfileEditor';
import LandingPage from './components/LandingPage';
import Login from './components/Login';
import Profile from './components/Profile';
import CreateNFTPage from './components/CreateNFTPage';
import Marketplace from './components/Marketplace';
import './css/App.css';
import './css/index.css';

function App() {
  const [loggedIn, setLoggedIn] = useState(false);
  const [searchTerm, setSearchTerm] = useState("");

  const handleSearchChange = (event) => {
    setSearchTerm(event.target.value);
  }

  return (
    <Router>
      <div className="App">
        <nav className="navbar">
          <ul>
            <li>
              <Link to="/">Home</Link>
            </li>
            <li>
              <Link to="/marketplace">Marketplace</Link>
            </li>
            <li>
              <Link to="/create_nft">Create NFT</Link>
            </li>
            <li>
              <form>
                <input type="text" placeholder="Search" value={searchTerm} onChange={handleSearchChange} />
                <button type="submit">Search</button>
              </form>
            </li>
          </ul>
        </nav>
        <Switch>
          <Route exact path="/" component={LandingPage} />
          <Route exact path="/login" render={() => <Login setLoggedIn={setLoggedIn} />} />
          <Route exact path="/dashboard" component={Dashboard} />
          <Route exact path="/create_account" component={Create_Account} />
          <Route exact path="/profile">
            <Profile setLoggedIn={setLoggedIn}>
              <Route exact path="/profile/edit" component={EditProfile} />
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
