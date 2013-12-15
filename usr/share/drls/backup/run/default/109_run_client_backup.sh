
# Maybe in reporting functions
function report_error_ovo(){

local ERRMSG="$@"
#local ERRMSG="$*"
local CMDOUT

echo "······················"
echo "$ERRMSG"
echo "······················"


#echo "${OVOCMD} a="${OVOAPP}" s="${OVOSEV}" o="${OVOOBJ}" msg_grp="${OVOMSGGRP}" msg_text="$ERRMSG""
CMDOUT=$(${OVOCMD} application="${OVOAPP}" severity="${OVOSEV}" object="${OVOOBJ}" msg_grp="${OVOMSGGRP}" msg_text="$ERRMSG";)
if [ $? -eq 0 ]; then
	LogPrint "Error Reported!"
	return 0
else
	Error "${CMDOUT}"
	return 1
fi
}


# Maybe in framework functions
function ErrReport(){

local ERRMSG="$@"
#local ERRMSG="$*"


if [ "${ERR_REPORT}" == "yes" ]; then
	report_error_ovo "${ERRMSG}"
	return $?
fi

}


# Maybe in backup functions
function run_rear_ssh_remote(){

local CLIENT=$1
local MODE=$2 
local REARCMD
local BKPOUT

if [ ${MODE} == "B" ]; then
	REARCMD="sudo rear mkbackup"
else
	if [ ${MODE} == "R" ]; then
		REARCMD="sudo rear mkrescue"
	else
		LogPrint "Unknown mode: ${MODE}"
		return 1
	fi
fi

BKPOUT=$(ssh -t drls@${CLIENT} ${REARCMD} 2>&1)

if [ $? -ne 0 ]
then    
        LogPrint "${BKPOUT}"
        ErrReport "${BKPOUT}"
        [ $? -eq 0 ] && return 1
else    
        LogPrint "${CLIENT}: Backup Succesful!"
	[ $? -eq 0 ] && return 0
fi


}


# Main

run_rear_ssh_remote $CLINAME B
