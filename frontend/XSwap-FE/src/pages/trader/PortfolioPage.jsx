import React, { useState, useEffect } from 'react';
import { withKYCProtection } from '../hoc/withKYCProtection.jsx'; 
import { useAuthenticatedRequest } from '../../services/useAuthenticatedRequest.jsx';

const PortfolioItems = () => {
  const [portfolioItems, setPortfolioItems] = useState([]);
  const { makeRequest } = useAuthenticatedRequest();

  const fetchUpdatedPortfolio = async () => {
    try {
      const data = await makeRequest('http://localhost:3000/portfolio_items', 'GET');
      console.log("Received data:", data);
      if (Array.isArray(data)) {  // <-- Check if the data is an array
        setPortfolioItems(data);
      } else {
        console.error("Received data is not an array:", data);
      }
    } catch (error) {
      console.error('Error fetching Portfolio:', error);
    }
  };

  useEffect(() => {
    // Fetch portfolio items from the backend
    fetchUpdatedPortfolio();
  }, []);

  return (
    <div>
      <h1>Your Portfolio</h1>
      <table>
        <thead>
          <tr>
            <th>Token</th>
            <th>Amount</th>
            <th>Price</th>
            <th>Total Value</th>
          </tr>
        </thead>
        <tbody>
        {portfolioItems.map((item) => (
          <tr key={item.id}>
            <td>{item.token.name}</td>
            <td>{item.amount}</td>
            <td>{item.token.price} USDT</td>
            <td>{item.amount * item.token.price} USDT</td>
          </tr>
        ))}
        </tbody>
      </table>
    </div>
  );
};

export default withKYCProtection(PortfolioItems);
