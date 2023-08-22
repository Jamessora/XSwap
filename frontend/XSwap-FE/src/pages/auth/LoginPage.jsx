import React, { useState } from 'react';
import { loginService } from '../../services/authService.jsx';
import { useNavigate } from 'react-router-dom';

const LoginPage = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const navigate = useNavigate ();

  const handleLogin = async () => {
    try {
      await loginService(email, password);
      navigate('/dashboard');
      // Redirect to dashboard or other authenticated page
    } catch (err) {
      console.log('Error:', err.message);
      setError(err.message);
    }
  };

  return (
    <div>
      <h1>Login</h1>
      <label>Email:</label>
      <input type="email" value={email} onChange={e => setEmail(e.target.value)} />
      <label>Password:</label>
      <input type="password" value={password} onChange={e => setPassword(e.target.value)} />
      <button onClick={handleLogin}>Login</button>
      {error && <p>{error}</p>}
    </div>
  );
};

export default LoginPage;
