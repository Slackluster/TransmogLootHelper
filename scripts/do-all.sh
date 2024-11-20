mkdir -p tmp

cd tmp

../scripts/get-files.sh
../scripts/convert-recipes-to-spell-ids.py >../Database2.lua

cd ../