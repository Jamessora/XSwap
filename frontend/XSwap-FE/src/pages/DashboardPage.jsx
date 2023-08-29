import React,{ useState, useEffect }  from 'react';
import {Link} from 'react-router-dom'
import { fetchKYCStatus } from '../services/kycService.jsx';



const DashboardPage = () => {
  const [kycStatus, setKYCStatus] = useState(null);

  useEffect(() => {
    fetchKYCStatus()
      .then(status => setKYCStatus(status))
      .catch(error => console.error('Error fetching KYC status:', error));
  }, []);

  return (
    <div>
      <h1>Welcome to the Dashboard</h1>
      <p>This is your dashboard page. You can add any content or features you need here.</p>
      <Link to="/kyc">Go to KYC Page</Link>
      {/* Add other dashboard components or content as needed */}
      <p>KYC Status: {kycStatus ? kycStatus : 'Please verify your account, KYC is required before trading...'}</p>
      {kycStatus == 'approved' && <Link to="/trade">Go to Trading Page</Link>}
    </div>
    
    
  );
};




export default DashboardPage;