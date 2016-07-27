blogname=$1

op=$2

mkdir $blogname
cd $blogname

time="6666666666666666666666666666666666666666666666666666666666666666"
current_folder=$(pwd)

until [ -z $time ]
do
	echo "in posts before $time: "

	# for link in $(curl "http://$blogname.tumblr.com/archive?before_time=$time" | sed 's/ /./g ' | grep -Eo "(post/[0-9]*.*\"><div|<h2.class=\"date\">.*</h2>)" | sed 's/"><div/\n/g ')
	# for link in $(wget "http://$blogname.tumblr.com/archive?before_time=$time" -O - | sed 's/ /./g ' | grep -Eo "(post/[0-9]*.*\"><div|<h2.class=\"date\">.*</h2>)" | sed 's/"><div/\n/g ')
	for link in $(wget "http://$blogname.tumblr.com/archive?before_time=$time" -O - | sed 's/ /./g ' | grep -Eo "(post/[0-9]*.*\"..data|<h2.class=\"date\">.*</h2>)" | sed 's/"..data/\n/g ')
	do
		if [ -z "$(echo $link | grep "<h2.class=\"date\">.*</h2>")" ]
		then
			echo "    in $link: "
			singlepost=${link#post\/}
			singlepost=${singlepost//\//.}
			if [ "$op" == "-c" ]
			then
				if [ -d $singlepost ]
				then
					echo "It seemed to meet the already-downloaded files. the script will stop. "
					exit
				fi
			fi
			mkdir $singlepost
			cd $singlepost
			# video=$(curl "http://$blogname.tumblr.com/$link" | hxclean | hxselect ".video" | grep -Eo "https://www.tumblr.com/video/.*\" style=" | sed 's/" style=//g ')
			# video=$(curl "http://ero-cosplay.tumblr.com/post/137817810418" | hxclean | hxselect ".video" | grep -Eo "https://www.tumblr.com/video/.*\" style=" | sed 's/" style=//g ')
			
			# for video in $(curl "http://$blogname.tumblr.com/$link" | sed 's/<\/div>/\n/g ' | grep -Eo "https://www.tumblr.com/video/.* style=" | sed 's/" style=//g ' | sed "s/' style=//g ")
			for video in $(wget "http://$blogname.tumblr.com/$link" -O - | sed 's/<\/div>/\n/g ' | grep -Eo "https://www.tumblr.com/video/.* style=" | sed 's/" style=//g ' | sed "s/' style=//g ")
			do
				videolink=$(curl $video | grep "source" | grep -Eo "src=.* " | sed 's/src=//g ' | sed 's/ //g ' | sed 's/"//g ' | sed "s/'//g ")			
				filename=${videolink##*/}
				echo "        [VIDEO] detected: $videolink"
				wget -O "$filename.mp4" $videolink
			done
			
			# for image in $(curl http://$blogname.tumblr.com/$link | sed 's/\/>/\n/g ' | grep -Eo "<meta property=\"og:image\" content=\".*\"" | sed 's/<meta property="og:image" content="//g ' | sed 's/"//g ' )
			for image in $(wget http://$blogname.tumblr.com/$link -O - | sed 's/\/>/\n/g ' | grep -Eo "<meta property=\"og:image\" content=\".*\"" | sed 's/<meta property="og:image" content="//g ' | sed 's/"//g ' )
			do
				echo "        $image"
				wget $image
			done

			echo
			cd ..
		else
			folder=${link#<h2.class=\"date\">}
			folder=${folder%<\/h2>}
			echo "photos will be stored in: $folder"
			mkdir "$current_folder/$folder"
			cd "$current_folder/$folder"
		fi
	done
	
	echo
	time=$(curl "http://$blogname.tumblr.com/archive?before_time=$time" | grep -Eo "<a id=\"next_page_link\" href=\"\/archive\?before_time=[0-9]*\">" | grep -Eo "[0-9]*" )
done 2> /dev/null
