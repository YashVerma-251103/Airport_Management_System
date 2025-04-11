import React, { useState } from "react";
import "./LoginSignUp.css"; 

const LoginSignUp = () => {
  const [activeTab, setActiveTab] = useState("login");
  const [loginData, setLoginData] = useState({
    loginId: "",
    password: "",
  });
  const [signupData, setSignupData] = useState({
    name: "",
    contactNumber: "",
    role: "user",
    password: "",
    confirmPassword: "",
  });
  const [generatedLoginId, setGeneratedLoginId] = useState("");

  const handleLoginChange = (e) => {
    const { name, value } = e.target;
    setLoginData({
      ...loginData,
      [name]: value,
    });
  };

  const handleSignupChange = (e) => {
    const { name, value } = e.target;
    setSignupData({
      ...signupData,
      [name]: value,
    });
  };

  const handleLoginSubmit = (e) => {
    e.preventDefault();
    console.log("Login submitted:", loginData);
    // Add your login logic here
  };

  const handleSignupSubmit = (e) => {
    e.preventDefault();
    if (signupData.password !== signupData.confirmPassword) {
      alert("Passwords don't match!");
      return;
    }
    
    const loginId = `${signupData.contactNumber}_${signupData.role}`;
    setGeneratedLoginId(loginId);
    
    console.log("Signup submitted:", {
      ...signupData,
      loginId: loginId,
    });
    // Add your signup logic here
  };

  return (
    <div className="login-signup-container">
      <div className="tabs">
        <button
          className={`tab ${activeTab === "login" ? "active" : ""}`}
          onClick={() => setActiveTab("login")}
        >
          Login
        </button>
        <button
          className={`tab ${activeTab === "signup" ? "active" : ""}`}
          onClick={() => setActiveTab("signup")}
        >
          Sign Up
        </button>
      </div>

      {activeTab === "login" ? (
        <div className="login-form">
          <h2>Login</h2>
          <form onSubmit={handleLoginSubmit}>
            <div className="form-group">
              <label htmlFor="loginId">Login ID</label>
              <input
                type="text"
                id="loginId"
                name="loginId"
                value={loginData.loginId}
                onChange={handleLoginChange}
                required
              />
            </div>
            <div className="form-group">
              <label htmlFor="password">Password</label>
              <input
                type="password"
                id="password"
                name="password"
                value={loginData.password}
                onChange={handleLoginChange}
                required
              />
            </div>
            <button type="submit" className="submit-btn">
              Login
            </button>
          </form>
        </div>
      ) : (
        <div className="signup-form">
          <h2>Sign Up</h2>
          <form onSubmit={handleSignupSubmit}>
            <div className="form-group">
              <label htmlFor="name">Full Name</label>
              <input
                type="text"
                id="name"
                name="name"
                value={signupData.name}
                onChange={handleSignupChange}
                required
              />
            </div>
            <div className="form-group">
              <label htmlFor="contactNumber">Contact Number</label>
              <input
                type="tel"
                id="contactNumber"
                name="contactNumber"
                value={signupData.contactNumber}
                onChange={handleSignupChange}
                required
              />
            </div>
            <div className="form-group">
              <label htmlFor="role">Role</label>
              <select
                id="role"
                name="role"
                value={signupData.role}
                onChange={handleSignupChange}
                required
              >
                <option value="user">User</option>
                <option value="admin">Admin</option>
                <option value="manager">Manager</option>
              </select>
            </div>
            <div className="form-group">
              <label htmlFor="password">Create Password</label>
              <input
                type="password"
                id="password"
                name="password"
                value={signupData.password}
                onChange={handleSignupChange}
                required
              />
            </div>
            <div className="form-group">
              <label htmlFor="confirmPassword">Re-enter Password</label>
              <input
                type="password"
                id="confirmPassword"
                name="confirmPassword"
                value={signupData.confirmPassword}
                onChange={handleSignupChange}
                required
              />
            </div>
            <button type="submit" className="submit-btn">
              Sign Up
            </button>
          </form>
          
          {generatedLoginId && (
            <div className="generated-login-id">
              <p>Your Login ID: <strong>{generatedLoginId}</strong></p>
              <p>Please save this for future logins.</p>
            </div>
          )}
        </div>
      )}
    </div>
  );
};

export default LoginSignUp;