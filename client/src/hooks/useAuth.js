import axios from "axios";
import React, { useState, useContext, createContext } from "react";

const authContext = createContext();

export default function ProvideAuth({ children }) {
  const auth = useProvideAuth();
  return <authContext.Provider value={auth}>{children}</authContext.Provider>;
}

export const useAuth = () => {
  return useContext(authContext);
};

function useProvideAuth() {
  const [user, setUser] = useState(null);

  const login = async (email, password) => {
    try {
      const resp = await axios.post("/api/login", { email, password });
      if (resp.data.error) return resp.data.error;
      if (resp.data.token) {
        await localStorage.setItem("token", resp.data.token);
      }
      validateAuthToken();
    } catch (error) {
      console.error("Error logging in", error);
    }
  };

  const signup = async (email, password) => {
    try {
      const resp = await axios.post("/api/users", { email, password });
      if (resp.data.error) return resp.data.error;
      if (resp.data.user && resp.data.token) {
        setUser(resp.data.user);
        await localStorage.setItem("token", resp.data.token);
        return null;
      }
    } catch (error) {
      console.error(error);
      return error;
    }
  };

  const logout = async () => {
    await localStorage.removeItem("token");
    setUser(null);
  };

  const validateAuthToken = async () => {
    try {
      const resp = await axios.get("/api/user");
      if (resp.status === 401) {
        await logout();
      }
      const userData = resp.data;
      if (!user || user.email !== userData.email) {
        setUser(userData);
      }
    } catch (error) {
      console.error("error validating token");
    }
  };

  return {
    user,
    login,
    signup,
    logout,
    validateAuthToken,
  };
}
