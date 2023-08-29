import React from 'react';
import { useNavigate } from 'react-router-dom';
import { fetchKYCStatus } from '../../services/kycService.jsx'; 

export const withKYCProtection = (WrappedComponent) => {
  return class extends React.Component {
    state = {
      kycStatus: null,
      loading: true,
    };

    componentDidMount() {
      fetchKYCStatus().then((status) => {
        this.setState({ kycStatus: status, loading: false });
      });
    }

    render() {
      const { kycStatus, loading } = this.state;

      if (loading) {
        return <div>Loading...</div>; // Show a loading indicator while fetching KYC status
      }
      if (kycStatus !== 'approved') {
        navigate('/kyc');
        return null
      }

      return <WrappedComponent {...this.props} />;
    }
  };
};
