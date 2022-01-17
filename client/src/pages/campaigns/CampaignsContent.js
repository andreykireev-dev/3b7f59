import React from "react";
import moment from "moment";

import { Grid, CircularProgress } from "@material-ui/core";

import PaginatedTable from "common/PaginatedTable";
import PageTitle from "pages/mainlayout/PageTitle";

const CampaignsContent = ({
  paginatedData,
  isDataLoading,
  count,
  page,
  rowsPerPage,
  handleChangePage,
  handleChangeRowsPerPage,
}) => {
  const rowData = paginatedData.map((row) => [
    row.name,
    row.step_count || 0,
    row.prospects_count || 0,
    moment(row.created_at).format("MMM d"),
  ]);
  return (
    <>
      <PageTitle>Campaigns</PageTitle>
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
          headerColumns={["Name", "Steps", "Prospects", "Created"]}
          rowData={rowData}
        />
      )}
    </>
  );
};

export default CampaignsContent;