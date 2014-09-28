# z_pandoc_slides.sh
# 2014-02-14 dmontaner@cipf.es
# Run Pandoc for slides

## PARAMETERS you may want to change
outfile="association_studies_presentation"   #name for the final PDF file (without extension)

################################################################################

## RUN PANDOC

infile="association_studies_presentation"
beamer_template="../../../Commons/beamer_template_for_slides"

mkdir aux

rm $outfile.pdf

pandoc -S -f markdown -t beamer -o aux/slides.tex $infile.md

##properly scale images
sed -i 's/\includegraphics{/\includegraphics[width=\\textwidth,height=0.8\\textheight,keepaspectratio]{/g' aux/slides.tex

pdflatex -output-directory=aux $beamer_template.tex

mv aux/`basename $beamer_template`.pdf $outfile.pdf

