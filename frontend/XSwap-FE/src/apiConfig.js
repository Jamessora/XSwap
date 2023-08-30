// apiConfig.js
let apiBaseURL;

if (typeof window !== 'undefined') { // you're in the browser
    apiBaseURL = window.location.hostname === "localhost" ? 'http://localhost:3000' : 'https://xswap.onrender.com';
} else {
    // you're in Node.js
    apiBaseURL = process.env.REACT_APP_API_BASE_URL || 'http://localhost:3000';
}

export default apiBaseURL;
