#! /bin/bash
# author: Ari Selseng
# version: v1
# USAGE: xall filename.zip full_directory_structure_to_extract_to [OPTIONAL]

# creating a separate function for the logo, so it's easy to change colors and stuff
logo () { echo -e "$1"; }
logo ""
logo "               .__  .__   "
logo "___  ________  |  | |  |  "
logo "\  \/  /\__  \ |  | |  |  "
logo " >    <  / __ \|  |_|  |__"
logo "/__/\_ \(____  /____/____/"
logo "      \/     \/ "
logo ""

# Checks if there is a defined directory to extract to.
if [ "$2" == "" ];
	#If not, use filename (without extension)
	then
		# gets directoryname without		
		dname="$(echo "$1"|awk '{gsub(/\.zip|\.tar\.gz|\.tar\.bz2|\.tar\.xz|\.tar\.lzma|\.tar|\.rar/, ""); print}')"
	else
		dname="$2"	
fi

case "$1" in 
	*.zip)

		mkdir "$dname" -p
		unzip -qqo "$1" -d "$dname"
		echo "Hopefully, your extracted content is now in $dname"

		;;
			
	*.tar.gz|*.tar.bz2|*.tar.xz|*.tar.lzma|*.tar)
		
		mkdir "$dname" -p
		tar xf "$1" -C "$dname"
		echo "Hopefully, your extracted content is now in $dname"
		;;
		
	*.rar)
		
		mkdir "$dname" -p
		unrar x -o+ -r -y "$1" "$dname"
		echo "Hopefully, your extracted content is now in $dname"		
		;;

	*)

		# Check if we got a file to extract
		if [ "$1" == "" ];
			then
				echo "You'll have to provide a supported file to do something."
		fi

		# Here we check if
		if [ "$1" != "" ];
			then
				echo "Please provide a supported file to extract."
		fi

		;;
esac;
