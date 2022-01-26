#!/bin/bash
#dir=`pwd`
#echo CWD $dir
giturl="https://github.com/"

echo " "
echo -n "Enter Github Repo Name : "

read reponame

echo " "
echo -n  "Enter Tag1 : "

read t1

echo " "
echo -n  "Enter Tag2 : "

read t2

echo -e "\n"
echo "GIT URL : $giturl$reponame"
echo "Branch1 : $t1"
echo "Branch2 : $t2"

git clone -q $giturl$reponame.git

repodir=`echo $reponame | cut -d "/" -f2`

#echo repodir $repodir

cd $repodir

#dir=`pwd`
#echo CWD $dir
#echo "Files in repository"
#git ls-files

echo " "

filenameDiff=`git diff --name-only origin/$t1 origin/$t2`

echo "FILES WITH DIFFERENCES BETWEEN 2 TAGGED VERSIONS"
for name in  $filenameDiff
do
echo "$name"
done
echo -e "\n"


>filesfetched.txt

echo "DISPLAYING FILENAMES FETCHED ABOVE AFTER EXCLUDING FILE WITH EXCL*"

for fname in $filenameDiff
do

 if [[ $fname != excl* ]]
 then
 echo "$fname"
 echo $fname >>filesfetched.txt
 fi

done

echo " "

#TO CHECK IF GOOGLE URL IS PRESENT IN THE FILES STORED IN THE FILE CREATED ABOVE

echo "SEARCHING FOR GOOGLE_URL IN THE FILES"
echo " "

gflag=0

for branch in $t1 $t2
do

 git checkout -q $branch

  for filename in `<filesfetched.txt`
  do
   
   if grep -q GOOGLE_URL "$filename"
   then
    echo " "
    echo "GOOGLE_URL FOUND IN THE FILE $filename"
    gflag=1
    
    echo " "
    echo "TESTING CONNECTIVITY TO https://google.com:443"
    httpstatus=`curl -IL -s https://google.com:443 | grep HTTP/2 | grep 200`

    if [[ $httpstatus == *"200"* ]]
    then
      echo "CONNECTIVITY TO GOOGLE IS WORKING - STATUS = $httpstatus"
      echo " "
    else
      echo "CONNECTIVITY TO GOOGLE IS NOT WORKING - STATUS = $httpstatus"
      echo " "
    fi
   
   SEARCH_STRING=GOOGLE_URL
   REPLACE_STRING=https://google.com:443
   
   echo " "
   echo "REPLACING GOOGLE_URL WITH STRING https://google.com:443"
   sed -i "s+$SEARCH_STRING+$REPLACE_STRING+g" $filename
   echo "DONE"
   
   echo " "
   echo "CREATING JSON PAYLOAD"
   echo '{ "status" : "success", "url" : https://google.com:443 }' > jsonpayload.json
   echo " "
   echo "PERFORMING REST POST CALL TO DUMMY URL https://localhost:8443"
   
   curl --location --request POST 'https://localhost:8443' --header 'Content-Type: application/json' --data @jsonpayload.json
   
   echo " "

   fi
  done

done

if (( $gflag == 0  ))
then

echo "NO FILES WITH GOOGLE_URL FOUND"

fi

echo " "
echo "CHECKING IF ANSIBLE IS INSTALLED"
ansible_check=`apk info | grep ansible`

if [[ $ansible_check == *"ansible"*   ]]
then
echo "ANSIBLE PACKAGE IS INSTALLED IN THIS OS"
else
echo "ANSIBLE PACKAGE IS NOT INSTALLED IN THIS OS"
fi


