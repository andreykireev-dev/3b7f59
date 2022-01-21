import React from "react";
import moment from "moment";
import Checkbox from "@material-ui/core/Checkbox";

import { Grid, CircularProgress } from "@material-ui/core";

import PageTitle from "pages/mainlayout/PageTitle";
import PaginatedTable from "common/PaginatedTable";

const Content = ({
  selectedProspects,
  paginatedData,
  isDataLoading,
  count,
  page,
  rowsPerPage,
  handleChangePage,
  handleChangeRowsPerPage,
  handleOnSelect

}) => {
  let isSelected = id => selectedProspects.indexOf(id) !== -1;
  const rowData = paginatedData.map((row) => [
    <Checkbox 
      id={`checkbox-${row.id}`}
      name={`checkbox-${row.id}`}
      checked={isSelected}
    />,
    row.email,
    row.first_name,
    row.last_name,
    moment(row.created_at).format("MMM d"),
    moment(row.updated_at).format("MMM d"),
    row.id
  ]);

  


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
          onSelect={handleOnSelect}
          headerColumns={[
            <Checkbox />,
            "Email",
            "First Name",
            "Last Name",
            "Created",
            "Updated",
          ]}
          rowData={rowData}
        />
      )}
    </>
  );
};

export default Content;
