import React, { useEffect, useState } from "react";
import withAuth from "common/withAuth";
import Drawer from "common/Drawer";
import axios from "axios";
import Content from "./CampaignsContent";
import { DEFAULT_NUM_ROWS_PER_PAGE } from "constants/table";

const Campaigns = () => {
  const [isDataLoading, setIsDataLoading] = useState(true);
  const [campaignsData, setCampaignsData] = useState([]);
  const [currentPage, setCurrentPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(DEFAULT_NUM_ROWS_PER_PAGE);
  const [count, setCount] = useState(0);

  const handleChangeRowsPerPage = (event, _) => {
    setRowsPerPage(event.target.value);
    setCurrentPage(0);
  };

  const handleChangePage = (_, index) => {
    setCurrentPage(index);
  };

  useEffect(() => {
    const getCampaigns = async () => {
      setIsDataLoading(true);
      try {
        const resp = await axios.get(
          `/api/campaigns?page=${currentPage}&page_size=${rowsPerPage}`,
        );
        setCampaignsData(resp.data.campaigns);
        setCount(resp.data.total);
      } catch (error) {
        console.error(error);
      } finally {
        setIsDataLoading(false);
      }
    };

    getCampaigns();
  }, [rowsPerPage, currentPage]);

  return (
    <>
      <Drawer
        RightDrawerComponent={
          <Content
            paginatedData={campaignsData}
            isDataLoading={isDataLoading}
            count={count}
            page={currentPage}
            rowsPerPage={rowsPerPage}
            handleChangePage={handleChangePage}
            handleChangeRowsPerPage={handleChangeRowsPerPage}
          />
        }
      />
    </>
  );
};

export default withAuth(Campaigns);
