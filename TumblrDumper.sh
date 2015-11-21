blogname=$1

mkdir $blogname
cd $blogname

for archive in $(curl "http://$blogname.tumblr.com/archive" | sed 's/<\/li>/\n/g ' | grep -Eo "archive/[0-9]{4}/[0-9]*" )
do
	echo "in $archive: "
	mkdir ${archive//\//.}
	cd ${archive//\//.}

	for link in $(curl "http://$blogname.tumblr.com/$archive" | grep -Eo "post/[0-9]*.*\"><div" | sed 's/"><div/\n/g ')
	do
		echo "    in $link: "
		mkdir ${link##*/}
		cd ${link##*/}

		for image in $(curl http://$blogname.tumblr.com/$link | sed 's/\/>/\n/g ' | grep -Eo "<meta property=\"og:image\" content=\".*.jpg" | sed 's/<meta property="og:image" content="//g ')
		do
			echo "        $image"
			wget $image
		done

		echo
		cd ..
	done
	
	echo
	cd ..
done 2> /dev/null
