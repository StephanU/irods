/*** Copyright (c), The Regents of the University of California            ***
 *** For more information please refer to files in the COPYRIGHT directory ***/

/* procApiRequest.h - header file for procApiRequest.c
 */



#ifndef PROC_API_REQUEST_HPP
#define PROC_API_REQUEST_HPP

#include "rods.hpp"
#include "apiHandler.hpp"

extern "C" {

    int
    procApiRequest( rcComm_t *conn, int apiNumber, void *inputStruct,
                    bytesBuf_t *inputBsBBuf, void **outStruct, bytesBuf_t *outBsBBuf );

    int
    sendApiRequest( rcComm_t *conn, int apiInx, void *inputStruct,
                    bytesBuf_t *inputBsBBuf );
    int
    procApiReply( rcComm_t *conn, int apiInx, void **outStruct,
                  bytesBuf_t *outBsBBuf,
                  msgHeader_t *myHeader, bytesBuf_t *outStructBBuf, bytesBuf_t *myOutBsBBuf,
                  bytesBuf_t *errorBBuf );
    int
    readAndProcApiReply( rcComm_t *conn, int apiInx, void **outStruct,
                         bytesBuf_t *outBsBBuf );
    int
    branchReadAndProcApiReply( rcComm_t *conn, int apiNumber,
                               void **outStruct, bytesBuf_t *outBsBBuf );
    int
    cliGetCollOprStat( rcComm_t *conn, collOprStat_t *collOprStat, int vFlag,
                       int retval );
    int
    _cliGetCollOprStat( rcComm_t *conn, collOprStat_t **collOprStat );
}

#endif	/* PROC_API_REQUEST_H */
