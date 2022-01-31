import React, { useState } from 'react';
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
import Checkbox from "@material-ui/core/Checkbox";
import Button from "@material-ui/core/Button";
import Box from "@material-ui/core/Box";
import Modal from "@material-ui/core/Modal";
import Snackbar from '@material-ui/core/Snackbar';
import Alert from '@material-ui/lab/Alert';


import moment from "moment";

import axios from "axios";




import { CircularProgress, Grid, TableCell, TextField, Typography } from "@material-ui/core";
import { NUM_ROWS_PER_PAGE_CHOICES } from "../../constants/table";
import { useTableStyles } from "../../styles/table";
import { useModalStyles } from "../../styles/modal";
import { Autocomplete } from '@material-ui/lab';


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


function AddToCampaignModal({
  selected, setSelected
  
}) {
  const [modalState, setModalState] = useState(false);
  const [snackbarStatus, setSnackbarStatus] = useState(false);
  const [notification, setNotification] = useState({});
  const { modalBox, snackbar } = useModalStyles();
  
  const [isDataLoading, setIsDataLoading] = useState(true);
  const [campaignsData, setCampaignsData] = useState([]);
  
  const { flexRoot, flexRootStart, flexRootEnd } = useTableStyles();
  const [selectedCampaign, setSelectedCampaign] = useState({});

  const addToCampaign = async (prospects) => {
    setIsDataLoading(true);
    try {
      const resp = await axios.post(
        `/api/campaigns/${selectedCampaign.id}/prospects`, 
        {prospect_ids: prospects},
      );
      let notification = {
        severity: "success",
        message: `Added ${resp.data.prospect_ids.length} prospects to ${selectedCampaign.name}.`
      }
      if (resp.data.prospect_ids.length < selected.length) {
        notification.severity = "warning"
        notification.message += " Some selected prospects already added to the Campaign."
      }
      setNotification(notification);
      setSnackbarStatus(true);
      setModalState(false);
      setSelected([]);
    } catch (error) {
        console.error(error);
    } finally {
        setIsDataLoading(false);
    }
  };


  const getCampaigns = async () => {
    setIsDataLoading(true);
    try {
      const resp = await axios.get(
        `/api/campaigns`,
      );
      setCampaignsData(resp.data.campaigns);
    } catch (error) {
      console.error(error);
    } finally {
      setIsDataLoading(false);
    }
  };

  const handleModalOpen = () => {
    if (selected.length > 0) {
      setSnackbarStatus(false);
      setModalState(true);
      getCampaigns();
    } else {
      setNotification({severity: "warning", message: "Please select Prospects to add."})
      setSnackbarStatus(true);

    }
  };

  const handleModalClose = () => {
    setModalState(false);
  };

  const handleSnackbarClose = (event, reason) => {
    setSnackbarStatus(false);
  };


  const AlertBox = () => {
    if (notification.severity) {
      return (
        <Snackbar 
          open={snackbarStatus} 
          autoHideDuration={6000} 
          onClose={handleSnackbarClose}
          className={snackbar}
        >
          <Alert onClose={handleSnackbarClose} severity={notification.severity}>
            {notification.message}
          </Alert>
        </Snackbar>
      );
    } else {
      return false
    }

  };

  const autocomplete = (
    <Autocomplete
      options={campaignsData}
      getOptionLabel={(option) => option.name}
      style={{ width: 350 }}
      renderInput={(params) => <TextField {...params} label="Add to Campaign" variant="outlined" />}
      onChange={(event, newValue) => {setSelectedCampaign(newValue)}}
    />
  )

  const body = (
    <div className={modalBox}>
      <h2>Select a Campaign to Add {selected.length} Prospect{selected.length > 1 ? "s" : ""}</h2>
      <div className={flexRoot}>
        <div className={flexRootStart}>
          {isDataLoading ? (
            <Grid container justifyContent="center">
              <CircularProgress />
            </Grid>
          ) : (
            autocomplete
          )}
          </div>
          <div className={flexRootEnd}>
          <Button
            variant="contained"
            color="primary"
            size="large"
            onClick={() => addToCampaign(selected)}
          >
            Add
          </Button>
        </div>
      </div>
    </div>
  );


  return (
    <div>
      <Button
        variant="outlined"
        color="primary"
        size="small"
        onClick={handleModalOpen}
      >
        Add to Campaign
      </Button>
      <AlertBox />
      <Modal
        open={modalState}
        onClose={handleModalClose}
        centered
      >
        {body}
      </Modal>
    </div>
  );

}


export default function CustomPaginatedTable({
  paginatedData,
  count,
  page,
  rowsPerPage,
  headerColumns,
  handleChangePage,
  handleChangeRowsPerPage,
  selected, setSelected,
  enableCheckbox
  
}) {

  const { tableContainer, tableHead, flexRoot, flexRootStart, flexRootEnd, headerCheckbox } = useTableStyles();
  
  const isSelected = (name) => selected.indexOf(name) !== -1;
  const allSelected = () => paginatedData.map(row=>row.id).every(elem => selected.includes(elem));

  const handleSelectAll = () => {
    let newSelected = [];

    if (allSelected()) {
      // unselect all
      newSelected = [...selected];

      paginatedData.map(row=>row.id).forEach(id => {
        const index = newSelected.indexOf(id);
        if (index > -1) {
          newSelected.splice(index,1);
        }
      });
      setSelected(newSelected);
    } else {
      // select all
      paginatedData.map(row=>row.id).forEach(id => {
        const index = selected.indexOf(id);
        if (index === -1) {
          newSelected = newSelected.concat(id)
        }
      });
      newSelected = selected.concat(newSelected)

    }
    setSelected(newSelected);

  }


  const selectItem = (id) => {
    const selectedIndex = selected.indexOf(id);
    let newSelected = [];

    if (selectedIndex === -1) {
      newSelected = newSelected.concat(selected, id);
    } 

    setSelected(newSelected);
  };

  const unselectItem = (id) => {
    const selectedIndex = selected.indexOf(id);
    let newSelected = [];

    if (selectedIndex === 0) {
      newSelected = newSelected.concat(selected.slice(1));
    } else if (selectedIndex === selected.length - 1) {
      newSelected = newSelected.concat(selected.slice(0, -1));
    } else if (selectedIndex > 0) {
      newSelected = newSelected.concat(
        selected.slice(0, selectedIndex),
        selected.slice(selectedIndex + 1),
      );
    }

    setSelected(newSelected);
  };

  
  const toggleSelection = (event, id) => {
    const selectedIndex = selected.indexOf(id);

    if (selectedIndex === -1) {
      selectItem(id);
    } else {
      unselectItem(id);
    }
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

      <div className={flexRoot}>
        <div className={flexRootStart}>
          <strong>
            {selected.length} of {count} selected
          </strong>
          <Box pr={2} />
          <AddToCampaignModal 
            selected={selected}
            setSelected={setSelected}
          />
        </div>
        <div className={flexRootEnd}>
          <TablePagination
            rowsPerPageOptions={NUM_ROWS_PER_PAGE_CHOICES}
            // colSpan={3}
            count={count}
            component="div"
            
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
      </div>
      <Paper className={tableContainer} component={Paper}>
        <MaterialTable aria-label="custom pagination table" >
          <TableHead className={tableHead}>
            <TableRow>
              {enableCheckbox &&  
                <TableCell padding="checkbox">
                  <Checkbox
                    className={headerCheckbox}
                    checked={allSelected()}
                    onClick={handleSelectAll}
                    color="secondary"
                  />
                </TableCell>
              }
              {headerColumns.map((col, index) => (
                <React.Fragment key={index}>
                  <TableCell variant="head">{col}</TableCell>
                </React.Fragment>
              ))}
            </TableRow>
          </TableHead>
          <TableBody>{
                paginatedData.map((row) => {

                  return (
                      <TableRow 
                        hover
                        key={row.id} 
                        id={row.id}
                        onClick={(event) => toggleSelection(event, row.id)}
                      >
                        {enableCheckbox &&  
                          <TableCell padding="checkbox">
                            <Checkbox 
                              id={`checkbox-${row.id}`}
                              name={`checkbox-${row.id}`}
                              color="primary"
                              checked={isSelected(row.id)}
                              onClick={(event) => toggleSelection(event, row.id)}
                            />
                          </TableCell>
                        }
                        {[row.email, 
                          row.first_name,
                          row.last_name,
                          moment(row.created_at).format("MMM d"),
                          moment(row.updated_at).format("MMM d"),
                        ].map((col) => (
                          <TableCell>{col}</TableCell>
                        ))}
                      </TableRow>
                  );
                })
          }</TableBody>
          <TableFooter>
            <TableRow></TableRow>
          </TableFooter>
        </MaterialTable>
      </Paper>
    </React.Fragment>
  );
}
