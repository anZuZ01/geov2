#!/bin/bash

function usage() {

	echo
	echo -e "\tUsage --> bash geov2.sh option >> outputFile (Recommended)"
	echo -e "\tOptions:"
	echo
	echo -e "\t\t- csv"
	echo -e "\t\t- normal"
	echo
	echo -e "\te.g:"
	echo -e "\t\t- bash geov2.sh csv >> geo.csv"
	echo -e "\t\t- bash geov2.sh normal >> geo.txt"
	echo -e "\t\t- bash geov2.sh normal"

}

if [[ $# -ne 1 ]]
then
	
	usage
	
else

	cnt=0
	if [[ $1 == "csv" ]]
	then
		echo "IP,country,region,city,zipCode,timeZone"
	fi
	while read line
	do

		raw=`curl -s "https://api.ip2location.io/?key=B04105393E66B9D1CFA70874C8A0D6F7&ip=$line"` 2>/dev/null
		info=`echo $raw | cut -f2 -d'{' | cut -f1 -d'}'`
		cnt=$((cnt+1))
		pais=`echo $info | cut -f3 -d"," | cut -f2 -d":" | cut -f2 -d'"'`
		region=`echo $info | cut -f4 -d"," | cut -f2 -d":" | cut -f2 -d'"'`
		ciudad=`echo $info | cut -f5 -d"," | cut -f2 -d":" | cut -f2 -d'"'`
		cp=`echo $info | cut -f8 -d"," | cut -f2 -d":" | cut -f2 -d'"'`
		time=`echo $info | cut -f9 -d"," | cut -f2 -d":" | cut -f2 -d'"'`

		if [[ $1 == "normal" ]]
		then
			echo -e "$cnt. \t$line"
			if [[ $pais == '-' ]]
			then
				echo "Private IP detected"
			else
				echo "Country --> $pais"
				echo "Region --> $region"
				echo "City --> $ciudad"
				echo "ZipCode --> $cp"
				echo "TimeZone --> $time"
			fi
			echo
			echo
			
		elif [[ $1 == "csv" ]]
		then
			echo "$line,$pais,$region,$ciudad,$cp,$time"
		else
			echo
			echo -e "\tInvalid option $1"
			usage
			break
		fi
		

	done < IP.txt
	
fi
