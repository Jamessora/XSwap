import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import LoginPage from './pages/auth/LoginPage.jsx';
import SignupPage from './pages/auth/SignupPage.jsx';
import KYCPage from './pages/auth/KYCPage.jsx';
import DashboardPage from './pages/DashboardPage.jsx';
import AdminKYC from './pages/auth/adminKYCPage.jsx';
import './App.css'




function App() {
  return (
    <Router>
      <Routes>
        <Route path="/login" element={<LoginPage/>} />
        <Route path="/signup" element={<SignupPage/>} />
        <Route path="/kyc" element={<KYCPage/>} />
        <Route path="/dashboard" element={<DashboardPage/>} />
        <Route path="admin/kyc" element={<AdminKYC/>} />
        {/* will add more */}
      </Routes>
    </Router>
  );
}
export default App
