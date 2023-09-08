#!/usr/bin/env bash
projectPath=$(pwd)

echo "作用：打包并上传到蒲公英(所有包都可以切环境)"

read -r -p "Platform: 1:android  2:iOS
" platform
if [ ! "$platform" ] || [[ $platform -ne 1 && $platform -ne 2 ]]; then
  echo "请输入合法的参数！"
  exit 1
fi

#read -p "Build Type: 1:Profile  2:Release
#" buildType
#if [ ! $buildType ] || [[ $buildType -ne 1 && $buildType -ne 2 ]]; then
#  echo "请输入合法的参数！"
#  exit 1
#fi

read -r -p "是否重新build: 1:是  2:否
" rebuild
if [ ! "$rebuild" ] || [[ $rebuild -ne 1 && $rebuild -ne 2 ]]; then
  echo "请输入合法的参数！"
  exit 1
elif [ "$rebuild" = 1 ]; then # rebuild的情况下才需要输入版本号
  read -r -p "构建说明, 直接回车跳过:
  " description

  read -r -p "请输入三位versionName(x.y.z), 直接回车使用默认值:
    " versionName

  read -r -p "请输入versionCode, 直接回车使用默认值:
    " versionCode
fi

function buildAndroid() {
  cmd="flutter build apk --dart-define=DEBUG_MODE=true --target-platform=android-arm,android-arm64 -v"
  if [[ $versionName && $versionCode ]]; then
    cmd="$cmd --build-name $versionName --build-number $versionCode"
  fi
#  if [ $buildType = 1 ]; then
#    cmd="$cmd --profile"
#  else
    cmd="$cmd --release"
#  fi
  eval "$cmd"

  if [ "$?" -ne 0 ]; then
    echo "构建失败"
    exit 1
  fi
  echo "构建成功"
}

function buildIOS() {
  cmd="flutter build ipa -v --dart-define=DEBUG_MODE=true --export-method=development"
  if [[ $versionName && $versionCode ]]; then
    cmd="$cmd --build-name $versionName --build-number $versionCode"
  fi
#  if [ $buildType = 1 ]; then
#    cmd="$cmd --profile"
#  else
    cmd="$cmd --release"
#  fi
  eval "$cmd"
#  xcodebuild -exportArchive -archivePath build/ios/archive/Runner.xcarchive -exportPath build/ios/ipa/ -exportOptionsPlist ios/export_adhoc.plist -allowProvisioningUpdates

  if [ "$?" -ne 0 ]; then
    echo "构建失败"
    exit 1
  fi
  echo "构建成功"
}

if [ "$rebuild" = 1 ]; then
  if [ "$platform" = 1 ]; then
    buildAndroid
  else
    buildIOS
  fi
fi

file=""
if [ "$platform" = 1 ]; then    # android
#  if [ "$buildType" = 1 ]; then # debug
#    file="$projectPath/build/app/outputs/apk/profile/app-profile.apk"
#  else # release
    file="$projectPath/build/app/outputs/apk/release/app-release.apk"
#  fi
else # ios
  file="$projectPath/build/ios/ipa/Holley.ipa"
fi

if [ -f "$file" ]; then
  ./ci/pgy_upload.sh "$file" "$description"
else
  echo "构建包不存在！"
  exit 1
fi
