#!/bin/bash
#
# $1: dir for original miui app 
# $2: dir for target miui app
#

XMLMERGYTOOL=$PORT_ROOT/tools/ResValuesModify/jar/ResValuesModify
GIT_APPLY=$PORT_ROOT/tools/git.apply

curdir=`pwd`

function appendPart() {
    for file in `find $1/smali -name *.part`
    do
		filepath=`dirname $file`
		filename=`basename $file .part`
		dstfile="out/$filepath/$filename"
        cat $file >> $dstfile
    done
}

if [ $1 = "Settings" ];then
    cp $1/*.part out/
    cd out
    $GIT_APPLY Settings.part
    cd ..
    for file in `find $2 -name *.rej`
    do
	echo "Fatal error: Settings patch fail"
        exit 1
    done

	$XMLMERGYTOOL $1/res/values $2/res/values
fi

if [ $1 = "Mms" ];then
    cp $1/*.part out/
    cd out
    $GIT_APPLY Mms.part
    cd ..
    for file in `find $2 -name *.rej`
    do
	echo "Fatal error: Mms patch fail"
        exit 1
    done

	$XMLMERGYTOOL $1/res/values $2/res/values
fi

if [ $1 = "Phone" ];then
	$XMLMERGYTOOL $1/res/values $2/res/values
fi

if [ $1 = "ThemeManager" ];then
#    cp other/ThemeManager.part out/
#    cd out
#    $GIT_APPLY ThemeManager.part
#    cd ..
#    for file in `find $2 -name *.rej`
#    do
#	echo "Fatal error: ThemeManager patch fail"
#        exit 1
#    done
#
    $XMLMERGYTOOL $1/res/values $2/res/values
fi

if [ $1 = "MiuiHome" ];then
    cp $1/*.part out/
    cd out
    $GIT_APPLY MiuiHome.part
    cd ..
    for file in `find $2 -name *.rej`
    do
	echo "Fatal error: MiuiHome patch fail"
        exit 1
    done

    $XMLMERGYTOOL $1/res/values $2/res/values
fi

if [ $1 = "MiuiSystemUI" ];then
    $XMLMERGYTOOL $1/res/values $2/res/values
    appendPart $1
fi

if [ $1 = "Music" ];then
#    mkdir -p $1
#    mkdir -p $2/res/raw-xhdpi/
#	cp $1/res/raw-xhdpi/* $2/res/raw-xhdpi/
#
    $XMLMERGYTOOL $1/res/values-xhdpi $2/res/values-xhdpi
	sed -i 's#@string/app_class#com.miui.player.Application#g' $2/AndroidManifest.xml
fi

if [ $1 = "Contacts" ];then
    $XMLMERGYTOOL $1/res/values-xhdpi $2/res/values-xhdpi
fi

if [ $1 = "DeskClock" ];then
    $XMLMERGYTOOL $1/res/values-xhdpi $2/res/values-xhdpi
fi
