#!/bin/bash

# apktool version v2.3.4
# uber-apk-signer v0.84
# encrypt
# echo "string" | openssl enc -aes-256-cbc -a 
# decrypt
# echo "encrypted_string" | openssl enc -aes-256-cbc -d -a

application="com.anthonyng.workoutapp.36"

apkname=$application.apk

encrypted_target_file='U2FsdGVkX18WelSpWRjNPtmLDWP4CGha/bgDBgG0J03pudufbDd2qvmER+vQO6kL
Ox2x+oFN2SoLCXnbvuwMaha2fUicIpvXnFcNg/IMIiWgxfeqVS5JS/N9EOqT8mcu
4WEVwmeSitYKjoqBecGHXQ=='

encrypted_patch='U2FsdGVkX18UbduCnp1mtGPOfoU896OHArM4TyMpvL7/q7LQdbMY/FP5CnssZGBv'

encrypted_target='U2FsdGVkX19xArP2AKUzXqj1zzwQLvcZK8TA9Tw9XsgbDsNFQHUJzSV7eAVR2PCV'

printf "Please enter password to decrypt target file(s) \n"
target_file=$(echo $encrypted_target_file | openssl enc -aes-256-cbc -d -a)
printf "Please enter password to decrypt target(s) \n"
target=$(echo $encrypted_target | openssl enc -aes-256-cbc -d -a)
printf "Please enter password to decrypt patch(s) \n"
patch=$(echo $encrypted_patch | openssl enc -aes-256-cbc -d -a)

printf "=============================================\n"
printf "Targetting $target_file \n"
printf "Targetting section \n $target \n"
printf "Patching target with \n $patch \n"
printf "=============================================\n"

read -p "Press enter to continue"

printf "=============================================\n"
printf "Decompiling apk $apkname \n"
printf "=============================================\n"
apktool d $apkname

printf "=============================================\n"
printf "Backing up apk \n"
printf "=============================================\n"
mv "$apkname" "$apkname.backup"

printf "=============================================\n"
printf "Backuping up target \n"
printf "=============================================\n"
cp $target_file $target_file.backup

printf "=============================================\n"
printf "Generating patch for target \n"
printf "=============================================\n"
sed -e "/$target/{s//$patch/;:a" -e "$!N;$!ba" -e "}" $target_file > patched_file

printf "=============================================\n"
printf "Patching Target \n"
printf "=============================================\n"
cp patched_file $target_file

printf "=============================================\n"
printf "Cleaning up a few things \n"
printf "=============================================\n"
rm $target_file.backup

printf "=============================================\n"
printf "Rebuilding apk \n"
printf "=============================================\n"
apktool b $application

printf "=============================================\n"
printf "Backing up apk \n"
printf "=============================================\n"
mv "$apkname" "$apkname.backup"

printf "=============================================\n"
printf "Restoring rebuilt apk \n"
printf "=============================================\n"
mv "$application/dist/$apkname" ./

printf "=============================================\n"
printf "Signing apk \n"
printf "=============================================\n"
uber-apk-signer --apks "$apkname"

printf "=============================================\n"
printf "Cleaning up some mess \n"
printf "=============================================\n"
rm patched_file
rm $apkname
rm -r $application


