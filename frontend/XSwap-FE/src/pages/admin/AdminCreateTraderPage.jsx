import React, { useState } from "react";

const AdminCreateTraderPage = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [passwordConfirmation, setPasswordConfirmation] = useState("");

  const handleCreateTrader = async () => {
    const payload = {
      user: {
        email,
        password,
        password_confirmation: passwordConfirmation,
      },
    };

    try {
      const response = await fetch("http://localhost:3000/admin/createTrader", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(payload),
      });

      const data = await response.json();
      
      if (response.ok) {
        alert("Trader created successfully");
      } else {
        alert(`Failed to create trader: ${data.message}`);
      }

    } catch (error) {
      console.error("There was an error creating the trader", error);
    }
  };

  return (
    <div>
      <h1>Create Trader</h1>
      <form>
        <div>
          <label>Email</label>
          <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} />
        </div>
        <div>
          <label>Password</label>
          <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} />
        </div>
        <div>
          <label>Confirm Password</label>
          <input type="password" value={passwordConfirmation} onChange={(e) => setPasswordConfirmation(e.target.value)} />
        </div>
        <button type="button" onClick={handleCreateTrader}>Create Trader</button>
      </form>
    </div>
  );
};

export default AdminCreateTraderPage;
