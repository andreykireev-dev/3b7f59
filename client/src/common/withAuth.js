import React, { useEffect, useState } from "react";
import { Redirect } from "react-router";
import routes from "constants/routes";
import { useAuth } from "../hooks/useAuth";

const withAuth = (Component, shouldRedirectToLogin = true) => {
  const HighOrderComponent = (props) => {
    const [loading, setIsLoading] = useState(true);
    const { user, validateAuthToken, logout } = useAuth();

    useEffect(() => {
      (async () => {
        if (!user) {
          await validateAuthToken();
        }
        setIsLoading(false);
      })();
      // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []);

    if (loading) return <></>;

    if (user || !shouldRedirectToLogin) {
      return (
        <Component
          {...props}
          isAuthenticated={user ? true : false}
          user={user}
          logout={logout}
          validateAuthToken={validateAuthToken}
        />
      );
    } else {
      return <Redirect to={routes.login} />;
    }
  };

  return HighOrderComponent;
};

export default withAuth;
