#!/bin/bash
if [ $UID -ne 0 ]
then
	echo "This Script Can only be run as root"
	exit 1
fi


choice=$(whiptail --title "Main Menu" --menu "Choose an option" 25 78 16 \
"Add User" "Add a user to the system." \
"Modify User" "Modify an existing user." \
"List Users" "List all users on the system." \
"Add Group" "Add a user group to the system." \
"Modify Group" "Modify a group and its list of members." \
"Delete Group" "Delete an existing group" \
"list Groups" "List all groups om the system" \
"Disable User" "Lock the user account" \
"Enable User" "Unlock user account" \
"Change Password" "Change Password of a user" \
"About" "Information about this program" \
"Exit" "Exit the program" \
3>&1 1>&2 2>&3
)

echo your choice is $choice

case $choice in
	"Add User")
		usr_name=$(whiptail --inputbox "Enter Username" 8 39 --title "User Add" 3>&1 1>&2 2>&3)
		echo $usr_name
		id $usr_name &>/dev/null
		while [ $? -eq 0 ]
		do
			whiptail --title "Add User" --msgbox "User Exists. You must hit OK to continue."  8 78
			usr_name=$(whiptail --inputbox "Enter Username" 8 39 --title "User Add" 3>&1 1>&2 2>&3)
			id $usr_name &>/dev/null
		done
		choice_add_user=$(whiptail --title "Add User" --menu "Choose an option" 25 78 16 \
		"Default Settings" "Add a user to the system Using default Options." \
		"Custom" "Add a user using Customized Options" \
		"Change Default Settings" "Change default User Creation" \
		3>&1 1>&2 2>&3
		)
		case $choice_add_user in
			"Default Settings")
				useradd $usr_name
				whiptail --msgbox "User Added successfully." 8 50
				echo "Added Successfully"
			;;
			"Custom")
				grp_name=$(whiptail --inputbox "Enter Group (optional, leave blank to skip):" 8 50 3>&1 1>&2 2>&3) || exit
				home_dir=$(whiptail --inputbox "Enter Home Directory (optional, leave blank for default):" 8 50 3>&1 1>&2 2>&3) || exit
				shell_usr=$(whiptail --inputbox "Enter Shell type (optional, leave blank for default):" 8 50 3>&1 1>&2 2>&3) || exit
				comment_usr=$(whiptail --inputbox "Enter comment  (optional, leave blank for default):" 8 50 3>&1 1>&2 2>&3) || exit
				whiptail --yesno "Do you want to create the home directory?" 8 50
				create_home=$?
				cmd="useradd "
				if [  $grp_name  ]
				then
					cmd+=" -g $grp_name"
				fi
                                if [  $home_dir  ]
                                then
                                        cmd+=" -d $home_dir"
                                fi
                                if [  $shell_usr  ]
                                then
                                        cmd+=" -s $shell_usr"
                                fi
				if [ "$comment_usr"  ]
                                then
                                        cmd+=" -c \"$comment_usr\""
                                fi
                                if [  $create_home -eq 0  ]
                                then
                                        cmd+=" -m"
                                fi
				cmd+="  $usr_name"
				full_command="${cmd}"
				if whiptail --yesno "Run the following command?\n$full_command" 15 60
				then
					eval "${cmd}"
					whiptail --msgbox "User Added successfully." 8 50
				else
                                        whiptail --msgbox "Operation Cancelled" 8 50
				fi
			;;
			"Change Default Settings")
                                 base_dir=$(whiptail --inputbox "Enter new user's home directory name (optional, leave blank to skip):" 8 50 3>&1 1>&2 2>&3) || exit
                                 expire_date=$(whiptail --inputbox "Enter  date on which newly created user accounts are disabled (optional, leave blank for default):" 8 50 3>&1 1>&2 2>&3) || exit
                                 shell_usr=$(whiptail --inputbox "Enter default login shell for new users (optional, leave blank for default):" 8 50 3>&1 1>&2 2>&3) || exit

                                 cmd="useradd -D "
                                 if [  $base_dir  ]
                                 then
                                         cmd+=" -b $base_dir"
                                 fi
                                 if [  $expire_date  ]
                                 then
                                         cmd+=" -e $expire_date"
                                 fi
                                 if [  $shell_usr  ]
                                 then
                                         cmd+=" -s $shell_usr"
                                 fi
                                 full_command="${cmd}"
                                 if whiptail --yesno "Run the following command?\n$full_command" 15 60
                                 then
                                        eval "${cmd}"
                                        whiptail --msgbox "Default Settings Changed Successfully." 8 50
                                 else
                                         whiptail --msgbox "Operation Cancelled" 8 50
				 fi
                                 if whiptail --yesno "Create User \n $usr_name " 15 60
                                 then
                                        eval "${cmd}"
                                        useradd $usr_name
                                        whiptail --msgbox "User added successfully." 8 50
                                 else
                                         whiptail --msgbox "Operation Cancelled" 8 50
                                 fi

                        ;;
			*)
				echo "invalid Options"
			;;
		esac
	;;
	"Modify User")
                usr_name=$(whiptail --inputbox "Enter Username" 8 39 --title "User Modify" 3>&1 1>&2 2>&3)
                echo $usr_name
                id $usr_name &>/dev/null
                while [ $? -ne 0 ]
                do
                        whiptail --title "User Modify" --msgbox "User doesn't Exists. You must hit OK to continue."  8 78
                        usr_name=$(whiptail --inputbox "Enter Username" 8 39 --title "User Modify" 3>&1 1>&2 2>&3)
                        id $usr_name &>/dev/null
                done
                grp_name=$(whiptail --inputbox "Add the user to the supplementary group (optional, leave blank to skip):" 8 50 3>&1 1>&2 2>&3) || exit
		comment_user=$(whiptail --inputbox " update the comment field of the user (optional, leave blank to skip):" 8 50 3>&1 1>&2 2>&3) || exit
		usr_dir=$(whiptail --inputbox "Change user Login Directory (optional, leave blank to skip):" 8 50 3>&1 1>&2 2>&3) || exit
                #whiptail --yesno "Do you want to move content of current home directory to new one?" 8 50
                #move_home=$?
		shell_usr=$(whiptail --inputbox "Change User Shell (optional, leave blank to skip):" 8 50 3>&1 1>&2 2>&3) || exit
		grp_remove=$(whiptail --inputbox "Remove the user to the supplementary group (optional, leave blank to skip):" 8 50 3>&1 1>&2 2>&3) || exit
		                cmd="usermod "
                                if [  $grp_name  ]
                                then
                                    	cmd+=" -aG $grp_name"
                                fi
                                if [  "$usr_dir"  ]
                                then
                                        cmd+=" -d \"$usr_dir\""
					whiptail --yesno "Do you want to move content of current home directory to new one?" 8 50
			                move_home=$?
					if [  $move_home -eq 0  ]
	                                then
        	                            	cmd+=" -m"
                	                fi

                        	fi
                                if [  $shell_usr  ]
                                then
                                    	cmd+=" -s $shell_usr"
                                fi
                                if [ "$comment_user"  ]
                                then
                                    	cmd+=" -c \"$comment_user\""
                                fi
				if [ $grp_remove   ]
				then
					cmd+="-rG $grp_remove "
                            #    if [  $create_home -eq 0  ]
                           #     then
                          #          	cmd+=" -m"
                                fi
                                cmd+="  $usr_name"
                                full_command="${cmd}"
                                if whiptail --yesno "Run the following command?\n$full_command" 15 60
                                then
                                        eval "${cmd}"
                                        whiptail --msgbox "User Modified successfully." 8 50
                                else
                                    	whiptail --msgbox "Operation Cancelled" 8 50
                                fi

	;;
	"List Users")
		cut -d : -f1 /etc/passwd > /tmp/userlist.txt
          	whiptail --scrolltext --textbox /tmp/userlist.txt 20 60
		rm -f /tmp/userlist.txt
	;;
	"Add Group")
                grp_name=$(whiptail --inputbox "Enter Groupname" 8 39 --title "Group Add" 3>&1 1>&2 2>&3)
                grep -w "$grp_name" /etc/group &>/dev/null
                while [ $? -eq 0 ]
                do
                  	whiptail --title "Add Group" --msgbox "Group Exists. You must hit OK to continue."  8 78
                        grp_name=$(whiptail --inputbox "Enter Groupname" 8 39 --title "Group Add" 3>&1 1>&2 2>&3)
                        grep -w "$grp_name" /etc/group  &>/dev/null
                done
		let grp_uid=$(whiptail --inputbox "Enter the Group UID  (optional, leave blank to skip):" 8 50 3>&1 1>&2 2>&3) || exit
		cmd="groupadd "
		if [  $grp_uid  ]
                then
                	cmd+=" --gid $grp_uid"
                fi
		cmd+="  $grp_name"
                full_command="${cmd}"
                if whiptail --yesno "Run the following command?\n$full_command" 15 60
                then
                        eval "${cmd}"
                	whiptail --msgbox "Group Added successfully." 8 50
                else
                	whiptail --msgbox "Operation Cancelled" 8 50
                fi
	;;
	"Modify Group")
                grp_name=$(whiptail --inputbox "Enter Groupname" 8 39 --title "Group Modify" 3>&1 1>&2 2>&3)
                grep -w "$grp_name" /etc/group &>/dev/null
                while [ $? -ne 0  ]
                do
                  	whiptail --title "Modify Group" --msgbox "Group doesn't Exist. You must hit OK to continue."  8 78
                        grp_name=$(whiptail --inputbox "Enter Groupname" 8 39 --title "Group Add" 3>&1 1>&2 2>&3)
                        grep -w "$grp_name" /etc/group  &>/dev/null
                done
		grp_name_new=$(whiptail --inputbox "Enter the new Group name  (optional, leave blank to skip):" 8 50 3>&1 1>&2 2>&3) || exit

                let grp_uid=$(whiptail --inputbox "Enter the new Group UID  (optional, leave blank to skip):" 8 50 3>&1 1>&2 2>&3) || exit
                usr_add=$(whiptail --inputbox "Enter the users u want to add to the group sperated by ,  (optional, leave blank to skip):" 8 50 3>&1 1>&2 2>&3) || exit

		cmd="groupmod "
                if [ "$grp_name_new"  ]
                then
                    	cmd+=" -n $grp_name_new"
                fi
                if [  $grp_uid  ]
                then
                    	cmd+=" --gid $grp_uid"
                fi
                if [  "$usr_add"  ]
                then
                    	cmd+=" -a -U \"$usr_add\""
                fi
                cmd+="  $grp_name"
                full_command="${cmd}"
                if whiptail --yesno "Run the following command?\n$full_command" 15 60
                then
                    	eval "${cmd}"
                        whiptail --msgbox "Group Modified successfully." 8 50
                else
                        whiptail --msgbox "Operation Cancelled" 8 50
                fi



	;;
	"Delete Group")
		grp_name=$(whiptail --inputbox "Enter Groupname" 8 39 --title "Group Delete" 3>&1 1>&2 2>&3)
                grep -w "$grp_name" /etc/group &>/dev/null
                while [ $? -ne 0  ]
                do
                        whiptail --title "Delete Group" --msgbox "Group doesn't Exist. You must hit OK to continue."  8 78
                        grp_name=$(whiptail --inputbox "Enter Groupname" 8 39 --title "Group Delete" 3>&1 1>&2 2>&3)
                        grep -w "$grp_name" /etc/group  &>/dev/null
                done
		cmd="groupdel $grp_name"
                if whiptail --yesno "Run the following command?\n$cmd" 15 60
                then
                    	eval "${cmd}"
                        whiptail --msgbox "Group Deleted successfully." 8 50
                else
                    	whiptail --msgbox "Operation Cancelled" 8 50
                fi

	;;
	"list Groups")
		cut -d : -f1 /etc/group > /tmp/grouplist.txt
                whiptail --scrolltext --textbox /tmp/grouplist.txt 20 60
                rm -f /tmp/grouplist.txt
	;;
	"Disable User")
		usr_name=$(whiptail --inputbox "Enter Username" 8 39 --title "User Disable" 3>&1 1>&2 2>&3)
                echo $usr_name
                id $usr_name &>/dev/null
                while [ $? -ne 0 ]
                do
                  	whiptail --title "User Disable" --msgbox "User doesn't Exists. You must hit OK to continue."  8 78
                        usr_name=$(whiptail --inputbox "Enter Username" 8 39 --title "User Disable" 3>&1 1>&2 2>&3)
                        id $usr_name &>/dev/null
                done
		cmd="usermod -L -s /bin/nologin $usr_name "
                if whiptail --yesno "Run the following command?\n$cmd" 15 60
                then
                        eval "${cmd}"
                        whiptail --msgbox "User Disabled successfully." 8 50
                else
                        whiptail --msgbox "Operation Cancelled" 8 50
                fi

	;;
	"Enable User")
                usr_name=$(whiptail --inputbox "Enter Username" 8 39 --title "User Enable" 3>&1 1>&2 2>&3)
                echo $usr_name
                id $usr_name &>/dev/null
                while [ $? -ne 0 ]
                do
                        whiptail --title "User Enable" --msgbox "User doesn't Exists. You must hit OK to continue."  8 78
                        usr_name=$(whiptail --inputbox "Enter Username" 8 39 --title "User Enable" 3>&1 1>&2 2>&3)
                        id $usr_name &>/dev/null
                done
                cmd="usermod -U -s /bin/bash $usr_name "
                if whiptail --yesno "Run the following command?\n$cmd" 15 60
                then
                        eval "${cmd}"
                        whiptail --msgbox "User Enabled successfully." 8 50
                else
                        whiptail --msgbox "Operation Cancelled" 8 50
                fi

        ;;
	"Change Password")
                usr_name=$(whiptail --inputbox "Enter Username" 8 39 --title "Change Password" 3>&1 1>&2 2>&3)
                echo $usr_name
                id $usr_name &>/dev/null
                while [ $? -ne 0 ]
                do
                        whiptail --title "Change Password" --msgbox "User doesn't Exists. You must hit OK to continue."  8 78
                        usr_name=$(whiptail --inputbox "Change Password" 8 39 --title "User Enable" 3>&1 1>&2 2>&3)
                        id $usr_name &>/dev/null
                done
		pass=$(whiptail --passwordbox "please enter your secret password" 8 78 --title "password dialog" 3>&1 1>&2 2>&3)
		Confirm_pass=$(whiptail --passwordbox "please confirm your password" 8 78 --title "password dialog" 3>&1 1>&2 2>&3)
		if [ "$pass" = "$Confirm_pass" ]
		then
			echo "$pass" | passwd --stdin "$usr_name"
			whiptail --msgbox "Password Changed Successfully" 8 50

		else
			whiptail --msgbox "Passwords Don't Match,Operation Canelled" 8 50
		fi
        ;;
	"About")
		whiptail --msgbox "This is a User Administration Script \nAuthor:Abdallah Elaraby \nOrgnization: ITI\nVersion: 1.0 " 15 50
	;;
	"Exit")
		whiptail --msgbox "Thank you for using the User Administration Script.\nExiting now." 8 50
	;;
	*)
		echo "Invalid Option"
	;;
esac
