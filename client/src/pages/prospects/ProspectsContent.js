import React from "react";

import { Grid, CircularProgress } from "@material-ui/core";

import PageTitle from "pages/mainlayout/PageTitle";
import PaginatedTable from "common/PaginatedTable";



const Content = ({
  paginatedData,
  isDataLoading,
  count,
  page,
  rowsPerPage,
  handleChangePage,
  handleChangeRowsPerPage,

}) => {

  


  return (
    <>
      <PageTitle>Prospects</PageTitle>
      {isDataLoading ? (
        <Grid container justifyContent="center">
          <CircularProgress />
        </Grid>
      ) : (
        <PaginatedTable
          paginatedData={paginatedData}
          handleChangePage={handleChangePage}
          handleChangeRowsPerPage={handleChangeRowsPerPage}
          count={count}
          page={page}
          rowsPerPage={rowsPerPage}
          headerColumns={[
            "Email",
            "First Name",
            "Last Name",
            "Created",
            "Updated",
          ]}
        />
      )}
    </>
  );
};

export default Content;
