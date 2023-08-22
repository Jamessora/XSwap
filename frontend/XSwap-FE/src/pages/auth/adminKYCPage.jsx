import { fetchPendingKYC, approveKYC, rejectKYC } from '../../services/kycAdminService.jsx';
import React, { useState, useEffect } from 'react';

const AdminKYC = () => {
  const [pendingKYC, setPendingKYC] = useState([]);

  useEffect(() => {
    fetchPendingKYC()
      .then(data => {
        setPendingKYC(data);
      })
      .catch(error => {
        console.error('An error occurred:', error.message);
        // Handle the error, e.g., update the state to show an error message
      });
  }, []);

  const handleApprove = (userId) => {
    approveKYC(userId).then(() => {
      // Reload the pending KYC data or update the state
      fetchPendingKYC().then(data => setPendingKYC(data));
    });
  };

  const handleReject = (userId) => {
    rejectKYC(userId).then(() => {
      // Reload the pending KYC data or update the state
      fetchPendingKYC().then(data => setPendingKYC(data));
    });
  };

  return (
    <div>
      <h1>Pending KYC Requests</h1>
      {pendingKYC.map((user) => (
      <div key={user.id}>
        <p>Name: {user.fullName}</p>
        <p>Birthday: {user.birthday}</p>
        <p>Address: {user.address}</p>
        <p>ID Type: {user.idType}</p>
        <p>ID Number: {user.idNumber}</p>
        <button onClick={() => handleApprove(user.id)}>Approve</button>
        <button onClick={() => handleReject(user.id)}>Reject</button>
      </div>
    ))}
    </div>
  );
};

export default AdminKYC;
