import React, { useState, useEffect } from 'react';
import { withKYCProtection } from '../hoc/withKYCProtection.jsx'; 
import { useAuthenticatedRequest } from '../../services/useAuthenticatedRequest.jsx';

const TransactionPage = () => {
  const [transactions, setTransactions] = useState([]);
  const { makeRequest } = useAuthenticatedRequest();
  const fetchUpdatedTransactions = async () => {
    try {
      const data = await makeRequest('http://localhost:3000/transactions', 'GET');
      console.log("Received data:", data);
      if (Array.isArray(data)) {
        setTransactions(data);
      } else {
        console.error("Received data is not an array:", data);
      }
    } catch (error) {
      console.error('Error fetching transactions:', error);
    }
  };

  useEffect(() => {
    // Fetch transactions from the backend
    // Update the URL based on your API endpoint
    fetchUpdatedTransactions();
  }, []);

  return (
    <div>
      <h1>Your Transactions</h1>
      <table>
        <thead>
          <tr>
            <th>Transaction ID</th>
            <th>Type</th>
            <th>Token</th>
            <th>Amount</th>
            <th>Price</th>
          </tr>
        </thead>
        <tbody>
          {transactions.map((tx) => (
            <tr key={tx.id}>
            <td>{tx.id}</td>
            <td>{tx.transaction_type}</td>
            <td>{tx.token.name}</td>
            <td>{tx.transaction_amount}</td>
            <td>{tx.transaction_price} USDT</td>
          </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default withKYCProtection(TransactionPage);
