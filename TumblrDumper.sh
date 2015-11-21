blogname=$1

mkdir $blogname
cd $blogname

for archive in $(curl "http://$blogname.tumblr.com/archive" | sed 's/<\/a>/\n/g ' | grep -Eo "archive/[0-9]{4}/[0-9]*" )
do
	echo "in $archive:"
	mkdir ${archive//\//.}
	cd ${archive//\//.}
	
	for link in $(curl "http://$blogname.tumblr.com/$archive" | grep -Eo "http://$blogname.tumblr.com/post/[0-9]*")
	# verified, no matter it set a title or not
	do
		echo $link
		reallink=$(curl -Ls -o /dev/null -w %{url_effective} $link)
		# reallink=$(curl -i $link | grep 'Location' | awk -F': ' '{print $2}' | tail -1)
		# reallink=$(curl -i $link | grep "Location")
		# reallink=${reallink//Location:/}
		reallink=${reallink//#_=_/}
		if [ -z "${reallink##*/}" ]
		then
			post=$reallink
		else
			post=${reallink##*/}
		fi
		mkdir $post
		cd $post
		
		# for image in $(curl $reallink | sed 's/\/>/\n/g ' | grep -Eo "<meta property=\"og:image\" content=\"http://[0-9].*tumblr.*_1280.jpg" | sed 's/<meta property="og:image" content="//g ')
		for image in $(curl $reallink | sed 's/\/>/\n/g ' | grep -Eo "<meta property=\"og:image\" content=\".*.jpg" | sed 's/<meta property="og:image" content="//g ')
		do
			echo $image
			wget $image
		done
		
		cd ..
	done
	
	echo
	cd ..
done

cd ..
