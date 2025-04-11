import React from "react";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";

// import logo from './logo.svg';
import './App.css';
import LoginSignUp from "./components/LoginSignUp";
import AdminHome from "./components/AdminHome";

function App() {
  return (
    <Router>
      <Routes>
      <Route path="/" element={<LoginSignUp />} />
        <Route path="/login_signup" element={<LoginSignUp />} />
        <Route path="/AdminHome" element={<AdminHome />} />
      </Routes>
    </Router>
  );
}

export default App;
