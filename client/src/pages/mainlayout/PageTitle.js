import { Grid, makeStyles, Typography } from "@material-ui/core";

const useStyles = makeStyles((theme) => ({
  header: {
    marginBottom: "1rem",
  },
}));

const PageTitle = ({ children }) => {
  const classes = useStyles();
  return (
    <Grid className={classes.header} container>
      <Grid item xs>
        <Typography variant="h4">{children}</Typography>
      </Grid>
    </Grid>
  );
};

export default PageTitle;
