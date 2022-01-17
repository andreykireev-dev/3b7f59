import React, { useState, useEffect } from "react";
import withAuth from "common/withAuth";
import Drawer from "common/Drawer";
import ProspectsContent from "./ProspectsContent";
import axios from "axios";
import { DEFAULT_NUM_ROWS_PER_PAGE } from "../../constants/table";

const Prospects = () => {
  const [prospectsData, setProspectsData] = useState([]);
  const [isDataLoading, setIsDataLoading] = useState(true);
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
    const fetchProspects = async () => {
      setIsDataLoading(true);

      try {
        const resp = await axios.get(
          `/api/prospects?page=${currentPage}&page_size=${rowsPerPage}`,
        );
        if (resp.data.error) throw new Error(resp.data.error);
        setProspectsData(resp.data.prospects);
        setCount(resp.data.total);
      } catch (error) {
        console.error(error);
      } finally {
        setIsDataLoading(false);
      }
    };
    fetchProspects();
  }, [rowsPerPage, currentPage]);

  return (
    <>
      <Drawer
        RightDrawerComponent={
          <ProspectsContent
            isDataLoading={isDataLoading}
            paginatedData={prospectsData}
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

export default withAuth(Prospects);
