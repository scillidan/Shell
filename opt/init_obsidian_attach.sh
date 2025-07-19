#!/bin/bash

set -e

OBSIDIAN_DL="$HOME/Usr/Download/obsidian"
VAULT_DIR="$HOME/Usr/Git/Vault"

ATTACH_KEYMAP="$VAULT_DIR/attach/keymap"
rm -rf "$ATTACH_KEYMAP"
mkdir -p "$ATTACH_KEYMAP"
for file in "$OBSIDIAN_DL/keymap/"*.pdf; do
    if [[ -f "$file" ]]; then
        ln -f "$file" "$ATTACH_KEYMAP/$(basename "$file")"
    fi
done

ATTACH_LATEX="$VAULT_DIR/attach/latex"
LATEX_DL="$HOME/Usr/Download/latex"
LATEX_SRC="$HOME/Usr/Source/latex"
rm -rf "$ATTACH_LATEX"
mkdir -p "$ATTACH_LATEX/pkg"
mkdir -p "$ATTACH_LATEX/pkg_jpg"
# wget https://wch.github.io/latexsheet/latexsheet-a4.pdf
ln -f "$OBSIDIAN_DL/latex/latexsheet-a4.pdf" "$ATTACH_LATEX/latexsheet-a4.pdf"
# wget https://www.bu.edu/math/files/2013/08/LongTeX1.pdf
ln -f "$OBSIDIAN_DL/latex/LongTeX1.pdf" "$ATTACH_LATEX/LongTeX1.pdf"
ln -f "$LATEX_SRC/adjustbox/adjustbox.pdf" "$ATTACH_LATEX/pkg/adjustbox.pdf"
ln -f "$LATEX_SRC/arguelles/demo/demo-arguelles.pdf" "$ATTACH_LATEX/pkg/arguelles.pdf"
ln -f "$LATEX_SRC/blowup/blowup.pdf" "$ATTACH_LATEX/pkg/blowup.pdf"
ln -f "$LATEX_SRC/ccicons/ccicons.pdf" "$ATTACH_LATEX/pkg/ccicons.pdf"
ln -f "$LATEX_SRC/colorblind/colorblind_doc.pdf" "$ATTACH_LATEX/pkg/colorblind.pdf"
ln -f "$LATEX_SRC/DND-5e-LaTeX-Template/example.pdf" "$ATTACH_LATEX/pkg/dnd-5e-latex-template.pdf"
ln -f "$LATEX_SRC/enumext/enumext.pdf" "$ATTACH_LATEX/pkg/enumext.pdf"
ln -f "$LATEX_SRC/fmitex-parnotes/parnotes.pdf" "$ATTACH_LATEX/pkg/fmitex-parnotes.pdf"
ln -f "$LATEX_SRC/fontawesome/fontawesome6/doc/fontawesome6.pdf" "$ATTACH_LATEX/pkg/fontawesome.pdf"
ln -f "$LATEX_SRC/fontawesome-latex/templates/fontawesome.pdf" "$ATTACH_LATEX/pkg/fontawesome-latex.pdf"
ln -f "$LATEX_SRC/geometry/geometry.pdf" "$ATTACH_LATEX/pkg/geometry.pdf"
ln -f "$LATEX_SRC/gitinfo2/gitinfo2.pdf" "$ATTACH_LATEX/pkg/gitinfo2.pdf"
ln -f "$LATEX_SRC/gitlog/gitlog.pdf" "$ATTACH_LATEX/pkg/gitlog.pdf"
ln -f "$LATEX_SRC/graphicxpsd/graphicxpsd.pdf" "$ATTACH_LATEX/pkg/graphicxpsd.pdf"
ln -f "$LATEX_SRC/hackthefootline/hackthefootline/doc/hackthefootline-doc.pdf" "$ATTACH_LATEX/pkg/hackthefootline.pdf"
ln -f "$LATEX_SRC/href-ul/href-ul.pdf" "$ATTACH_LATEX/pkg/href-ul.pdf"
ln -f "$LATEX_SRC/hsrmbeamertheme/hsrm-beamer-demo.pdf" "$ATTACH_LATEX/pkg/hsrmbeamertheme.pdf"
ln -f "$LATEX_SRC/invoice2/invoice2.pdf" "$ATTACH_LATEX/pkg/invoice2.pdf"
ln -f "$LATEX_SRC/kdpcover/kdpcover.pdf" "$ATTACH_LATEX/pkg/kdpcover.pdf"
ln -f "$LATEX_SRC/kmbeamer/examples/example_Blackboard.pdf" "$ATTACH_LATEX/pkg/kmbeamer.pdf"
ln -f "$LATEX_SRC/latex-pagelayout/doc/pagelayout-manual.pdf" "$ATTACH_LATEX/pkg/latex-pagelayout.pdf"
ln -f "$LATEX_SRC/latex-presentation/presentation.pdf" "$ATTACH_LATEX/pkg/latex-presentation.pdf"
ln -f "$LATEX_SRC/latexindent.pl/documentation/latexindent.pdf" "$ATTACH_LATEX/pkg/latexindent.pl.pdf"
ln -f "$LATEX_SRC/ltx_clrstrip/clrstrip.pdf" "$ATTACH_LATEX/pkg/ltx_clrstrip.pdf"
ln -f "$LATEX_SRC/magicwatermark/doc/magicwatermark-en.pdf" "$ATTACH_LATEX/pkg/magicwatermark.pdf"
ln -f "$LATEX_SRC/make4ht/make4ht-doc.pdf" "$ATTACH_LATEX/pkg/make4ht.pdf"
ln -f "$LATEX_SRC/menukeys/menukeys.pdf" "$ATTACH_LATEX/pkg/menukeys.pdf"
ln -f "$LATEX_SRC/mercatormap/doc/latex/mercatormap/mercatormap.pdf" "$ATTACH_LATEX/pkg/mercatormap.pdf"
ln -f "$LATEX_SRC/microtype/microtype.pdf" "$ATTACH_LATEX/pkg/microtype.pdf"
ln -f "$LATEX_SRC/multicolrule/multicolrule.pdf" "$ATTACH_LATEX/pkg/multicolrule.pdf"
ln -f "$LATEX_SRC/oPlotSymbl-LaTeX/oPlotSymbl-Manual-en.pdf" "$ATTACH_LATEX/pkg/oplotsymbl-latex.pdf"
ln -f "$LATEX_SRC/pdfprivacy/pdfprivacy.pdf" "$ATTACH_LATEX/pkg/pdfprivacy.pdf"
ln -f "$LATEX_SRC/phfqitltx/phfqit/phfqit.pdf" "$ATTACH_LATEX/pkg/phfqitltx.pdf"
ln -f "$LATEX_SRC/polyglossia/doc/polyglossia.pdf" "$ATTACH_LATEX/pkg/polyglossia.pdf"
ln -f "$LATEX_SRC/Q-and-A/doc/Q-and-A-doc.pdf" "$ATTACH_LATEX/pkg/q-and-a.pdf"
ln -f "$LATEX_SRC/quiver/package/quiver-package-documentation.pdf" "$ATTACH_LATEX/pkg/quiver.pdf"
ln -f "$LATEX_SRC/rerunfilecheck/rerunfilecheck.pdf" "$ATTACH_LATEX/pkg/rerunfilecheck.pdf"
ln -f "$LATEX_SRC/responsive-latex/responsive-doc.pdf" "$ATTACH_LATEX/pkg/responsive-latex.pdf"
ln -f "$LATEX_SRC/sectionbreak/sectionbreak-doc.pdf" "$ATTACH_LATEX/pkg/sectionbreak.pdf"
ln -f "$LATEX_SRC/semesterplanner/docs.pdf" "$ATTACH_LATEX/pkg/semesterplanner.pdf"
ln -f "$LATEX_SRC/semesterplannerLua/semesterplannerlua.pdf" "$ATTACH_LATEX/pkg/semesterplannerlua.pdf"
ln -f "$LATEX_SRC/sidenotesplus/sidenotesplus.pdf" "$ATTACH_LATEX/pkg/sidenotesplus.pdf"
ln -f "$LATEX_SRC/skrapport/skrapport.pdf" "$ATTACH_LATEX/pkg/skrapport.pdf"
ln -f "$LATEX_SRC/soulpos/soulpos.pdf" "$ATTACH_LATEX/pkg/soulpos.pdf"
ln -f "$LATEX_SRC/stage/stage-documentation.pdf" "$ATTACH_LATEX/pkg/stage.pdf"
ln -f "$LATEX_SRC/tabularray/manual/manual.pdf" "$ATTACH_LATEX/pkg/tabularray.pdf"
ln -f "$LATEX_SRC/tex4ebook/tex4ebook-doc.pdf" "$ATTACH_LATEX/pkg/tex4ebook.pdf"
ln -f "$LATEX_SRC/tikzducks/DOCUMENTATION.pdf" "$ATTACH_LATEX/pkg/tikzducks.pdf"
ln -f "$LATEX_SRC/truchet/tikz-truchet.pdf" "$ATTACH_LATEX/pkg/truchet.pdf"
ln -f "$LATEX_SRC/typed-checklist/typed-checklist.pdf" "$ATTACH_LATEX/pkg/typed-checklist.pdf"
ln -f "$LATEX_SRC/typog/docs/typog.pdf" "$ATTACH_LATEX/pkg/typog.pdf"
ln -f "$LATEX_SRC/unifront/unifront-manual.pdf" "$ATTACH_LATEX/pkg/unifront.pdf"
ln -f "$LATEX_SRC/wallcalendar/wallcalendar.pdf" "$ATTACH_LATEX/pkg/wallcalendar.pdf"
# Later
ln -f "$LATEX_DL/tools/array.pdf" "$ATTACH_LATEX/pkg/array.pdf"
ln -f "$LATEX_DL/fbb/doc/fbb-doc.pdf" "$ATTACH_LATEX/pkg/fbb.pdf"

rm "$ATTACH_LATEX/pkg_jpg/"*.jpg || true
for img in "$HOME/Usr/Asset/image_latex/"*.jpg; do
    if [[ -f "$img" ]]; then
        ln -f "$img" "$ATTACH_LATEX/pkg_jpg/$(basename "$img")"
    fi
done

echo "Process Completed!"