import { useAuthenticatedRequest } from './useAuthenticatedRequest';

export const fetchPrice = async (pair) => {
  const url = `https://api.coingecko.com/api/v3/simple/price?ids=${pair}&vs_currencies=usd&${Math.random()}`;
  const response = await fetch(url);
  const data = await response.json();
  if (!data[pair] || !data[pair].usd) {
    throw new Error(`Price information not available for ${pair}`);
  }
  return data[pair].usd;
};

export const buyToken = (makeRequest, selectedToken, tokenAmount, totalUsdValue) => {
  return makeRequest('http://localhost:3000/api/trades/buy', 'POST', {
    token: selectedToken,
    amount: tokenAmount,
    total_usd_value: totalUsdValue
  });
};

export const sellToken = (makeRequest, selectedToken, tokenAmount, totalUsdValue) => {
  return makeRequest('http://localhost:3000/api/trades/sell', 'POST', {
    token: selectedToken,
    amount: tokenAmount,
    total_usd_value: totalUsdValue
  });
};
