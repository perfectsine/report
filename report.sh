#!/bin/bash

# Array of usernames
team=(  )
# Array of repos/folders
repos=( )

repodirectory="/Users/psroufe/Github"

emptysummary=$(cat <<EOF
Files Changed: 
Insertions: 
Deletions: 
EOF
)

# Pull Down Latest for All Repos
# for j in "${repos[@]}"
# do
# 	cd "/Users/psroufe/Github/$j"
# 	echo "Pulling $j"
# 	git pull -q
# done
# echo

echo "#############################"
echo "##### Report Last 1 day #####"
echo "#############################"
echo
echo


ARRAY=()
ARRAY+=('DATE')

for i in "${team[@]}"
do

	echo "###############################################################"
	echo "############################ $i #############################"
	echo "###############################################################"


	for j in "${repos[@]}"
	do

		cd "/Users/psroufe/Github/$j"
		output=`git log --shortstat  --branches --remotes --tags --since=7.day.ago --author=$i --no-merges | grep changed | awk '{ SUM += $1; INS += $4; DEL += $6} END { print "Files Changed: "SUM; print "Insertions: "INS; print "Deletions: "DEL }'`
		if [ "$output" != "$emptysummary" ]; then
			echo "Summary $j"
			echo "$output"
		fi
		
	done

	for j in "${repos[@]}"
	do

		cd "/Users/psroufe/Github/$j"
		output=`git log --oneline  --branches --remotes --tags --since=7.day.ago --author=$i --no-merges | awk '{print $1}' | xargs -n1 -I '%' sh -c 'git branch -r --contains %;echo "-------------------------------------------------------------------------------";git log -1 % --stat;echo "-------------------------------------------------------------------------------";echo;echo'`
		if [ ! -z "$output" ]; then
			chrlen=$((${#j} + 58))
			echo `head -c $chrlen < /dev/zero | tr '\0' '\075'`
			echo "============================ $j ============================"
			echo `head -c $chrlen < /dev/zero | tr '\0' '\075'`
			echo "$output"
			echo
		fi
		
	done


done
