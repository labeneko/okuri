now=`TZ=Asia/Tokyo date '+%Y%m%d%H%M'`
year=`TZ=Asia/Tokyo date '+%Y'`
month=`TZ=Asia/Tokyo date '+%m'`
date=`TZ=Asia/Tokyo date '+%d'`

reponames[0]="okuri"
urls[0]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_houon-bridge_OBS.jpg?${now}"
reponames[1]="daimaru"
urls[1]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_daimaru_dam_lower.jpg?${now}"

for i in ${!reponames[@]}
do
  reponame=${reponames[i]}
  url=${urls[i]}
  savepath="$reponame/images/$year/$month/$date/$now.jpg"
  mkdir -p "$reponame"
  mkdir -p "$reponame/images"
  mkdir -p "$reponame/images/${year}"
  mkdir -p "$reponame/images/${year}/${month}"
  mkdir -p "$reponame/images/${year}/${month}/${date}"
  curl -o $savepath $url
  jpegoptim --max=70 $savepath
  currentmd5=`md5sum $savepath | awk '{ print $1 }'`
  previousmd5=`md5sum "$reponame/latest.jpg" | awk '{ print $1 }'`
  echo $currentmd5
  echo $previousmd5
  if [[ $currentmd5 != $previousmd5 ]]; then tail -n 143 "$reponame/images/24h.txt" >> "$reponame/images/24hp.txt"; fi
  if [[ $currentmd5 != $previousmd5 ]]; then cp "$reponame/images/24hp.txt" "$reponame/images/24h.txt"; fi
  if [[ $currentmd5 != $previousmd5 ]]; then cp $savepath "$reponame/latest.jpg"; fi
  if [[ $currentmd5 != $previousmd5 ]]; then rm "$reponame/images/24hp.txt"; fi
  if [[ $currentmd5 != $previousmd5 ]]; then echo "$savepath" >> "$reponame/images/24h.txt"; fi
  if [[ $currentmd5 != $previousmd5 ]]; then echo "$savepath" >> "$reponame/images/${year}/${month}/${date}/images.txt"; fi
  if [[ $currentmd5 == $previousmd5 ]]; then rm $savepath ; fi
  aws s3 cp --region ap-northeast-1 $savepath "s3://liver-camera/${savepath}"
  aws s3 cp --region ap-northeast-1 "$reponame/latest.jpg" "s3://liver-camera/${reponame}/latest.jpg"
  aws s3 cp --region ap-northeast-1 "$reponame/images/24h.txt" "s3://liver-camera/${reponame}/images/24h.txt"
  aws s3 cp --region ap-northeast-1 "$reponame/images/${year}/${month}/${date}/images.txt" "s3://liver-camera/${reponame}/images/${year}/${month}/${date}/images.txt"
done
find ./ | grep -E "[0-9]+.jpg" | xargs rm -f
