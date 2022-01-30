import { makeStyles } from "@material-ui/core";

export const useModalStyles = makeStyles((theme) => ({
    modalBox: {
        position: 'absolute',
        top: '50%',
        left: '50%',
        transform: 'translate(-50%, -50%)',
        width: 500,
        backgroundColor: theme.palette.background.paper,
        // border: '2px solid #000',
        boxShadow: theme.shadows[5],
        padding: theme.spacing(2, 4, 3),
        borderRadius: 5
        },
    snackbar: {
        boxShadow: theme.shadows[5],
    }
    
}));
