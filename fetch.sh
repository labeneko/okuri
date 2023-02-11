now=`TZ=Asia/Tokyo date '+%Y%m%d%H%M'`
year=`TZ=Asia/Tokyo date '+%Y'`
month=`TZ=Asia/Tokyo date '+%m'`
date=`TZ=Asia/Tokyo date '+%d'`
reponame="okuri"
savepath="$reponame/images/$year/$month/$date/$now.jpg"
url="https://www.ktr.mlit.go.jp/keihin/webcam/cam_houon-bridge_OBS.jpg?${now}"
mkdir -p "$reponame"
mkdir -p "$reponame/images"
mkdir -p "$reponame/images/${year}"
mkdir -p "$reponame/images/${year}/${month}"
mkdir -p "$reponame/images/${year}/${month}/${date}"
curl -o $savepath $url
jpegoptim --max=70 $savepath
currentmd5=`md5sum $savepath | awk '{ print $1 }'`
previousmd5=`md5sum latest.jpg | awk '{ print $1 }'`
echo $currentmd5
echo $previousmd5
if [[ $currentmd5 != $previousmd5 ]]; then tail -n 143 images/24h.txt >> images/24hp.txt; fi
if [[ $currentmd5 != $previousmd5 ]]; then cp images/24hp.txt images/24h.txt; fi
if [[ $currentmd5 != $previousmd5 ]]; then cp $savepath latest.jpg; fi
if [[ $currentmd5 != $previousmd5 ]]; then rm images/24hp.txt; fi
if [[ $currentmd5 != $previousmd5 ]]; then echo "okuri/$savepath" >> "images/24h.txt"; fi
if [[ $currentmd5 != $previousmd5 ]]; then echo "okuri/$savepath" >> "images/${year}/${month}/${date}/images.txt"; fi
if [[ $currentmd5 == $previousmd5 ]]; then rm $savepath ; fi
aws s3 cp --region ap-northeast-1 $savepath "s3://liver-camera/${reponame}/${savepath}"
aws s3 cp --region ap-northeast-1 latest.jpg "s3://liver-camera/${reponame}/latest.jpg"
aws s3 cp --region ap-northeast-1 images/24h.txt "s3://liver-camera/${reponame}/images/24h.txt"
aws s3 cp --region ap-northeast-1 images/${year}/${month}/${date}/images.txt "s3://liver-camera/${reponame}/images/${year}/${month}/${date}/images.txt"
find ./ | grep -E "[0-9]+.jpg" | xargs rm -f