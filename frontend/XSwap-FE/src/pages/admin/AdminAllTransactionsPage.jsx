import React, { useState, useEffect } from 'react';

const AdminAllTransactionsPage = () => {
  const [transactions, setTransactions] = useState([]);

  useEffect(() => {
    fetch('http://localhost:3000/admin/allTransactions')
      .then(response => response.json())
      .then(data => setTransactions(data.transactions));
  }, []);

  return (
    <div>
      <h1>All Transactions</h1>
      <table>
        <thead>
          <tr>
            <th>User</th>
            <th>Transaction Type</th>
            <th>Transaction Date</th>
            <th>Amount</th>
            <th>Price</th>
            <th>USD Value</th>
          </tr>
        </thead>
        <tbody>
        {Array.isArray(transactions) ? transactions.map((t, index) => (
              <tr key={index}>
              <td>{t.user}</td>
              <td>{t.transaction_type}</td>
              <td>{new Date(t.transaction_date).toLocaleDateString()}</td>
              <td>{t.transaction_amount}</td>
              <td>{t.transaction_price}</td>
              <td>{t.usd_value}</td>
            </tr>
           )) : (
            <tr>
              <td colSpan="6">No transactions available</td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
};

export default AdminAllTransactionsPage;
