blogname=$1

mkdir $blogname
cd $blogname

#for archive in $(curl "http://$blogname.tumblr.com/archive" | sed 's/<\/li>/\n/g ' | grep -Eo "archive/[0-9]{4}/[0-9]*" )
time="6666666666"
mkdir 0x6d1b
cd 0x6d1b

until [ -z $time ]
do
	echo "in posts before $time: "

	for link in $(curl "http://$blogname.tumblr.com/archive?before_time=$time" | sed 's/ /./g ' | grep -Eo "(post/[0-9]*.*\"><div|<h2.class=\"date\">.*</h2>)" | sed 's/"><div/\n/g ')
	do
		if [ -z "$(echo $link | grep "<h2.class=\"date\">.*</h2>")" ]
		then
			echo "    in $link: "
			singlepost=${link#post\/}
			singlepost=${singlepost//\//.}
			mkdir $singlepost
			cd $singlepost

			for image in $(curl http://$blogname.tumblr.com/$link | sed 's/\/>/\n/g ' | grep -Eo "<meta property=\"og:image\" content=\".*\"" | sed 's/<meta property="og:image" content="//g ' | sed 's/"//g ' )
			do
				echo "        $image"
				wget $image
			done

			echo
			cd ..
		else
			cd ..
			folder=${link#<h2.class=\"date\">}
			folder=${folder%<\/h2>}
			echo "photos will be stored in: $folder"
			mkdir $folder
			cd $folder 
		fi
	done
	
	echo
	time=$(curl "http://$blogname.tumblr.com/archive?before_time=$time" | grep -Eo "<a id=\"next_page_link\" href=\"\/archive\?before_time=[0-9]*\">" | grep -Eo "[0-9]*" )
done 2> /dev/null

cd ..
rm -rf 0x6d1b
