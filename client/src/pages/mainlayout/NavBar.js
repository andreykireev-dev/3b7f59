import React from "react";
import { AppBar, Grid, makeStyles } from "@material-ui/core";
import logo from "./logo.png";
import withAuth from "common/withAuth";
import NavLinks from "pages/mainlayout/NavLinks";
import Profile from "pages/mainlayout/Profile";
import { useAuth } from "../../hooks/useAuth";

//CSS styles
const useStyles = makeStyles((theme) => ({
  navbar: {
    display: "flex",
    flexDirection: "row",
    height: "6rem",
    alignItems: "center",
    padding: "0 2rem 0 2rem",
    borderBottom: "1px solid #E0E0E0",
    zIndex: theme.zIndex.drawer + 1,
  },
  navbarHeight: {
    height: "6rem",
  },
}));

const Navbar = ({ isAuthenticated }) => {
  const { navbar, navbarHeight } = useStyles();

  const { user, logout } = useAuth();

  return (
    <>
      <AppBar
        className={navbar}
        color="secondary"
        elevation={0}
        position="fixed"
      >
        <div>
          <img src={logo} width="130" alt="" />
        </div>
        {user && (
          <Grid
            container
            justifyContent="space-between"
            alignItems="center"
            wrap="nowrap"
          >
            <Grid item>
              <NavLinks />
            </Grid>
            <Grid item>
              <Profile user={user} logout={logout} />
            </Grid>
          </Grid>
        )}
      </AppBar>
      <div className={navbarHeight}></div>
    </>
  );
};

export default withAuth(Navbar, false);
