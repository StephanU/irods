/*** Copyright (c), The Regents of the University of California            ***
 *** For more information please refer to files in the COPYRIGHT directory ***/
/* regColl.c
 */

#include "regColl.hpp"
#include "icatHighLevelRoutines.hpp"
#include "collection.hpp"

int
rsRegColl( rsComm_t *rsComm, collInp_t *regCollInp ) {
    int status;
    rodsServerHost_t *rodsServerHost = NULL;
    dataObjInp_t dataObjInp;
    rodsObjStat_t *rodsObjStatOut = NULL;


    memset( &dataObjInp, 0, sizeof( dataObjInp ) );

    rstrcpy( dataObjInp.objPath, regCollInp->collName, MAX_NAME_LEN );
    status = rsObjStat( rsComm, &dataObjInp, &rodsObjStatOut );
    if ( status >= 0 ) {
        if ( rodsObjStatOut != NULL ) {
            if ( rodsObjStatOut->specColl != NULL ) { // JMC cppcheck null ptr ref
                rodsLog( LOG_ERROR,
                         "rsRegColl: Reg path %s is in spec coll",
                         dataObjInp.objPath );
                //if (rodsObjStatOut != NULL)  // JMC cppcheck null ptr ref
                freeRodsObjStat( rodsObjStatOut );
                return ( SYS_REG_OBJ_IN_SPEC_COLL );
            }
        }
        freeRodsObjStat( rodsObjStatOut );
    }

    status = getAndConnRcatHost( rsComm, MASTER_RCAT, regCollInp->collName,
                                 &rodsServerHost );
    if ( status < 0 ) {
        return( status );
    }
    if ( rodsServerHost->localFlag == LOCAL_HOST ) {
#ifdef RODS_CAT
        status = _rsRegColl( rsComm, regCollInp );
#else
        status = SYS_NO_RCAT_SERVER_ERR;
#endif
    }
    else {
        status = rcRegColl( rodsServerHost->conn, regCollInp );
    }

    return ( status );
}

int
_rsRegColl( rsComm_t *rsComm, collInp_t *collCreateInp ) {
#ifdef RODS_CAT
    int status;
    collInfo_t collInfo;
    char *tmpStr;

    memset( &collInfo, 0, sizeof( collInfo ) );

    rstrcpy( collInfo.collName, collCreateInp->collName, MAX_NAME_LEN );

    if ( ( tmpStr = getValByKey( &collCreateInp->condInput, COLLECTION_TYPE_KW ) ) != NULL ) {
        rstrcpy( collInfo.collType, tmpStr, NAME_LEN );
        if ( ( tmpStr = getValByKey( &collCreateInp->condInput, COLLECTION_INFO1_KW ) ) != NULL ) {
            rstrcpy( collInfo.collInfo1, tmpStr, NAME_LEN );
        }
        if ( ( tmpStr = getValByKey( &collCreateInp->condInput, COLLECTION_INFO2_KW ) ) != NULL ) {
            rstrcpy( collInfo.collInfo2, tmpStr, NAME_LEN );
        }
    }

    /* if the "collection" keyword has been set, it provides the
       name of another collection to retrieve directory metadata
       from (usually during a icp or irsync operation */
    tmpStr = getValByKey( &collCreateInp->condInput, COLLECTION_KW );
    if ( tmpStr != NULL ) {
        rsQueryDirectoryMeta( rsComm, tmpStr, &collInfo.condInput );
    }
    else {
        /* otherwise copy over the source directory metadata if provided */
        copyFilesystemMetadata( &collCreateInp->condInput, &collInfo.condInput );
    }

    status = chlRegColl( rsComm, &collInfo );
    return ( status );
#else
    return ( SYS_NO_RCAT_SERVER_ERR );
#endif
}
