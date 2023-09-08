#!/usr/bin/env bash
buildType=$1
versionName=$2
versionCode=$3
releaseNotes=$4
branch=$5

projectPath=$(dirname "$PWD")

# branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')
buildUpdateDescription="branch:${branch} buildType:${buildType} releaseNotes:${releaseNotes}"
echo "-------------------------------- buildUpdateDescription: $buildUpdateDescription --------------------------------"

gitVersion=$(git rev-parse HEAD)
echo "-------------------------------- gitVersion: $gitVersion"

if [ $buildType == "debug" ];then
apkPath="$projectPath/build/app/outputs/apk/release/app-release.apk"
#apkPath="$projectPath/build/app/outputs/apk/debug/app-debug.apk"
if [ -f "$apkPath" ];then
rm -f $apkPath
fi
#flutter build apk --debug --build-number $versionCode --build-name $versionName --dart-define=DEBUG_MODE=true --target-platform=android-arm64 -v
flutter build apk --release --build-number $versionCode --build-name $versionName --dart-define=DEBUG_MODE=true --dart-define=GIT_VERSION=$gitVersion -v
if [ -f "$apkPath" ];then
./pgy_upload.sh $apkPath "$buildUpdateDescription"
# curl -O -F "file=@${apkPath}" -F '_api_key=f81f472078152a37cdcd1f56f8697147'  -F "buildUpdateDescription=${buildUpdateDescription}" https://www.pgyer.com/apiv2/app/upload
fi
elif [ $buildType == "release" ];then
apkPath="$projectPath/build/app/outputs/apk/release/app-release.apk"
if [ -f "$apkPath" ];then
rm -f $apkPath
fi
flutter build apk --release --build-number $versionCode --build-name $versionName --dart-define=DEBUG_MODE=false -v
if [ -f "$apkPath" ];then
./pgy_upload.sh $apkPath "$buildUpdateDescription"
# curl -O -F "file=@${apkPath}" -F '_api_key=f81f472078152a37cdcd1f56f8697147' -F "buildUpdateDescription=${buildUpdateDescription}" https://www.pgyer.com/apiv2/app/upload
fi
else
#python3 $projectPath/packageGP.py $versionCode $versionName
#package="sg.partying.yougo.android"
#bundlePath="$projectPath/build/app/outputs/bundle/release/app-release.aab"
#cd $projectPath/ci/upload_gp
#python3 upload_apks_with_listing.py $package $bundlePath $versionName "$releaseNotes"
#cd $projectPath
cd $projectPath
flutter clean
bundlePath="$projectPath/build/app/outputs/bundle/release/app-release.aab"
cd $projectPath
#python3 packageGP.py $versionCode $versionName
python3 packagetGPPack.py $versionCode $versionName
#mv $bundlePath $projectPath/build/app/outputs/bundle/alloo_$versionName.aab
package="sg.partying.yougo.android"
#uploadPath="$projectPath/build/app/outputs/bundle/alloo_$versionName.aab"
#releaseNotesLans="en-SG,en-AU,en-CA,en-GB,en-IN,en-US,en-ZA,ar,id,ko-KR,ms,ms-MY,th,tr-TR,vi,zh-TW,zh-CN,zh-HK"
releaseNotesLans="id,zh-CN"
chmod +x ./ci/gumdrop_gp_upload
./ci/gumdrop_gp_upload -p $package -bf "$bundlePath" -lan "$releaseNotesLans" -rn "$releaseNotes" -vc $versionCode -vr $versionName
#    cd $projectPath/ci/upload_gp
#    python3 upload_apks_with_listing.py $package $uploadPath $versionName "$releaseNotes"
cd $projectPath
fi

