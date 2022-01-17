import React from "react";
import withAuth from "common/withAuth";
import Drawer from "common/Drawer";

import TemplatesContent from "pages/templates/TemplatesContent";

const Templates = () => {
  return (
    <>
      <Drawer RightDrawerComponent={<TemplatesContent />} />
    </>
  );
};

export default withAuth(Templates);
