using {
    Currency,
    managed,
    sap,
    cuid
} from '@sap/cds/common';

namespace trial.btp.api;

aspect muid {
    key id : UUID; //> automatically filled in
}
