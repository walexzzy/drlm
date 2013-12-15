# Check if the target client for backup is in DRLS client database

if test -n "$CLINAME"; then
	if exist_client_name "$CLINAME" ;	
	then
		IDCLIENT=$(get_cient_id_by_name $CLINAME)
		CLIMACADDR=$(get_client_mac $IDCLIENT)
	        CLIIPADDR=$(get_client_ip $IDCLIENT)
	else
		StopIfError "$PROGRAM: Client named: $CLINAME not registered!"
	fi
else
        if exist_client_id "$IDCLIENT" ;
        then
		CLINAME=$(get_cient_name $IDCLIENT)
        	CLIMACADDR=$(get_client_mac $IDCLIENT)
	        CLIIPADDR=$(get_client_ip $IDCLIENT)
        else
        	StopIfError "$PROGRAM: Client with ID: $IDCLIENT not registered!"
        fi

fi

# Check if client is available over the network
if check_client_connectivity "$IDCLIENT" ; 
then
	LogPrint "Client $CLINAME is online!"
else
	StopIfError "Client $CLINAME is not online! aborting..." 
fi


# Check if client  SSH Server is available over the network
if check_client_ssh "$IDCLIENT" ; 
then
	LogPrint "Client $CLINAME SSH Server is online!"
else
	StopIfError "Client $CLINAME SSH Server is not online! aborting..." 
fi
