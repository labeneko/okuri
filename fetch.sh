now=`TZ=Asia/Tokyo date '+%Y%m%d%H%M'`
year=`TZ=Asia/Tokyo date '+%Y'`
month=`TZ=Asia/Tokyo date '+%m'`
date=`TZ=Asia/Tokyo date '+%d'`

reponames[0]="okuri"
urls[0]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_houon-bridge_OBS.jpg"
reponames[1]="daimaru"
urls[1]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_daimaru_dam_lower.jpg"
reponames[2]="keihin00151"
urls[2]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_tama-river-Estuary_OBS.jpg"
reponames[3]="keihin00160"
urls[3]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_dencho_branch-office_2.jpg"
reponames[4]="keihin00161"
urls[4]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_isihara_OBS_1.jpg"
reponames[5]="keihin00169"
urls[5]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_hino-bridge_OBS.jpg"
reponames[6]="keihin00171"
urls[6]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_chofu-bridge_OBS.jpg"
reponames[7]="keihin00174"
urls[7]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_asakawa-bridge_OBS.jpg"
reponames[8]="keihin00606"
urls[8]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_nikotama_rise.jpg"
reponames[9]="keihin00654"
urls[9]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_odakyu-bridge_upper.jpg"
reponames[10]="keihin00655"
urls[10]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_sekido-bridge_lower.jpg"
reponames[11]="keihin00656"
urls[11]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_mutsumi-bridge-upper.jpg"
reponames[12]="keihin00657"
urls[12]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_takahata-bridge-upper.jpg"
reponames[13]="keihin00778"
urls[13]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_tama-river_green-office.jpg"
reponames[14]="keihin00780"
urls[14]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_tode_dock.jpg"
reponames[15]="keihin00781"
urls[15]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_dencho_upper_OBS.jpg"
reponames[16]="keihin00782"
urls[16]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_futago-bridge.jpg"
reponames[17]="keihin00783"
urls[17]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_tode_drain-pipe.jpg"
reponames[18]="keihin00784"
urls[18]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_KEIOsagamihara-line_lower.jpg"
reponames[19]="keihin00785"
urls[19]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_isihara_OBS_2.jpg"
reponames[20]="keihin00787"
urls[20]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_KEIO-line_upper.jpg"
reponames[21]="keihin00788"
urls[21]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_takahata-bridge_OBS.jpg"
reponames[22]="keihin00789"
urls[22]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_hirayama-bridge_upper.jpg"
reponames[23]="keihin00790"
urls[23]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_akatsuki-bridge_upper.jpg"
reponames[24]="keihin00791"
urls[24]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_chuo-expway_upper.jpg"
reponames[25]="keihin00792"
urls[25]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_sakaemachi_drain-pipe.jpg"
reponames[26]="keihin00793"
urls[26]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_JR-hachiko-line_bridge.jpg"
reponames[27]="keihin00794"
urls[27]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_akikawa_JCT.jpg"
reponames[28]="keihin00795"
urls[28]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_hamura-big-bridge_lower.jpg"
reponames[29]="keihin00796"
urls[29]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_naka_drain-pipe.jpg"
reponames[30]="keihin00797"
urls[30]="https://www.ktr.mlit.go.jp/keihin/webcam/cam_kusabana_drain-pipe_upper.jpg"

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
  curl -o $savepath "$url?${now}"
  jpegoptim --max=70 $savepath
  currentmd5=`md5sum $savepath | awk '{ print $1 }'`
  previousmd5=`md5sum "$reponame/latest.jpg" | awk '{ print $1 }'`
  echo $currentmd5
  echo $previousmd5

  if [[ $currentmd5 == $previousmd5 ]]; then rm $savepath ; fi
  if [[ $currentmd5 == $previousmd5 ]]; then continue ; fi

  tail -n 143 "$reponame/images/24h.txt" >> "$reponame/images/24hp.txt"
  cp "$reponame/images/24hp.txt" "$reponame/images/24h.txt"
  cp $savepath "$reponame/latest.jpg"
  rm "$reponame/images/24hp.txt"
  echo "$savepath" >> "$reponame/images/24h.txt";
  echo "$savepath" >> "$reponame/images/${year}/${month}/${date}/images.txt"
  aws s3 cp --region ap-northeast-1 $savepath "s3://liver-camera/${savepath}"
  aws s3 cp --region ap-northeast-1 "$reponame/latest.jpg" "s3://liver-camera/${reponame}/latest.jpg"
  aws s3 cp --region ap-northeast-1 "$reponame/images/24h.txt" "s3://liver-camera/${reponame}/images/24h.txt"
  aws s3 cp --region ap-northeast-1 "$reponame/images/${year}/${month}/${date}/images.txt" "s3://liver-camera/${reponame}/images/${year}/${month}/${date}/images.txt"
done
find ./ | grep -E "[0-9]+.jpg" | xargs rm -f
