import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';

const AdminEditTraderPage = () => {
  const { id } = useParams();
  const [trader, setTrader] = useState({});
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [balance, setBalance] = useState("");
  const [kycStatus, setKycStatus] = useState("");

  useEffect(() => {
    fetch(`http://localhost:3000/admin/trader/${id}`)
      .then(response => response.json())
      .then(data => {
        setTrader(data);
        setEmail(data.email);
        setBalance(data.balance);
        setKycStatus(data.kyc_status);
      });
  }, [id]);

  const handleUpdate = () => {
    fetch(`http://localhost:3000/admin/updateTrader/${id}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({user:{ email, password, balance, kyc_status: kycStatus }}),
      
    })
    
    .then(response => response.json())
    .then(data => {
      if (data.message) {
        alert("Trader updated successfully.");
      } else {
        alert("Failed to update trader.");
      }
    });
  };

  return (
    <div>
      <h1>Edit Trader</h1>
      <form>
        <label>Email</label>
        <input type="text" value={email} onChange={(e) => setEmail(e.target.value)} />
        
        <label>Password</label>
        <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} />

        <label>Balance</label>
        <input type="text" value={balance} onChange={(e) => setBalance(e.target.value)} />

        <label>KYC Status</label>
        <select value={kycStatus} onChange={(e) => setKycStatus(e.target.value)}>
          <option value="">Select Status</option>
          <option value="approved">Approved</option>
          <option value="rejected">Rejected</option>
          <option value="pending">Pending</option>
        </select>
        
        <button type="button" onClick={handleUpdate}>Update Trader</button>
      </form>
    </div>
  );
};

export default AdminEditTraderPage;
