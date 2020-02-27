#!/bin/bash

topdir=`cd ${0%/ci.sh}/../.. && pwd`
dbdir="${CTNG_CI_DBDIR:-${HOME}/.ctng-ci-dbdir}"

info()
{
	echo " INFO :: $@" >&2
}

warn()
{
	echo " WARN :: $@" >&2
}

error()
{
	echo "ERROR :: $@" >&2
}

run_one_sample()
{
	local host="${1}"
	local sample="${2}"
}

info "Starting Crosstool-NG CI engine"
mkdir -p "${dbdir}"
