#! /bin/bash
# author: Ari Selseng
# version: v1
# USAGE: xall filename.zip directory_to_extract_to [OPTIONAL]


# Check if we got a file to extract
if [ "$1" == "" ];
	then
		echo "You have to give a file to extract."
fi

# Checks if there is a defined directory to extract to.
if [ "$2" == "" ];
	#If not, use filename (without extension)
	then
		# Setup variable with the filetype, ie: .zip
		xtype=$(echo "$1"|awk -F"." '{print $NF}');xtype=$(echo -ne ".${xtype}")
		# gets directoryname without		
		dname="$(echo "$1"|awk -v t="$xtype" '{sub(t,"");print}')"
	else
		dname="$2"	
fi

case "$1" in 
	*.zip)

		mkdir "$dname" -p
		unzip -qqo "$1" -d "$dname"
		echo " Your extracted content is now in $dname"

		;;
			
	*.tar.gz|*.tar.bz2|*.tar.xz|*.tar.lzma|*.tar)
		
		mkdir "$dname" -p
		tar xf "$1" -C "$dname"
		echo " Your extracted content is now in $dname"
		;;
		
	*.rar)
		
		mkdir "$dname" -p
		unrar x -o+ -r -y "$1" "$dname"
		echo " Your extracted content is now in $dname"		
		;;

	*)
		echo "Sorry this filetype is not supported."
		;;
esac;
