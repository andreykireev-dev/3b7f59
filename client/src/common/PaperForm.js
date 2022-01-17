import React from "react";
import {
  TextField,
  Paper,
  Typography,
  makeStyles,
  Button,
} from "@material-ui/core";

//CSS styles
const useStyles = makeStyles((theme) => ({
  container: {
    width: "490px",
    margin: "40px auto 0 auto",
    padding: "2rem 4rem 2rem 4rem",
    display: "flex",
    flexDirection: "column",
    alignItems: "center",
  },
  formTitle: {
    marginBottom: "20px",
  },
  button: {
    width: "10rem",
    margin: "1rem 0 2rem 0",
  },
  textField: {
    marginTop: "10px",
  },
  errorText: {
    marginBottom: theme.spacing(1),
  },
}));

const PaperForm = ({
  title,
  fields,
  onSubmit,
  submitButtonName,
  footer,
  disableSubmit = false,
  error = null,
}) => {
  const classes = useStyles();

  return (
    <Paper
      component="form"
      className={classes.container}
      elevation={3}
      spacing={2}
      onSubmit={(e) => e.preventDefault()}
    >
      <Typography
        className={classes.formTitle}
        variant="h4"
        display="block"
        align="center"
      >
        {title}
      </Typography>

      {fields.map(({ value, errorMessage, onChange, label, type, size }) => (
        <TextField
          fullWidth
          variant="outlined"
          key={label}
          placeholder={label}
          className={classes.textField}
          error={errorMessage ? true : false}
          helperText={errorMessage}
          value={value || ""}
          type={type}
          onChange={(e) => onChange(e.target.value)}
          size={size}
        />
      ))}

      <Button
        type="submit"
        onClick={onSubmit}
        className={classes.button}
        variant="contained"
        color="primary"
        size="large"
        disabled={disableSubmit}
      >
        {submitButtonName}
      </Button>
      {error && (
        <Typography
          variant="subtitle1"
          color="error"
          className={classes.errorText}
        >
          {error}
        </Typography>
      )}

      {footer}
    </Paper>
  );
};

export default PaperForm;
