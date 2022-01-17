import React, { useState } from "react";
import { makeStyles, Button, Avatar, MenuItem, Menu } from "@material-ui/core";
import { ArrowDropDown } from "@material-ui/icons";
import profilepic from "./profilepic.png";

//CSS styles
const useStyles = makeStyles({
  container: {
    display: "flex",
  },
  avatar: {
    width: "3rem",
    height: "3rem",
    marginRight: "1rem",
  },
  button: {
    "&:hover": {
      backgroundColor: "transparent",
    },
  },
  icon: {
    color: "#A9A9A9",
  },
  menu: {
    bottom: "10rem",
  },
});

const Profile = ({ user, logout }) => {
  const [menuAnchorElement, setMenuAnchorElement] = useState(null);
  const { container, avatar, button, icon, menu } = useStyles();

  return (
    <div className={container}>
      <Avatar src={user.image || profilepic} className={avatar} />
      <Button
        className={button}
        color="inherit"
        disableRipple
        onClick={(e) => setMenuAnchorElement(e.currentTarget)}
        endIcon={<ArrowDropDown className={icon} />}
      >
        {`${user.email}`}
      </Button>

      <Menu
        className={menu}
        anchorOrigin={{
          vertical: "bottom",
          horizontal: "center",
        }}
        getContentAnchorEl={null}
        elevation={3}
        anchorEl={menuAnchorElement}
        keepMounted
        open={Boolean(menuAnchorElement)}
        onClose={() => setMenuAnchorElement(null)}
      >
        <MenuItem>Edit Profile</MenuItem>
        <MenuItem onClick={logout}>Logout</MenuItem>
      </Menu>
    </div>
  );
};

export default Profile;
