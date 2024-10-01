#!/bin/bash

BUILD_NAME="NicaOS"
BUILD_VARIANT="exynos8895"
DEFCONF=exynos8895-greatlte_defconfig
KERN_VER=" [greatlte]"

export LOCALVERSION=$KERN_VER
export ARCH=arm64
export CROSS_COMPILE=/workspaces/gcc-linaro-13.0.0-2022.10-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-
export ANDROID_MAJOR_VERSION=T
export ANDROID_PLATFORM_VERSION=13

make $DEFCONF
make

cp arch/arm64/boot/Image Build/Image

comp=("A.I.K" "AnyKernel" "Exit")
select comp in "${comp[@]}"
do
	case $comp in
        "A.I.K")
        	echo "Enter img's name asap bruh:"
        	read img_name
		cp -rf Build/universal/* Build/A.I.K
		mv arch/arm64/boot/Image Build/A.I.K/split_img/boot.img-zImage
		mv boot.img-dtb Build/A.I.K/split_img/boot.img-dtb
		Build/A.I.K/repackimg.sh
		# echo -n "SEANDROIDENFORCE" » Build/A.I.K/image-new.img
		mv Build/A.I.K/image-new.img Build/finished/$img_name.img
		# mv Build/A.I.K/image-new.img $CR_OUT/$img_name.img
		du -k "Build/finished/$img_name.img" | cut -f1 >sizkT
		sizkT=$(head -n 1 sizkT)
		rm -rf sizkT
		Build/A.I.K/cleanup.sh
		rm -rf Build/A.I.K/Image
		rm -rf Build/Image
		break
	;;
	"AnyKernel")
		mv arch/arm64/boot/Image Build/AnyKernel/Image
		sed -i "s/kernel.string=.*/kernel.string=$BUILD_NAME/g" Build/AnyKernel/anykernel.sh
		echo "Enter zip's name asap bruh:"
		read zip_name
		cd Build/AnyKernel
		zip -r $zip_name.zip *
		cd ../../
		mv Build/AnyKernel/$zip_name.zip Build/finished/$zip_name.zip
		rm -rf Build/AnyKernel/Image
		rm -rf Build/Image
		break
	;;
        "Exit")
            break
            ;;
        *) echo Invalid option.;;
    esac
done
