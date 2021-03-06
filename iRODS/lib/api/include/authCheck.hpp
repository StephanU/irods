/*** Copyright (c), The Regents of the University of California            ***
 *** For more information please refer to files in the COPYRIGHT directory ***/
/* authCheck.h
 */

#ifndef AUTH_CHECK_HPP
#define AUTH_CHECK_HPP

/* This is a Metadata API call but is is only used server to server */

/* This is used by one server to connect to the ICAT-enabled server to
   verify a user's login */

#include "rods.hpp"
#include "rcMisc.hpp"
#include "procApiRequest.hpp"
#include "apiNumber.hpp"
#include "initServer.hpp"
#include "icatDefines.hpp"

extern "C" {

    typedef struct {
        char *challenge;
        char *response;
        char *username;
    } authCheckInp_t;

    typedef struct {
        int  privLevel;
        int  clientPrivLevel;
        char *serverResponse;
    } authCheckOut_t;

#define authCheckInp_PI "str *challenge; str *response; str *username;"

#define authCheckOut_PI "int privLevel; int clientPrivLevel; str *serverResponse;"

#if defined(RODS_SERVER)
#define RS_AUTH_CHECK rsAuthCheck
    /* prototype for the server handler */
    int
    rsAuthCheck( rsComm_t *rsComm, authCheckInp_t *authCheckInp,
                 authCheckOut_t **authCheckOut );

#else
#define RS_AUTH_CHECK NULL
#endif

    /* prototype for the client call */
    int
    rcAuthCheck( rcComm_t *conn, authCheckInp_t *authCheckInp,
                 authCheckOut_t **authCheckOut );

}

#endif	/* AUTH_CHECK_H */
