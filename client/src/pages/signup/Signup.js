import React, { useState } from "react";
import { Link as RouterLink, useHistory } from "react-router-dom";
import { Typography, Link } from "@material-ui/core";
import PaperForm from "common/PaperForm";
import withAuth from "common/withAuth";
import { useAuth } from "hooks/useAuth";
import routes from "constants/routes";

const Signup = () => {
  const { signup } = useAuth();
  const history = useHistory();

  const [email, setEmail] = useState(null);
  const [password, setPassword] = useState(null);
  const [confirmPassword, setConfirmPassword] = useState(null);
  const [error, setError] = useState(null);

  const handleSignup = async () => {
    const signupError = await signup(email, password);
    if (signupError) {
      setError(signupError.message);
    } else {
      history.push(routes.campaigns);
    }
  };

  const shouldDisableSubmit = () => {
    return (
      !(email && password && confirmPassword) && password !== confirmPassword
    );
  };

  return (
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
        {
          value: confirmPassword,
          onChange: setConfirmPassword,
          label: "Confirm Password",
          type: "password",
          size: "medium",
        },
      ]}
      title="Sign up"
      onSubmit={handleSignup}
      submitButtonName="Sign up"
      disableSubmit={shouldDisableSubmit()}
      error={error}
      footer={
        <Typography variant="body2">
          Already have an account?{" "}
          <Link href="#" component={RouterLink} to={routes.login}>
            Login
          </Link>
        </Typography>
      }
    />
  );
};

export default withAuth(Signup, false);
