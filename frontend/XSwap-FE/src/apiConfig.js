let apiBaseURL;

if (typeof window !== 'undefined') { // you're in the browser
    apiBaseURL = window.location.hostname === "localhost" ? 'http://localhost:3000' : 'https://xswap.onrender.com';
} else {
    // you're in Node.js
    apiBaseURL = 'http://localhost:3000'; // or any other way you want to get this value in a Node.js context
}

export default apiBaseURL;
