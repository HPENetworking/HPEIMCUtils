
#**************************************************************************
#Identification: deploy_running_config_cli
#Purpose:        deploy running configuration by cli.
#**************************************************************************

set timeout $very_long_timeout

foreach entry $commands {
    send "$entry\r"
    expect $exec_prompt
}

set timeout $standard_timeout