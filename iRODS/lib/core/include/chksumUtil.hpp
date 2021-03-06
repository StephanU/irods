/*** Copyright (c), The Regents of the University of California            ***
 *** For more information please refer to files in the COPYRIGHT directory ***/
/* getUtil.h - Header for for getUtil.c */

#ifndef CHKSUM_UTIL_HPP
#define CHKSUM_UTIL_HPP

#include "rodsClient.hpp"
#include "parseCommandLine.hpp"
#include "rodsPath.hpp"

extern "C" {

    int
    chksumUtil( rcComm_t *conn, rodsEnv *myRodsEnv, rodsArguments_t *myRodsArgs,
                rodsPathInp_t *rodsPathInp );
    int
    chksumDataObjUtil( rcComm_t *conn, char *srcPath,
                       rodsEnv *myRodsEnv, rodsArguments_t *rodsArgs,
                       dataObjInp_t *dataObjInp );
    int
    initCondForChksum( rodsEnv *myRodsEnv, rodsArguments_t *rodsArgs,
                       dataObjInp_t *dataObjInp, collInp_t *collInp );
    int
    chksumCollUtil( rcComm_t *conn, char *srcColl, rodsEnv *myRodsEnv,
                    rodsArguments_t *rodsArgs, dataObjInp_t *dataObjInp, collInp_t *collInp );

}

#endif	/* CHKSUM_UTIL_H */
