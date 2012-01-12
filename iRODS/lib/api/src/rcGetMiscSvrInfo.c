/*** Copyright (c), The Regents of the University of California            ***
 *** For more information please refer to files in the COPYRIGHT directory ***/
/* rcGetMiscSvrInfo.c - Client API call for GetMiscSvrInfo. Part of the 
 * reoutine may be generated by a script
 */
#include "getMiscSvrInfo.h"

int
rcGetMiscSvrInfo (rcComm_t *conn, miscSvrInfo_t **outSvrInfo)
{
    int status;

    *outSvrInfo = NULL;

    status = procApiRequest (conn, GET_MISC_SVR_INFO_AN, NULL, NULL,
      (void **) outSvrInfo, NULL);

    return (status);
}
