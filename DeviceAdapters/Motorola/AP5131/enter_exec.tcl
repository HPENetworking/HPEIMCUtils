set IGNORE_DELAY true

set loop true
set timeout $standard_timeout

while {$loop == "true"} {
        expect {
                $password_prompt {
                                send "$password"
                                sleep 1
                                send "\r\r"
                }  $username_prompt {
                                send "$username"
                                sleep 1
                                send "\r"
                }  $login_as {
                                send "$username"
                                sleep 1
                                send "\r"
                }  $info_prompt {
                                send "\r"
                }  -re $exec_prompt {
                        set loop false
                } "Login incorrect" {
                        set ERROR_MESSAGE "Authentication failed"
                        set ERROR_RESULT true
                        return
                }
          }
}

set IGNORE_DELAY false
