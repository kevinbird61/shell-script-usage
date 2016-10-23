#!/bin/sh

# FIXME Is there the url is the same every day?

# wget the file from web , rename it to "weather.log"
wget -qO weather.log "http://data.gov.tw/iisi/logaccess/9914?dataUrl=http://opendata.cwb.gov.tw/govdownload?dataid=F-C0032-002&authorizationkey=rdec-key-123-45678-011121314&ndctype=XML&ndcnid=15790"

# And then we can parse the weather.log
cat weather.log | \
		awk '
		match($0,/[ ]+<locationName>[A-Za-z\/><]*/){
			# get the name of City
			{split($0,a,">")}
			{split(a[2],b,"<")}
			{printf "\n%s ",b[1]}
		}
		match($0,/[ ]+<elementName>[A-Za-z\/><]*/){
			# get the elements of weather report
			{split($0,a,">")}
			{split(a[2],b,"<")}
			{printf "%s ",b[1]}
		}
		match($0,/[ ]+<startTime>[A-Za-z\/><]*/){
			# get the start time of current element
			{split($0,a,">")}
			{split(a[2],b,"<")}
			{printf "%s ",b[1]}
		}
		match($0,/[ ]+<endTime>[A-Za-z\/><]*/){
			# get the end time of current element
			{split($0,a,">")}
			{split(a[2],b,"<")}
			{printf "%s ",b[1]}
		}
		match($0,/[ ]+<parameterName>[A-Za-z\/><]*/){
			# get parameter Name
			{split($0,a,">")}
			{split(a[2],b,"<")}
			# b[1] split out white space to ,
			{split(b[1],c," ")}
			{
				if(NF >= 2){
					printf "%s",c[1]
					for(i=2;i<=NF;i++)
						printf ",%s",c[i]
				}
				else{
					printf "%s",c[1]
				}
				printf " "
			}
		}
		match($0,/[ ]+<parameterUnit>[A-Za-z\/><]*/){
			# get parameter Unit
			{split($0,a,">")}
			{split(a[2],b,"<")}
			# b[1] split out white space to ,
			{split(b[1],c," ")}
			{
				if(NF >= 2){
					printf "%s",c[1]
					for(i=2;i<=NF;i++)
						printf ",%s",c[i]
				}
				else{
					printf "%s",c[1]
				}
				printf " "
			}
		}
		match($0,/[ ]+<parameterValue>[A-Za-z\/><]*/){
			# get parameter Value
			{split($0,a,">")}
			{split(a[2],b,"<")}
			# b[1] split out white space to ,
			{split(b[1],c," ")}
			{
				if(NF >= 2){
			    	printf "%s",c[1]
					for(i=2;i<=NF;i++)
						printf ",%s",c[i]
				}
				else{
					printf "%s",c[1]
				}
				printf " "
			}
		}	
		' > format_weather.log
# Delete the weather.log
rm weather.log
# And then we can using format_weather.log
WEATHER="$(cat format_weather.log | \
	awk '
	match($1$2,/TAINANCITY/){
		print $1" " $32"C~"$19"C " $55"% " "\""$6"\""
	}
	')"
echo $WEATHER | awk '{gsub(","," ")} { print $0 }'
# End the Log.
rm format_weather.log
