#!/bin/bash
action="$1"
case $action in
addTeam)
     team=$2
	if grep -q "^$team:" /etc/group; then
           echo "Group $team already exists."
        exit 1
        
        else
	    sudo groupadd "$team"
	    grep  "^$team:" /etc/group | cat >> /home/afzal/script_group
            echo "Group $team created successfully."
	fi
        ;;
        
addUser)		
      user=$2
      team=$3
        if grep -q "^$user:" /etc/passwd; then
           echo "User $user already exists."
           
        else
	if [ -z "$3" ]; then
           echo "No team name provided. Please provide a valid team name."
	
	else	
        if grep -q "^$team:" /etc/group; then
           sudo useradd -m -c "ninja" -g "$team" "$user"
           sudo mkdir -p "/home/$user/team"
           sudo mkdir -p "/home/$user/ninja"
           sudo chown "$user:$team" "/home/$user"
           sudo chown "$user:$team" "/home/$user/ninja"
           sudo chown "$user:$team" "/home/$user/team"
           sudo chmod 751 "/home/$user"
           sudo chmod 770 "/home/$user/team"
           sudo chmod 777 "/home/$user/ninja"
           echo "User $user created successfully and added to group $team"
           
        else
          echo "Group $team doesn't exist. Please create the group first."
          
        fi
      fi
    fi
    ;;
    
delUser)
      user=$2
	if grep -q "^$user:" /etc/passwd; then
           sudo userdel -r "$user"
	   echo "User $user deleted successfully."
	   
        else
	   echo "User $user does not exists."
	fi
    ;;
    
changePasswd)
      user=$2
        if grep -q "^$user:" /etc/passwd; then
           sudo passwd "$user"
           echo "Password changed successfully for user $user"
           
        else
           echo "User $user does not exist."
        fi
     ;;
     
delTeam)
      team=$2
        if grep -q "^$team:" /etc/group; then
           sudo groupdel "$team"
           sed -i "/$team:/d" /home/afzal/script_group
           echo "Group $team deleted successfully."
           
       else
           echo "Group $team does not exist."
       fi
     ;;
     
changeShell)
      user=$2
      shell=$3
        if [ -z "$2" ]; then
           echo " shell not provided. Please provide a valid team name."
   else
        if grep -q "^$user:" /etc/passwd; then
           sudo chsh -s "$shell" "$user"
           echo "Shell changed successfully for user $user"
           
        else
           echo "User $user does not exist."
        fi
      fi
      ;;
     
ls)
      entity=$2
        if [ "$entity" = "User" ]; then
           grep ninja /etc/passwd
           
        elif [ "$entity" = "Team" ]; then
           cat /home/afzal/script_group
           
        else
           echo "Invalid entity. Please specify 'User' or 'Team' to list."
        fi
     ;;
     
*)
         echo "Invalid action: Use action addTeam, addUser, delTeam, delUser, changePasswd, changeShell and ls"
        exit 1
     ;;
esac
