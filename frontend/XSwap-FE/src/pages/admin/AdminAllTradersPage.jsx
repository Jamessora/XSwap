import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';


const AdminAllTradersPage = () => {
  const [traders, setTraders] = useState([]);

  useEffect(() => {
    fetch('http://localhost:3000/admin/allTraders')
      .then(response => response.json())
      .then(data => setTraders(data));
  }, []);

  return (
    <div>
      <h1>All Traders</h1>
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Email</th>
            <th>Balance</th>
          
          </tr>
        </thead>
        <tbody>
          {traders.map((trader, index) => (
            <tr key={index}>
              <td>{trader.id}</td>
              <td><Link to={`/admin/editTrader/${trader.id}`}>{trader.email}</Link></td>
              <td>{trader.balance}</td>
              
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default AdminAllTradersPage;
