@echo off

setlocal

set "OBSIDIAN_DL=%USERPROFILE%\Usr\Download\obsidian"
set "VAULT_DIR=%USERPROFILE%\Usr\Git\Vault"

set "ATTACH_KEYMAP=%VAULT_DIR%\attach\keymap"
rmdir /S /Q "%ATTACH_KEYMAP%"
mkdir "%ATTACH_KEYMAP%"
for %%F in ("%OBSIDIAN_DL%\keymap\*.pdf" ), do (
    mklink /H "%ATTACH_KEYMAP%\%%~nF.pdf" "%%F"
)

set "ATTACH_LATEX=%VAULT_DIR%\attach\latex"
set "LATEX_DL=%USERPROFILE%\Usr\Download\latex"
set "LATEX_SRC=%USERPROFILE%\Usr\Source\latex"
rmdir /S /Q "%ATTACH_LATEX%"
mkdir "%ATTACH_LATEX%"
mkdir "%ATTACH_LATEX%\pkg"
mkdir "%ATTACH_LATEX%\pkg_jpg"
:: wget https://wch.github.io/latexsheet/latexsheet-a4.pdf
mklink /H "%ATTACH_LATEX%\latexsheet-a4.pdf" "%OBSIDIAN_DL%\latex\latexsheet-a4.pdf"
:: wget https://www.bu.edu/math/files/2013/08/LongTeX1.pdf
mklink /H "%ATTACH_LATEX%\LongTeX1.pdf" "%OBSIDIAN_DL%\latex\LongTeX1.pdf"
mklink /H "%ATTACH_LATEX%\pkg\adjustbox.pdf" "%LATEX_SRC%\adjustbox\adjustbox.pdf"
mklink /H "%ATTACH_LATEX%\pkg\arguelles.pdf" "%LATEX_SRC%\arguelles\demo\demo-arguelles.pdf"
mklink /H "%ATTACH_LATEX%\pkg\blowup.pdf" "%LATEX_SRC%\blowup\blowup.pdf"
mklink /H "%ATTACH_LATEX%\pkg\ccicons.pdf" "%LATEX_SRC%\ccicons\ccicons.pdf"
mklink /H "%ATTACH_LATEX%\pkg\colorblind.pdf" "%LATEX_SRC%\colorblind\colorblind_doc.pdf"
mklink /H "%ATTACH_LATEX%\pkg\dnd-5e-latex-template.pdf" "%LATEX_SRC%\DND-5e-LaTeX-Template\example.pdf"
mklink /H "%ATTACH_LATEX%\pkg\enumext.pdf" "%LATEX_SRC%\enumext\enumext.pdf"
mklink /H "%ATTACH_LATEX%\pkg\fmitex-parnotes.pdf" "%LATEX_SRC%\fmitex-parnotes\parnotes.pdf"
mklink /H "%ATTACH_LATEX%\pkg\fontawesome.pdf" "%LATEX_SRC%\fontawesome\fontawesome6\doc\fontawesome6.pdf"
mklink /H "%ATTACH_LATEX%\pkg\fontawesome-latex.pdf" "%LATEX_SRC%\fontawesome-latex\templates\fontawesome.pdf"
mklink /H "%ATTACH_LATEX%\pkg\geometry.pdf" "%LATEX_SRC%\geometry\geometry.pdf"
mklink /H "%ATTACH_LATEX%\pkg\gitinfo2.pdf" "%LATEX_SRC%\gitinfo2\gitinfo2.pdf"
mklink /H "%ATTACH_LATEX%\pkg\gitlog.pdf" "%LATEX_SRC%\gitlog\gitlog.pdf"
mklink /H "%ATTACH_LATEX%\pkg\graphicxpsd.pdf" "%LATEX_SRC%\graphicxpsd\graphicxpsd.pdf"
mklink /H "%ATTACH_LATEX%\pkg\hackthefootline.pdf" "%LATEX_SRC%\hackthefootline\hackthefootline\doc\hackthefootline-doc.pdf"
mklink /H "%ATTACH_LATEX%\pkg\href-ul.pdf" "%LATEX_SRC%\href-ul\href-ul.pdf"
mklink /H "%ATTACH_LATEX%\pkg\hsrmbeamertheme.pdf" "%LATEX_SRC%\hsrmbeamertheme\hsrm-beamer-demo.pdf"
mklink /H "%ATTACH_LATEX%\pkg\invoice2.pdf" "%LATEX_SRC%\invoice2\invoice2.pdf"
mklink /H "%ATTACH_LATEX%\pkg\kdpcover.pdf" "%LATEX_SRC%\kdpcover\kdpcover.pdf"
mklink /H "%ATTACH_LATEX%\pkg\kmbeamer.pdf" "%LATEX_SRC%\kmbeamer\examples\example_Blackboard.pdf"
mklink /H "%ATTACH_LATEX%\pkg\latex-pagelayout.pdf" "%LATEX_SRC%\latex-pagelayout\doc\pagelayout-manual.pdf"
mklink /H "%ATTACH_LATEX%\pkg\latex-presentation.pdf" "%LATEX_SRC%\latex-presentation\presentation.pdf"
mklink /H "%ATTACH_LATEX%\pkg\latexindent.pl.pdf" "%LATEX_SRC%\latexindent.pl\documentation\latexindent.pdf"
mklink /H "%ATTACH_LATEX%\pkg\ltx_clrstrip.pdf" "%LATEX_SRC%\ltx_clrstrip\clrstrip.pdf"
mklink /H "%ATTACH_LATEX%\pkg\magicwatermark.pdf" "%LATEX_SRC%\magicwatermark\doc\magicwatermark-en.pdf"
mklink /H "%ATTACH_LATEX%\pkg\make4ht.pdf" "%LATEX_SRC%\make4ht\make4ht-doc.pdf"
mklink /H "%ATTACH_LATEX%\pkg\menukeys.pdf" "%LATEX_SRC%\menukeys\menukeys.pdf"
mklink /H "%ATTACH_LATEX%\pkg\mercatormap.pdf" "%LATEX_SRC%\mercatormap\doc\latex\mercatormap\mercatormap.pdf"
mklink /H "%ATTACH_LATEX%\pkg\microtype.pdf" "%LATEX_SRC%\microtype\microtype.pdf"
mklink /H "%ATTACH_LATEX%\pkg\multicolrule.pdf" "%LATEX_SRC%\multicolrule\multicolrule.pdf"
mklink /H "%ATTACH_LATEX%\pkg\oplotsymbl-latex.pdf" "%LATEX_SRC%\oPlotSymbl-LaTeX\oPlotSymbl-Manual-en.pdf"
mklink /H "%ATTACH_LATEX%\pkg\pdfprivacy.pdf" "%LATEX_SRC%\pdfprivacy\pdfprivacy.pdf"
mklink /H "%ATTACH_LATEX%\pkg\phfqitltx.pdf" "%LATEX_SRC%\phfqitltx\phfqit\phfqit.pdf"
mklink /H "%ATTACH_LATEX%\pkg\polyglossia.pdf" "%LATEX_SRC%\polyglossia\doc\polyglossia.pdf"
mklink /H "%ATTACH_LATEX%\pkg\q-and-a.pdf" "%LATEX_SRC%\Q-and-A\doc\Q-and-A-doc.pdf"
mklink /H "%ATTACH_LATEX%\pkg\quiver.pdf" "%LATEX_SRC%\quiver\package\quiver-package-documentation.pdf"
mklink /H "%ATTACH_LATEX%\pkg\rerunfilecheck.pdf" "%LATEX_SRC%\rerunfilecheck\rerunfilecheck.pdf"
mklink /H "%ATTACH_LATEX%\pkg\responsive-latex.pdf" "%LATEX_SRC%\responsive-latex\responsive-doc.pdf"
mklink /H "%ATTACH_LATEX%\pkg\sectionbreak.pdf" "%LATEX_SRC%\sectionbreak\sectionbreak-doc.pdf"
mklink /H "%ATTACH_LATEX%\pkg\semesterplanner.pdf" "%LATEX_SRC%\semesterplanner\docs.pdf"
mklink /H "%ATTACH_LATEX%\pkg\semesterplannerlua.pdf" "%LATEX_SRC%\semesterplannerLua\semesterplannerlua.pdf"
mklink /H "%ATTACH_LATEX%\pkg\sidenotesplus.pdf" "%LATEX_SRC%\sidenotesplus\sidenotesplus.pdf"
mklink /H "%ATTACH_LATEX%\pkg\skrapport.pdf" "%LATEX_SRC%\skrapport\skrapport.pdf"
mklink /H "%ATTACH_LATEX%\pkg\soulpos.pdf" "%LATEX_SRC%\soulpos\soulpos.pdf"
mklink /H "%ATTACH_LATEX%\pkg\stage.pdf" "%LATEX_SRC%\stage\stage-documentation.pdf"
mklink /H "%ATTACH_LATEX%\pkg\tabularray.pdf" "%LATEX_SRC%\tabularray\manual\manual.pdf"
mklink /H "%ATTACH_LATEX%\pkg\tex4ebook.pdf" "%LATEX_SRC%\tex4ebook\tex4ebook-doc.pdf"
mklink /H "%ATTACH_LATEX%\pkg\tikzducks.pdf" "%LATEX_SRC%\tikzducks\DOCUMENTATION.pdf"
mklink /H "%ATTACH_LATEX%\pkg\truchet.pdf" "%LATEX_SRC%\truchet\tikz-truchet.pdf"
mklink /H "%ATTACH_LATEX%\pkg\typed-checklist.pdf" "%LATEX_SRC%\typed-checklist\typed-checklist.pdf"
mklink /H "%ATTACH_LATEX%\pkg\typog.pdf" "%LATEX_SRC%\typog\docs\typog.pdf"
mklink /H "%ATTACH_LATEX%\pkg\unifront.pdf" "%LATEX_SRC%\unifront\unifront-manual.pdf"
mklink /H "%ATTACH_LATEX%\pkg\wallcalendar.pdf" "%LATEX_SRC%\wallcalendar\wallcalendar.pdf"
:: Later
mklink /H "%ATTACH_LATEX%\pkg\array.pdf" "%LATEX_DL%\tools\array.pdf"
mklink /H "%ATTACH_LATEX%\pkg\fbb.pdf" "%LATEX_DL%\fbb\doc\fbb-doc.pdf"
:: Other
rem "geneve_1564\geneve_1564.pdf"
rem "thesis-invitation\sample_output.pdf"
del "%ATTACH_LATEX%\pkg_jpg\*.jpg"
for %%F in ("%USERPROFILE%\Usr\Asset\image_latex\*.jpg" ), do (
    mklink /H "%ATTACH_LATEX%\pkg_jpg\%%~nF.jpg" "%%F"
)

endlocal

pause