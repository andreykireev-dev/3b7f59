import React from "react";
import withAuth from "common/withAuth";
import Drawer from "common/Drawer";

import ReportingContent from "pages/reporting/ReportingContent";

const Reporting = () => {
  return (
    <>
      <Drawer RightDrawerComponent={<ReportingContent />} />
    </>
  );
};

export default withAuth(Reporting);
