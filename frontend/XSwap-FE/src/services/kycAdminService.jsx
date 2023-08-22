// services/kycAdminService.jsx

export const fetchPendingKYC = async () => {
  const response = await fetch('http://localhost:3000/admin/kyc');

  if (!response.ok) {
    throw new Error(`Error fetching KYC data: ${response.statusText}`);
  }

  const contentType = response.headers.get("content-type");
  if (!contentType || !contentType.includes("application/json")) {
    throw new Error("Received non-JSON response");
  }

  const data = await response.json();
  return data;
};

  
  export const approveKYC = async (userId) => {
    const response = await fetch(`http://localhost:3000/admin/kyc/${userId}/approve`, {
      method: 'POST',
    });
    const data = await response.json();
    return data;
  };
  
  export const rejectKYC = async (userId) => {
    const response = await fetch(`http://localhost:3000/admin/kyc/${userId}/reject`, {
      method: 'POST',
    });
    const data = await response.json();
    return data;
  };
  