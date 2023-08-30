let apiBaseURL;

if (process.env.NODE_ENV === 'production') {
  apiBaseURL = 'https://xswap.onrender.com';
} else {
  apiBaseURL = 'http://localhost:3000';
}

export default apiBaseURL;