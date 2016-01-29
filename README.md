# TumblrDumper
A script to dump all photos of a Tumblr site via its archive system

借助归档系统拖Tumblr站点所有照片的脚本


just execute TumblrDumper.sh <sitename>, and it'll dump all photos of sitename.tumblr.com and store them in /month.year/tid.title (tid if no title) directories

只需执行TumblrDumper.sh <sitename>，就可以将sitename.tumblr.com上面所有的照片拖下来，并存放在/month.year/tid.title（如果没设置标题的话就是tid）目录里

now can just update the local dumps instead of re-dumpin' everythin' when new photos release

现在可以只更新那些新出的照片，而不用把所有照片都下一遍

now can download videos too

现在视频也能下了

Known Issue: for some sites containin' little posts, next page of the first page (timed 66666666666666666) may still contains the lastest posts, and will stop the script too fuckin' soon. so NOT RECOMMENDED to use continuity option (follow -c after sitename) on first complete dump, and for the same reason the continuity of more than one page becomes nasty, recommended to write some cronjobs to dump in every fuckin' hour

已知的问题：对于帖子较少的站点，第一页（时间是66666666666666666）后的下一页可能还是最新的帖子，这将导致断点续传功能提前结束掉脚本。所以不推荐在初次下载时开启断点续传选项（站点名称后面跟-c），同理超过一页的断点续传非常恶心，建议写个cronjob，每几个小时执行一次

tested on: 

在下述站点上面测试通过：


http://wanimal-1983.tumblr.com/

http://wanimal1983.tumblr.com/

http://babes-with-glasses.tumblr.com/

http://girlsgeeksandglasses.tumblr.com/

http://sexy-shorthair.tumblr.com/

http://ero-cosplay.tumblr.com/

http://erocosplaygirl.tumblr.com/
