#
# config/config.mk
#
# This is the iRODS configuration Makefile included in all other
# Makefiles used to build the servers and clients.
#
# The iRODS configuration script copies config/config.mk.in to
# config/config.mk, filling in its best guesses on the OS platform
# and its features.  You can edit this file by hand to modify
# those guesses.
#

#
# Values filled in by the 'configure' script:
# 	OS_platform	The OS for this build.  Platforms supported:
#				alpha_platform
#				sgi_platform
#				solaris_platform
#				sunos_platform
#				aix_platform
#				osx_platform
#				linux_platform
#
#	FILE_64BITS	Whether 64-bit file sizes are supported.
#
#	ADDR_64BITS	Whether 64-bit addressing is supported.
#
#	PARA_OPR	A 1 to enable parallel operations.
#
#	RODS_CAT	A 1 to enable the iCAT in the iRODS server.
#
#	PSQICAT		A 1 if the iCAT uses an Postgres database.
#
#	POSTGRES_HOME	The home directory of Postgres, if PSQICAT = 1
#
#	ORAICAT		A 1 if the iCAT uses an Oracle database.
#
#	MYICAT	    A 1 if the iCAT uses an MySQL database.
#
#	ORACLE_HOME	The home directory of Oracle, if ORAICAT = 1
#
#	NEW_ODBC	A 1 if the Postgres interface uses the unix ODBC.
#
#	MODULES		The list of modules enabled during configuration.
#			Module names are the names of directories in
#			the 'modules' subdirectory.
#
OS_platform=linux_platform
#osx_106plus=
FILE_64BITS=1
ADDR_64BITS=1
MODULES= properties msoDrivers
PARA_OPR=1
RODS_CAT=1
PSQICAT=1
POSTGRES_HOME=/home/jasonc/dev/irods/Clean3.0/database/pgsql
NEW_ODBC=1
#ORAICAT=
#MYICAT=
#UNIXODBC_HOME=
#UNIXODBC_DATASOURCE=
ifndef ORACLE_HOME
ORACLE_HOME=
endif



#
# Configure the rule engine server
#
# RULE_ENGINE and RULE_ENGINE_N define whether one of the Rule Engines is enabled. 
# The former enables version 2.5, while the latter enables version 3.0.
# Version 2.5 may not support all features that are supported by version 3.0.
# 
# Enable this normally unless you are debugging some 
# particular module and dont want the rule engine to mess up the flow.
RULE_ENGINE_N=1
#RULE_ENGINE=1




#
# Check which database is in use for the iCAT
#
ifdef RODS_CAT

# Postgres
ifdef PSQICAT
PSQ_DBMS =  1
endif

# Oracle
ifdef ORAICAT
ORA_DBMS =  1
endif

# MySQL
ifdef MYICAT
MY_DBMS =  1
endif

endif


#
# Adjust for the Postgres iCAT
#
ifdef PSQICAT
RODS_CAT = 1
PSQ_DBMS = 1
DBMS_INCLUDE+= -DPSQICAT
endif


#
# Adjust for the Oracle iCAT
#
ifdef ORAICAT
RODS_CAT = 1
ORA_DBMS = 1
endif


#
# Adjust for the MySQL iCAT
#
ifdef MYICAT
RODS_CAT = 1
MY_DBMS = 1
endif


#
# Postgres options
#
ifdef PSQ_DBMS
ifeq ($(OS_platform), osx_platform)
NSL=
else
NSL=-lnsl
endif
PSQ_LIB_DIR = $(POSTGRES_HOME)/lib
PSQ_HDR_DIR = $(POSTGRES_HOME)/include
ifdef NEW_ODBC
DBMS_LIB+= -L$(PSQ_LIB_DIR) -lodbc $(NSL) -lm
else
DBMS_LIB+= -L$(PSQ_LIB_DIR) -lpsqlodbc $(NSL) -lm
endif
DBMS_INCLUDE+= -I$(PSQ_HDR_DIR)
endif


#
# Oracle options
#
ifdef ORA_DBMS
ifdef ADDR_64BITS
ORA_LIB_DIR = $(ORACLE_HOME)/lib
else
ifeq ($(OS_platform), osx_platform)
ORA_LIB_DIR = $(ORACLE_HOME)/lib32
else
ORA_LIB_DIR = $(ORACLE_HOME)/lib
endif
endif

ORA_HDR_DIR = $(ORACLE_HOME)/rdbms/public
DBMS_LIB+= -L$(ORA_LIB_DIR) -lclntsh
DBMS_INCLUDE+= -I$(ORA_HDR_DIR)
endif


#
# MySQL options
#
ifdef MY_DBMS
ifeq ($(OS_platform), osx_platform)
NSL=
else
NSL=-lnsl
endif
ODBC_LIB_DIR = $(UNIXODBC_HOME)/lib
ODBC_HDR_DIR = $(UNIXODBC_HOME)/include
DBMS_LIB+= -L$(ODBC_LIB_DIR) -lodbc $(NSL) -lm
DBMS_INCLUDE+= -I$(ODBC_HDR_DIR)
endif

#
# DBR (database-resource) options
#
#DBR=1
ifdef DBR
DBR_TYPE=postgres
POSTGRES_HOME=/tbox/IRODS_BUILD/iRODS/../pgsql
ifeq ($(OS_platform), osx_platform)
NSL=
else
NSL=-lnsl
endif
PSQ_LIB_DIR = $(POSTGRES_HOME)/lib
PSQ_HDR_DIR = $(POSTGRES_HOME)/include
DBMS_LIB+= -L$(PSQ_LIB_DIR) -lodbc $(NSL) -lm
DBMS_INCLUDE+= -I$(PSQ_HDR_DIR)
# Use lines like these, in place of the Postgres items above 
# (under ifdef DBR), for an Oracle DBR, using values for your
# Oracle installation:
#DBR_TYPE=oracle
#ORACLE_HOME=/usr/local/apps/oracle/home_102
#ORA_LIB_DIR = $(ORACLE_HOME)/lib
#ORA_HDR_DIR = $(ORACLE_HOME)/rdbms/public
#DBMS_LIB+= -L$(ORA_LIB_DIR) -lclntsh
#DBMS_INCLUDE+= -I$(ORA_HDR_DIR)

# Use lines like these, in place of the Postgres items above 
# for mysql:
#DBR_TYPE=mysql
#NEW_ODBC=1
#UNIXODBC_HOME=/usr
#UNIXODBC_DATASOURCE=ICAT
#ifeq ($(OS_platform), osx_platform)
#NSL=
#else
#NSL=-lnsl
#endif
#ODBC_LIB_DIR = $(UNIXODBC_HOME)/lib
#ODBC_HDR_DIR = $(UNIXODBC_HOME)/include
#DBMS_LIB+= -L$(ODBC_LIB_DIR) -lodbc $(NSL) -lm
#DBMS_INCLUDE+= -I$(ODBC_HDR_DIR)

endif


#
# Misc options
#

# CCMALLOC - specify whether mem leak checking CCMALLOC should be run
# CCMALLOC = 1
ifdef CCMALLOC
CCMALLOC_DIR=/data/mwan/rods/ccmalloc/ccmalloc-0.4.0
endif


# IRODS_FS - specify that irodsFuse should be built
# The latest version is 26 for release 2.7. It default to 21 if not defined
# IRODS_FS = 1
ifdef IRODS_FS
fuseHomeDir=/home/mwan/adil/fuse-2.7.0
endif

# PHP_LIB - specify whether php library will be loaded into irodsAgent.
# Would like to use PHP as a micro-service language
# PHP_LIB = 1
ifdef PHP_LIB
PHP_LIB_DIR=/data/mwan/php/php-5.2.5x/libs
endif

# TAR_STRUCT_FILE - specify whether the tar structured file will be loaded
# into irodsAgent. TAR_EXEC_PATH specifies the path of the tar executable
# is located if the tar executable is to be used for tar operation.
# Otherwise tarDir can be used to specify the directory path of libtar.
# Both TAR_EXEC_PATH  and tarDir should NOT be specified. By default, 
# TAR_EXEC_PATH is on and tarDir is off.
TAR_STRUCT_FILE = 1
ifdef TAR_STRUCT_FILE
ifeq ($(OS_platform), osx_platform)
TAR_EXEC_PATH="`which tar`"
else
TAR_EXEC_PATH=/bin/tar
endif
# tarDir=/data/mwan/tar/libtar-1.2.11
endif

#
# Grid Security Infrastructure
# 
# Uncomment '# GSI_AUTH=1' and specify your GLOBUS_LOCATION and 
# GSI_INSTALL_TYPE (the examples of these below work at SDSC).
#
# Some versions/installations of Globus will use the system SSL and
# Crypto libraries.  If GSI_SSL and/or GSI_CRYPTO are set, the
# Makefiles will use system libs instead of the Globus ones.
# 'configure' will set these if the globus ssl and crypto libraries do
# not exist in $(GLOBUS_LOCATION)/lib (setting GSI_SSL to ssl and
# GSI_CRYPTO to crypto).
#
#
# GSI_AUTH = 1
ifdef GSI_AUTH
GLOBUS_LOCATION=/usr/local/apps/globus-4.0.1
GSI_INSTALL_TYPE=gcc32dbg
GSI_SSL=
GSI_CRYPTO=
endif

# RBUDP_TRANSFER - specify whether RBUDP file transfer mechanism will be
# supported (iget/iget -U)
RBUDP_TRANSFER = 1

# UNI_CODE - support UTF-8 on linux and UTF-16 on windows
# UNI_CODE = 1

# COMPAT_201 - The data structures of many APIs have been consolidated
# after version 2.0.1. If this flag is set, the server API handle
# will be made to handle the 2.0.1 client request in addition to the
# new data structures. This flag is set by default
COMPAT_201=1

# Kerberos authentication
# KRB_AUTH = 1
ifdef KRB_AUTH
KRB_LOC=/usr/kerberos
endif

# Syslog logging
# Uncomment this line to log into syslog instead of the usual
# server/log/ log files.
#IRODS_SYSLOG = 1

# HPSS - Define whether HPSS is supported on this server. HPSS_UNIX_PASSWD_AUTH
# specifies whether the UNix password authentication should be used. 
# HPSS_KRB5_AUTH specifies whether the Kerberos keytab file should be used.
# The default is using the UNIX keytab file.
# HPSS=1

ifdef HPSS
# HPSS_UNIX_PASSWD_AUTH=1
# HPSS_KRB5_AUTH=1

# HPSS7 - Defines whether the HPSS v7 library or later is used. The default
# is HPSS v6
# HPSS7=1

# HPSS_LIB_DIR is the directory of the HPSS library and HPSS_HDR_DIR is the
# directory of the HPSS header files. When building iRODS, be sure to add the 
# path defined by HPSS_LIB_DIR to the path in the LD_LIBRARY_PATH env variable.
HPSS_LIB_DIR=/opt/hpss/lib
HPSS_HDR_DIR=/opt/hpss/include
ADDR_64BITS=
endif

# AMAZON_S3 - Define whether AMAZON S3 is supported on this server.
# AMAZON_S3=1

ifdef AMAZON_S3
S3_LIB_DIR=/data1/mwan/s3/libs3-1.4/build/lib
S3_HDR_DIR=/data1/mwan/s3/libs3-1.4/build/include
endif

# Extensible ICAT

# See modules/extendedICAT/README.txt.  Uncomment this line, and add
# modules/extendedICAT/extendedICAT.h, to enable the extensible ICAT:
# EXTENDED_ICAT = 1

# DDN_WOS - Define whether DDN's WOS driver is supported on this server.
# WOS_DIR is the directory for the WOS library ($(WOS_DIR)/lib64) and
# include files ($(WOS_DIR)/include). BOOST_DIR is the directory where
# the BOOST directory is located. BOOST is required for compiling the
# C++ WOS driver.
# DDN_WOS=1

ifdef DDN_WOS
WOS_DIR=/home/mwan/myapps/ddn/woscpp
BOOST_DIR=/home/mwan/myapps/boost/boost_1_44_0
endif

# RUN_SERVER_AS_ROOT - Defines whether the iRODS server contains code
# that will allow the iRODS servers to switch between root and service
# user permissions for specific operations. Even if set here, will only
# be enabled if a) the server is started as root, and b) the environment
# variable irodsServiceUser is set to the desired system user.
# RUN_SERVER_AS_ROOT = 1
 
# USE_BOOST -  specify whether the BOOST library should be used. BOOST_DIR is
# the directory where the BOOST directory is located, which is normally
# the .../iRODS/boost_irods directory.  First run 'buildboost.sh' in the
# iRODS directory to create boost_irods.
#USE_BOOST=1
ifdef USE_BOOST
ifndef BOOST_DIR
BOOST_DIR=/home/jasonc/dev/irods/Clean3.0/iRODS/boost_irods
endif
endif

# OS_AUTH - build in support for "OS level" authentication. This form
# of authentication uses a shared secret and the genOSAuth command to
# generate a credential that the user presents to the iRODS server. 
# You can use this instead of using password authentication.
# OS_AUTH = 1
ifdef OS_AUTH
OS_AUTH_KEYFILE = /etc/irods.key
# Some environments don't have a uniform username/uid
# space between the IES and the clients. Uncomment
# OS_AUTH_NO_UID if this is the case, so the uid will
# not be used when generating the authenticator.
# OS_AUTH_NO_UID = 1
endif
