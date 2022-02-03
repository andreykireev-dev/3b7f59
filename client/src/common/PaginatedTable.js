import React from "react";
import MaterialTable from "@material-ui/core/Table";
import TableBody from "@material-ui/core/TableBody";
import TableHead from "@material-ui/core/TableHead";
import TableRow from "@material-ui/core/TableRow";
import Paper from "@material-ui/core/Paper";
import TableFooter from "@material-ui/core/TableFooter";
import TablePagination from "@material-ui/core/TablePagination";
import IconButton from "@material-ui/core/IconButton";
import FirstPageIcon from "@material-ui/icons/FirstPage";
import KeyboardArrowLeft from "@material-ui/icons/KeyboardArrowLeft";
import KeyboardArrowRight from "@material-ui/icons/KeyboardArrowRight";
import LastPageIcon from "@material-ui/icons/LastPage";

import { Grid, TableCell, Typography } from "@material-ui/core";
import { NUM_ROWS_PER_PAGE_CHOICES } from "../constants/table";
import { useTableStyles } from "../styles/table";

function TablePaginationActions(props) {
  const { paginationRoot, paginationIconButton } = useTableStyles();
  const { count, page, rowsPerPage, onChangePage } = props;

  const handleFirstPageButtonClick = (event) => {
    onChangePage(event, 0);
  };

  const handleBackButtonClick = (event) => {
    onChangePage(event, page - 1);
  };

  const handleNextButtonClick = (event) => {
    onChangePage(event, page + 1);
  };

  const handleLastPageButtonClick = (event) => {
    onChangePage(event, Math.max(0, Math.ceil(count / rowsPerPage) - 1));
  };

  return (
    <div className={paginationRoot}>
      <IconButton
        className={paginationIconButton}
        onClick={handleFirstPageButtonClick}
        disabled={page === 0}
        aria-label="first page"
      >
        {<FirstPageIcon />}
      </IconButton>
      <IconButton
        className={paginationIconButton}
        onClick={handleBackButtonClick}
        disabled={page === 0}
        aria-label="previous page"
      >
        {<KeyboardArrowLeft />}
      </IconButton>
      <IconButton
        className={paginationIconButton}
        onClick={handleNextButtonClick}
        disabled={page >= Math.ceil(count / rowsPerPage) - 1}
        aria-label="next page"
      >
        {<KeyboardArrowRight />}
      </IconButton>
      <IconButton
        className={paginationIconButton}
        onClick={handleLastPageButtonClick}
        disabled={page >= Math.ceil(count / rowsPerPage) - 1}
        aria-label="last page"
      >
        {<LastPageIcon />}
      </IconButton>
    </div>
  );
}

export default function CustomPaginatedTable({
  paginatedData,
  count,
  page,
  rowsPerPage,
  headerColumns,
  rowData,
  handleChangePage,
  handleChangeRowsPerPage,
}) {
  const { tableContainer, tableHead, flexRootEnd } = useTableStyles();

  const renderRows = () => {
    return rowData.map((row, index) => (
      <TableRow key={index} hover>
        {row.map((col, index) => (
          <TableCell key={index}>{col}</TableCell>
        ))}
      </TableRow>
    ));
  };

  if (paginatedData.length === 0) {
    return (
      <Grid container justifyContent="center">
        <Grid item>
          <Typography>No Available Data</Typography>
        </Grid>
      </Grid>
    );
  }

  return (
    <React.Fragment>
      <div className={flexRootEnd}>
        <TablePagination
          rowsPerPageOptions={NUM_ROWS_PER_PAGE_CHOICES}
          colSpan={3}
          count={count}
          rowsPerPage={rowsPerPage}
          page={page}
          SelectProps={{
            inputProps: { "aria-label": "rows per page" },
            native: true,
          }}
          onChangePage={handleChangePage}
          onChangeRowsPerPage={handleChangeRowsPerPage}
          ActionsComponent={TablePaginationActions}
        />
      </div>
      <Paper className={tableContainer} component={Paper}>
        <MaterialTable aria-label="custom pagination table">
          <TableHead className={tableHead}>
            <TableRow>
              {headerColumns.map((col, index) => (
                <React.Fragment key={index}>
                  <TableCell variant="head">{col}</TableCell>
                </React.Fragment>
              ))}
            </TableRow>
          </TableHead>
          <TableBody>{renderRows()}</TableBody>
          <TableFooter>
            <TableRow></TableRow>
          </TableFooter>
        </MaterialTable>
      </Paper>
    </React.Fragment>
  );
}
