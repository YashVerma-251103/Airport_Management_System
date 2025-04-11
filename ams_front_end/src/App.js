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


// import React, { useEffect, useState } from 'react';
// import axios from 'axios';

// function App() {
//   const [users, setUsers] = useState([]);

//   useEffect(() => {
//     // Replace with your actual API endpoint
//     axios.get('http://127.0.0.1:5000')
//       .then(response => {
//         setUsers(response.data);
//       })
//       .catch(error => {
//         console.error('Error fetching data: ', error);
//       });
//   }, []);

//   return (
//     <div>
//       <h1>User List</h1>
//       {users.length === 0 ? (
//         <p>No users found.</p>
//       ) : (
//         <ul>
//           {users.map(user => (
//             <li key={user.id}>
//               {user.name} - {user.email}
//             </li>
//           ))}
//         </ul>
//       )}
//     </div>
//   );
// }

// export default App;

