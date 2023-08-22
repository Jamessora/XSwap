import React from 'react';
import {Link} from 'react-router-dom'

const DashboardPage = () => {
  return (
    <div>
      <h1>Welcome to the Dashboard</h1>
      <p>This is your dashboard page. You can add any content or features you need here.</p>
      <Link to="/kyc">Go to KYC Page</Link>
      {/* Add other dashboard components or content as needed */}
    </div>

    
  );
};




export default DashboardPage;