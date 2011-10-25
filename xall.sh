#! /bin/bash
# author: Ari Selseng
# version: v2, 17. september 2011
# license: GPLv2
# USAGE: xall filename.zip full_directory_structure_to_extract_to [OPTIONAL]

# creating a separate function for the logo, so it's easy to change colors and stuff
logo () { echo -e "$1"; }
logo ""
logo "               .__  .__   "
logo "___  ________  |  | |  |  "
logo "\  \/  /\__  \ |  | |  |  "
logo " >    <  / __ \|  |_|  |__"
logo "/__/\_ \(______/____/____/"
logo ""

# Checks if there is a defined directory to extract to.
if [ "$2" == "" ];
	#If not, use filename (without extension)
	then
		# gets directoryname without		
		dname="$(echo "$1"|awk '{gsub(/\.zip|\.tar\.gz|\.tgz|\.tar\.bz2|\.tar\.xz|\.tar\.lzma|\.tar|\.rar|\\/, ""); print}')"
	else
		dname="$2"	
fi

# main purpose of this is to check if the extracted content consists of one single subfolder. Then it asks if the user wants to move the files inside to the upper parent.
foldercheck () { 

	# gives us the path of the extracted folder
	dnamepath=$(cd "$dname";pwd)

	# a function to printout the content
	content () { echo -e "Here is your extracted content: \""$dnamepath"\""; ls --color "$dname";}

	# gives us the number of folders in the extracted directory
	numberoffolders=$(find "$dname" -maxdepth 1 -type d|tail -n 1|wc -l)

	# gives us the number of files in the extracted directory
	numberoffiles=$(find "$dname" -maxdepth 1 -type f|tail -n 1|wc -l)
	
	# checks if the content is only a a subfolder. Then asks to move the content inside the subfolder to the recently created dname.
	if [ "$numberoffolders" == "1" -a "$numberoffiles" == "0" ];
		then
			
			content
			echo -e "As in you can see, you have a lonely subfolder in \"$dnamepath\"";echo ""
			echo -ne "Do you want to move the files inside it to \"$dname\"? [y/n]: "
			read yno
			
			case $yno in

				[yY] | [yY][Ee][Ss] )
					# creating a string to know the soon-to-be empty subfolder that we want to remove.
					subfoldertorm=$(ls "$dname")
					#actually doing it.
					mv "$dname"/*/* "$dname"
				
					if [ $(ls -A "$dname"/"$subfoldertorm") ]; then
	     						echo "$subfoldertorm was not empty, something probably failed while trying to move the files inside it."
						else
		    					rm -r "$dname"/"$subfoldertorm"
							echo "Removed the empty $subfoldertorm"
					fi
					
					
					content
						;;

				[nN] | [n|N][O|o] )
				
					echo "OK, FINE!"
					exit 1
					;;
				*)
					echo "Invalid input"
					;;
			esac

		else
			
			content
	fi 
} 

case "$1" in 
	*.zip)
		# checks if unzip is installed
		hash unzip &> /dev/null
		if [ $? -eq 1 ]
			then
		   		echo >&2 "unzip not found"
			else
				# creates folder if neccesary
				mkdir -p "$dname"

				# The actual unzip command
				unzip -qqo "$1" -d "$dname"

				#Checks for single subfolder
				foldercheck
		fi
		;;
			
	*.tar.gz|*.tar.bz2|*.tar.xz|*.tar.lzma|*.tar|*.tgz)
		hash tar &> /dev/null
		if [ $? -eq 1 ]
			then
		   		echo >&2 "tar not found"
			else
				mkdir -p "$dname"
				tar xf "$1" -C "$dname"
				foldercheck
		fi
		;;
		
	*.rar)
		if [ $? -eq 1 ]
			then
		   		echo >&2 "unrar not found"
			else
				mkdir -p "$dname"
				unrar x -o+ -r -y "$1" "$dname"
				foldercheck
		fi
		;;

	*)

		# Check if we got a file to extract
		if [ "$1" == "" ];
			then
				echo "You'll have to provide a supported file to do something."
			else
				echo "Please provide a supported file to extract."		
		fi

		;;
esac;
