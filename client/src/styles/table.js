import { makeStyles } from "@material-ui/core";

export const useTableStyles = makeStyles((theme) => ({
  tableContainer: {
    padding: "1rem",
    "& td, th": {
      fontWeight: "bold",
    },
    "& td": {
      borderBottom: `1px solid ${theme.palette.grey[200]}`,
    },
  },
  tableHead: {
    backgroundColor: theme.palette.primary.main,
    "& th": {
      color: "#ffffff",
      border: "none",
    },
    "& th:first-child": {
      borderRadius: "5px 0 0 5px",
    },
    "& th:last-child, ": {
      borderRadius: "0  5px 5px 0",
    },
  },
  paginationRoot: {
    flexShrink: 0,
    marginLeft: theme.spacing(2.5),
    border: "1px solid",
    borderColor: theme.palette.text.disabled,
    borderRadius: 3 + "rem",
  },
  paginationIconButton: {
    padding: 0,
    "& > *": {
      color: theme.palette.primary.light,
    },
  },
  flexRoot: {
    display: "flex",
    alignItems: "center",
    justifyContent: "space-between",
  },
  flexRootEnd: {
    display: "flex",
    alignItems: "center",
    justifyContent: "flex-end",
  },
  flexEnd: {
    alignSelf: "flex-end",
  },
}));
