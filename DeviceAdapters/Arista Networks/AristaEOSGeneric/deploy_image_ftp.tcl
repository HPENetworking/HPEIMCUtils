
#**************************************************************************
# Identification:updateimage_cli
# Purpose:       updateimage_cli
#**************************************************************************

	set timeout $very_long_timeout
	set WARNING_RESULT true
	
	set pos_ [string first ".tar" $TFTPFile]
	if {$pos_ != -1} {
		set my_cmd "archive download-sw /overwrite ftp://$FTPUser:$FTPPassword@$TFTPServer/$TFTPFile"
    send "$my_cmd\r"
    set loop true
    while {$loop == "true"} {
    	expect {
    		-re "Error" {
    			set loop false
    			expect $enable_prompt
    			set ERROR_RESULT true
					set ERROR_MESSAGE "Could not copy image from FTP server. Incomplete command reported by device."
					return
    		} -re "ERROR" {
    			set loop false
    			expect $enable_prompt
    			set ERROR_RESULT true
					set ERROR_MESSAGE "Could not copy image from FTP server. Incomplete command reported by device."
					return
    		} -re "All software images installed" {
    			set loop false
    			expect $enable_prompt
					return
    		}
    	}
    }
	} else {
	if {$transfer_protocol == "scp"} {
		send "copy scp://$TFTPServer/$TFTPFile $slot\r"
		set loop true
		while {$loop == "true"} {
			expect {
				"ource username" {
					send "$scp_username\r"
				} "estination filename" {
					send "$slot$DestTFTPFile\r"
				} "file already existing" {
					set loop false
					return
				} "ource filename" {
					send "$TFTPFile\r"
				} "ddress or name of remote host" {
					send "$TFTPServer\r"
				} "assword:" {
					send "$scp_password\r"
				} $enable_prompt {
					set loop false
				} -re "(%Error.*)" {
					set plugin $expect_out(1,string)
					set ERROR_RESULT true
					set ERROR_MESSAGE $plugin
					set loop false
					return
				} -re "(%Warning.*)" {
					set plugin $expect_out(1,string)
					set ERROR_RESULT true
					set ERROR_MESSAGE $plugin
					set loop flase
					return
                } -re "(% ?invalid.*)" {
                        set plugin $expect_out(1,string)
                        set ERROR_RESULT true
                        set ERROR_MESSAGE $plugin
                        set loop false
                        return
				} "confirm]" {
					send "n"
				} "]?" {
					send "\r"
				}
			}
		} 
	} 
	
	if {$transfer_protocol == "ftp"} {
		if {$FTPUser == "" || $FTPUser == "\x24FTPUser"} {
			send "copy ftp://$TFTPServer/$TFTPFile $slot\r"
		} else {
			send "copy ftp://$FTPUser:$FTPPassword@$TFTPServer/$TFTPFile $slot\r"
		}
		set loop true
		while {$loop == "true"} {
			expect {
				"Address or name of remote host" {
					send "$TFTPServer\r"
				} "Source filename" {
					send "$TFTPFile\r"
				} "Destination filename" {
					send "$slot$DestTFTPFile\r"
				} -re "rase.*before copying" {
					if {$cannotSqueeze == "true"} {
						send "\r"
						expect "confirm"
						send "\r"
					} else {
						send "n"
					}
				} "file already existing" {
					set loop false
					return
				} -re "(%Error.*)" {
					set plugin $expect_out(1,string)
					set ERROR_RESULT true
					set ERROR_MESSAGE $plugin
					set loop false
					return
				} -re "(%Warning.*)" {
					set plugin $expect_out(1,string)
					set ERROR_RESULT true
					set ERROR_MESSAGE $plugin
					set loop false
					return
				} $enable_prompt {
					set loop false
				}
			}
		}
	} 

	if {$transfer_protocol == "tftp" || $transfer_protocol == "\x24transfer_protocol"} {
		send "copy tftp://$TFTPServer/$TFTPFile $slot\r"
    	expect {
		# ERRORS 
		"% Incomplete" {
			set ERROR_RESULT true
			set ERROR_MESSAGE "Could not copy image from TFTP server. Incomplete command reported by device."
			expect $enable_prompt
		} "%Error" {
			set ERROR_RESULT true
			set ERROR_MESSAGE "Could not copy image from TFTP server. An error occurred on the device."
			expect $enable_prompt
		# 1700, 2600, 3500XL, 3550, 3640, 5000 RSM, 7200 
                        } -re "(% ?invalid.*)" {
                                set plugin $expect_out(1,string)
                                set ERROR_RESULT true
                                set ERROR_MESSAGE $plugin
                                expect $enable_prompt
    	} "estination filename" {
    		send "$slot$DestTFTPFile\r"
    		expect {
    			-re "rase.*before copying" {
                    if { $cannotSqueeze == "true" } {
                        send "\r"
                        expect "confirm"
                        send "\r"
                    } else {
    				    send "n"
                    }
    				expect {
		                "bytes copied" {
							expect $enable_prompt
		                } -re "Error (.*)" {
							set error $expect_out(1,string)
		                    set ERROR_MESSAGE "An error occurred: $error"
		                    set ERROR_RESULT true
		                    expect $enable_prompt
		                } $enable_prompt {
		                }
    				}
				# %Warning:There is a file already existing with this name 
    			} "%Warning: File not a valid executable for this system" {
			expect "Abort Copy?"
			send "\r"
			expect $enable_prompt
			set ERROR_RESULT true
			set ERROR_MESSAGE "File not a valid executable for this system"
			#exit
		} "over write?" {
    				send "y"
                    expect {
            			"bytes copied" {
        					expect $enable_prompt
        				} -re "%Warning: (.*)" {
        					set error $expect_out(1,string)
        					set ERROR_MESSAGE "Could not deploy software image to this device: $error"
        					expect {
        						"Abort" {
        							send "\r"
        							expect $enable_prompt
        						} $enable_prompt {
        						}
        					}
                        } -re "Error (.*)" {
        						set error $expect_out(1,string)
                                set ERROR_MESSAGE "An error occurred: $error"
                                set ERROR_RESULT true
                                expect $enable_prompt
                        } $enable_prompt {
                        }
                    }
    			} "file already existing" {
					set loop false
					return
				} "bytes copied" {
					expect $enable_prompt
				} -re "%Warning: (.*)" {
					set error $expect_out(1,string)
					set ERROR_MESSAGE "Could not deploy software image to this device: $error"
					expect {
						"Abort" {
							send "\r"
							expect $enable_prompt
						} $enable_prompt {
						}
					}
                } -re "Error (.*)" {
						set error $expect_out(1,string)
                        set ERROR_MESSAGE "An error occurred: $error"
                        set ERROR_RESULT true
                        expect $enable_prompt
                } $enable_prompt {
                }
    		}
		# 2500; will reload after OS upgrade 
		} "Proceed?" {
			send "\r"
			expect "estination filename"
			send "\r"
			expect {
				# Errors  
				-re "%Error (.*)" {
					set error $expect_out(1,string)
					set ERROR_RESULT true
					set ERROR_MESSAGE "Could not copy TFTP file: Error $error"
					expect $enable_prompt
				} "already exist" {
					send "n"
					set ERROR_MESSAGE "The file $TFTPFile already exists on the device"
					set ERROR_RESULT true
					expect $enable_prompt
				} "confirm" {
					send "\r"
					# Device may also say ... "%Error: Image size exceeds flash size" 
				}
			}
			# Do we ever see this line after a copy tftp? 
	    	} "bytes copied" {
				expect $enable_prompt
	        } "%Destination file system is read-only" {
	            set ERROR_MESSAGE "The destination file system is read-only"
	            set ERROR_RESULT true
	            expect $enable_prompt
	        } -re "Error (.*)" {
					set error $expect_out(1,string)
	                set ERROR_MESSAGE "An error occurred: $error"
	                set ERROR_RESULT true
	                expect $enable_prompt
			} "uthorization failed" {
				set ERROR_MESSAGE "The user is not authorized to use the command copy tftp $slot"
				set ERROR_RESULT true
				expect $enable_prompt
			} -re "TFTP get operation failed:(.*)" {
				set error $expect_out(1,string)
				set ERROR_RESULT true
				set ERROR_MESSAGE "Could not copy TFTP file: $error
				expect $enable_prompt
	        } $enable_prompt {
	        }
		}
    }
	}
	set timeout $standard_timeout
    if { $ERROR_RESULT != "true" } {
		set WARNING_RESULT false
	}			
