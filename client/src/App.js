import React from "react";
import MainLayout from "./pages/mainlayout/MainLayout";
import { Route, Switch, Redirect } from "react-router-dom";
import Login from "./pages/login/Login";
import Signup from "./pages/signup/Signup";
import routes from "constants/routes";
import Prospects from "pages/prospects/Prospects";
import Templates from "pages/templates/Templates";
import Reporting from "pages/reporting/Reporting";
import Campaigns from "pages/campaigns/Campaigns";

import axios from "axios";
import { useAuth } from "./hooks/useAuth";

axios.interceptors.request.use(async (req) => {
  const savedToken = await localStorage.getItem("token");
  if (savedToken) {
    req.headers.authorization = `Bearer ${savedToken}`;
  }
  return req;
});

function App() {
  const { user } = useAuth();
  return (
    <MainLayout>
      <Switch>
        <Route path={routes.campaigns} component={Campaigns}></Route>
        <Route path={routes.prospects} component={Prospects}></Route>
        <Route path={routes.templates} component={Templates}></Route>
        <Route path={routes.reporting} component={Reporting}></Route>
        <Route path={routes.signup} component={Signup}></Route>
        <Route
          path={routes.login}
          render={(props) =>
            user ? <Redirect to={routes.campaigns} /> : <Login {...props} />
          }
        />
        <Route
          path={routes.home}
          render={(props) =>
            user ? <Redirect to={routes.campaigns} /> : <Signup {...props} />
          }
        />
      </Switch>
    </MainLayout>
  );
}

export default App;
