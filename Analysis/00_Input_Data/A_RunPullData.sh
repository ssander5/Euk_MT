#pulling data whole-sale from ../Input_Data.  If you want to import only part of the data, please do that manually.

for f in ../Input_Data/*; do
   ln -s $f .
done
