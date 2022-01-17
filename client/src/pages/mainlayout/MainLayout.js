import React from "react";
import { CssBaseline } from "@material-ui/core";
import Navbar from "pages/mainlayout/NavBar";

const MainLayout = ({ children }) => {
  return (
    <>
      <CssBaseline />
      <Navbar />
      {children}
    </>
  );
};

export default MainLayout;
