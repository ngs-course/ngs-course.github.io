# z_pandoc_slides.sh
# 2014-02-14 dmontaner@cipf.es
# Run Pandoc for slides

## PARAMETERS you may want to change
outfile="quality_control_presentation"   #name for the final PDF file (without extension)
infile="quality_control_presentation"

################################################################################

## RUN PANDOC

beamer_template="../../../Commons/beamer_template.tex"

rm -r aux
mkdir aux

rm $outfile.pdf

##pandoc using template
pandoc -S -f markdown -t beamer --template=$beamer_template -o aux/slides.tex $infile.md

##properly scale images
sed -i 's/\includegraphics{/\includegraphics[width=\\textwidth,height=0.8\\textheight,keepaspectratio]{/g' aux/slides.tex

##remove empty captions
sed -i 's/\\caption{}//g' aux/slides.tex

##pdf
pdflatex -output-directory=aux aux/slides.tex
pdflatex -output-directory=aux aux/slides.tex  ## needs to be compiled two times for the total number of frames to be properly estimated.
## it may need one more for the citations

##reallocate files
mv aux/slides.pdf $outfile.pdf
