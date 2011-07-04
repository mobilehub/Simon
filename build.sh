#!/bin/sh

# build.sh
# dUsefulStuff
#
# Created by Derek Clarkson on 27/08/10.
# Copyright 2010 Derek Clarkson. All rights reserved.

# build specific.
DC_CURRENT_PROJECT_VERSION=${CURRENT_PROJECT_VERSION=0.1.0}
DC_PRODUCT_NAME=${PRODUCT_NAME=Simon}
DC_SRC=classes
DC_BUILD_TARGET="Simon"
DC_COMPANY_ID=au.com.derekclarkson
DC_AUTHOR="Derek Clarkson"
DC_COMPANY=$DC_AUTHOR

DC_SIMULATOR_SDK=iphonesimulator5.0
DC_DEVICE_SDK=iphoneos5.0

DC_SCRIPTS_DIR=../dUsefulStuff/scripts
DC_TOOLS_DIR=../tools

# Include common scripts.
source $DC_SCRIPTS_DIR/defaults.sh
source $DC_SCRIPTS_DIR/common.sh

# Clean and setup.
$DC_SCRIPTS_DIR/clean.sh

# Check for a doco only build.
if [ -n "$DC_BUILD_DOCO_ONLY" ]; then
	$DC_SCRIPTS_DIR/createDocumentation.sh
	exit 0
fi

# Otherwise do a full build.
$DC_SCRIPTS_DIR/buildStaticLibrary.sh
$DC_SCRIPTS_DIR/assembleFramework.sh
$DC_SCRIPTS_DIR/createDocumentation.sh

# Final assembly.
$DC_SCRIPTS_DIR/createDmg.sh


