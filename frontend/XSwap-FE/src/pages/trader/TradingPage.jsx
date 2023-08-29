import React,{ useState, useEffect } from 'react';
import { withKYCProtection } from '../hoc/withKYCProtection.jsx'; // Update the path according to your project structure
import { buyToken, sellToken, fetchPrice } from '../../services/tradeService.jsx';
import { useAuthenticatedRequest } from '../../services/useAuthenticatedRequest.jsx';


// Use the buyToken and sellToken functions within this component


const TradingPage = (props) => {
    const { makeRequest } = useAuthenticatedRequest();
    const [balance, setBalance] = useState(0)
    const [tokenPrice, setTokenPrice] = useState(null);
    const [selectedToken, setSelectedToken] = useState('bitcoin');
  const [tokenAmount, setTokenAmount] = useState(1);
  const [usdValue, setUsdValue] = useState(0);
  const [availableTokens] = useState(['bitcoin', 'ethereum', 'binancecoin', 'matic-network', 'ripple']);
  
   
  const handleTokenAmountChange = (amount) => {
    setTokenAmount(amount);
    if (tokenPrice) {
      setUsdValue(amount * tokenPrice);
    }
  };

  const handleUsdValueChange = (value) => {
    setUsdValue(value);
    if (tokenPrice) {
      setTokenAmount(value / tokenPrice);
    }
  };

  const fetchTokenPrice = async () => {
    try {
      const price = await fetchPrice(selectedToken);
      setTokenPrice(parseFloat(price.toFixed(2))); // Format the price to 2 decimal places
    } catch (error) {
      console.error(error);
    }
  };

  const handleBuyToken = async () => {
    try {
      const result = await buyToken(makeRequest, selectedToken, tokenAmount, usdValue);
      // Handle the result here, e.g., update state or navigate to another page
      console.log('Buy successful:', result);
      // You can also update any state variables or navigate to another page here
      
      alert('Buy Successful')
      if (result && result.user && result.user.balance) {
        setBalance(result.user.balance);
      }
      
     } catch (error) {
      // Handle the error here
      console.error('Error buying token:', error);
      alert('Error buying token');
    }
  };

  const handleSellToken = async () => {
    try {
      const result = await sellToken(makeRequest, selectedToken, tokenAmount, usdValue);
      // Handle the result here, e.g., update state or navigate to another page
      console.log('Sell successful:', result);
      // You can also update any state variables or navigate to another page here
      alert('Sell successful');

      if (result && result.user && result.user.balance) {
        setBalance(result.user.balance);
      }
    
  
    } catch (error) {
      // Handle the error here
      console.error('Error selling token:', error);
      alert('Sell successful');
    }
  };

  

    useEffect(() => {
      
  
     fetchTokenPrice();
  
      // Set up an interval to fetch the BTC price every second
      const intervalId = setInterval(fetchTokenPrice, 15000);
  
      // Clean up the interval when the component is unmounted
      return () => clearInterval(intervalId);
     
     // initial fetch
    }, [selectedToken]);

  
    
  // Your trading page code here
  return (
    <div>
        <h1>Trading Pages</h1>
        <p>Current Price of {selectedToken}: {tokenPrice ? `${tokenPrice} USDT` : 'Loading...'}</p>
        <select onChange={(e) => setSelectedToken(e.target.value)} value={selectedToken}>
        {availableTokens.map((token) => (
          <option key={token} value={token}>
            {token}
          </option>
        ))}
      </select>
      <input type="number" value={tokenAmount} onChange={(e) => handleTokenAmountChange(e.target.value)} />
      <input type="number" value={usdValue} onChange={(e) => handleUsdValueChange(e.target.value)} />
      <button onClick={handleBuyToken}>Buy</button>
      <button onClick={handleSellToken}>Sell</button>
      test
    </div>
  );
};

export default withKYCProtection(TradingPage);
