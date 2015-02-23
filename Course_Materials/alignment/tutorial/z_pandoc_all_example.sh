#!/bin/bash

# z_pandoc_example.sh
# 2014-02-14 dmontaner@cipf.es
# Run Pandoc for examples

name=`basename $1 .md`

## PARAMETERS you may want to change
outfile=$name   #name for the final HTML file (without extension)


## more parameters 
infile=$name
shfile=$name
cssfile="../../../Commons/css_template_for_examples.css"

################################################################################

## RUN PANDOC
#pandoc -S --toc -f markdown -t html -c $cssfile -o $outfile.html $infile.md
pandoc -S -f markdown -t html -c $cssfile -o $outfile.html $infile.md

## EXTRACT shell commands
sed 's/^\t/    /g' $infile.md  > $shfile.0.sh   # replace starting tabs by 4 spaces
grep  "^    " > $shfile.sh $shfile.0.sh         # fin the verbatim lines: those starting with 4 spaces
rm $shfile.0.sh
sed -i 's/^    //g'                $shfile.sh  # remove spaces
chmod +x                            $shfile.sh  # executable
