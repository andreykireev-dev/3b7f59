import React, { useState } from "react";
import { Link as RouterLink, useHistory } from "react-router-dom";
import { Typography, Link } from "@material-ui/core";
import PaperForm from "common/PaperForm";
import { useAuth } from "hooks/useAuth";
import routes from "constants/routes";

const Login = () => {
  const { login } = useAuth();
  const history = useHistory();

  const [email, setEmail] = useState(null);
  const [password, setPassword] = useState(null);
  const [error, setError] = useState(null);

  const handleLogin = async () => {
    const loginError = await login(email, password);
    if (!loginError) history.push(routes.campaigns);
    setError(loginError);
  };

  return (
    <>
      <PaperForm
        fields={[
          {
            value: email,
            onChange: setEmail,
            label: "Email",
            type: "email",
            size: "medium",
          },
          {
            value: password,
            onChange: setPassword,
            label: "Password",
            type: "password",
            size: "medium",
          },
        ]}
        title="Login"
        onSubmit={handleLogin}
        submitButtonName="Login"
        error={error}
        disableSubmit={!(email && password)}
        footer={
          <Typography variant="body2">
            Don't have an account?{" "}
            <Link href="#" component={RouterLink} to="/signup">
              Sign up
            </Link>
          </Typography>
        }
      />
    </>
  );
};

export default Login;
