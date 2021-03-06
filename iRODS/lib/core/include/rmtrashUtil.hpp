/*** Copyright (c), The Regents of the University of California            ***
 *** For more information please refer to files in the COPYRIGHT directory ***/
/* getUtil.h - Header for for getUtil.c */

#ifndef RMTRASH_UTIL_HPP
#define RMTRASH_UTIL_HPP

#include "rodsClient.hpp"
#include "parseCommandLine.hpp"
#include "rodsPath.hpp"

extern "C" {

    int
    rmtrashUtil( rcComm_t *conn, rodsEnv *myRodsEnv, rodsArguments_t *myRodsArgs,
                 rodsPathInp_t *rodsPathInp );
    int
    rmtrashDataObjUtil( rcComm_t *conn, char *srcPath,
                        rodsEnv *myRodsEnv, rodsArguments_t *rodsArgs,
                        dataObjInp_t *dataObjInp );
    int
    initCondForRmtrash( rodsEnv *myRodsEnv, rodsArguments_t *rodsArgs,
                        dataObjInp_t *dataObjInp, collInp_t *collInp );
    int
    rmtrashCollUtil( rcComm_t *conn, char *srcColl, rodsEnv *myRodsEnv,
                     rodsArguments_t *rodsArgs, dataObjInp_t *dataObjInp, collInp_t *collInp );

}

#endif	/* RMTRASH_UTIL_H */
