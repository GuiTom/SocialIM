#!/usr/bin/env bash
set -e
source ios_uploader.sh

buildType=$1
versionName=$2
versionCode=$3
releaseNotes=$4
branch=$5

projectPath=$(dirname "$PWD")

function buildStore() {
    flutter pub get
    cd ..
    cd ios
    arch -x86_64 pod install --repo-update
    cd ..
    flutter build ios --release --build-number $versionCode --build-name $versionName --no-codesign
    cd ios
    fastlane ios beta
    cd ..
    cd ci
    upload_ipa $projectPath/build/ios/ipa/Runner.ipa
}

cd $projectPath
chmod +x *.sh
cd ios

# branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')
buildUpdateDescription="branch:$branch buildType:$buildType releaseNotes:$releaseNotes"
echo "-------------------------------- buildUpdateDescription: $buildUpdateDescription --------------------------------"

if [ $buildType == "debug" ]; then
    buildDir="$projectPath/ios/build"
    if [ -d "$buildDir" ]; then
        rm -rf $buildDir
    fi
    flutter build ios --profile --build-number $versionCode --build-name $versionName --dart-define=DEBUG_MODE=true
    cd ..
    cd ios
    # fastlane ios beta
    bundle exec fastlane ios beta versionName:$versionName buildNum:$versionCode changeNotes:"$releaseNotes"
    if [ -f "$buildDir/Runner.ipa" ]; then
        ../ci/pgy_upload.sh "$buildDir/Runner.ipa" "$buildUpdateDescription"
        # echo "Uploading www.pgyer.com ..."
        # curl -O -F "file=@${buildDir}/Runner.ipa" -F '_api_key=f81f472078152a37cdcd1f56f8697147' -F "buildUpdateDescription=${buildUpdateDescription}" https://www.pgyer.com/apiv2/app/upload
        # echo "www.pgyer.com upload finished."
        # cat upload
    fi
elif [ $buildType == "release" ]; then
    ipaPath="$projectPath/ios/build/Runner.ipa"
    if [ -f "$ipaPath" ]; then
        rm -f $ipaPath
    fi
    flutter build ios --release --build-number $versionCode --build-name $versionName --dart-define=DEBUG_MODE=false
    cd ..
    cd ios
    fastlane ios testflight_beta versionName:$versionName buildNum:$versionCode changeNotes:"$releaseNotes"
    # if [ -f "$ipaPath" ]; then
    #     echo "Uploading www.pgyer.com ..."
    #     curl -O -F "file=@${ipaPath}" -F '_api_key=f81f472078152a37cdcd1f56f8697147' -F "buildUpdateDescription=${releaseNotes}" https://www.pgyer.com/apiv2/app/upload
    #     echo "www.pgyer.com upload finished."
    #     cat upload
    # fi
else
    buildStore
fi
