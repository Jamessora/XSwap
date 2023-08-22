import React, { useState } from 'react';
import { signupService } from '../../services/authService.jsx';

const SignupPage = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [passwordConfirmation, setPasswordConfirmation] = useState('');
  const [error, setError] = useState('');
  const [message, setMessage] = useState('');

  const handleSignup = async () => {
    if (password !== passwordConfirmation) {
      setError('Passwords do not match');
      return;
    }

    try {
      await signupService(email, password);
      setMessage('Signed up successfully. Please check your email for confirmation instructions.');
      // Redirect to login page or show success message
    } catch (err) {
      setError(err.message);
    }
  };
//


//
  return (
    <div>
      <h1>Sign Up</h1>
      <label>Email:</label>
      <input type="email" value={email} onChange={e => setEmail(e.target.value)} />
      <label>Password:</label>
      <input type="password" value={password} onChange={e => setPassword(e.target.value)} />
      <label>Confirm Password:</label>
      <input type="password" value={passwordConfirmation} onChange={e => setPasswordConfirmation(e.target.value)} />
      <button onClick={handleSignup}>Sign Up</button>
      {error && <p>{error}</p>}
      {message && <p>{message}</p>}
    </div>
  );
};

export default SignupPage;
