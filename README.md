# Névkártya generátor a Drupal Hétvége rendezvényekre

A regisztrációkat tartalmazó CSV formátumú adatforrásból a megadott LaTeX sablonok alapján 
legyártja a névkártyákat nyomdakész PDF-ben 1:1 méretarányban (90x50mm) kifutóval (96x56mm).

Az adatforrás vesszővel tagolt CSV formátum az alábbi séma szerint:

    "Név","Becenév","Cég","Beosztás","Ismerkedő","Webmester","Sminkmester","Programozó"

## Telepítés

  1. yum install emacs texlive-latex

## Használat

  1. Töltsd be a `makebadges.el` kódtárat Emacsba:

     `M-x load-file makebadges.el`

  2. Futtasd le a gyártót:

     `M-x dhu/make-badges`

  3. A generált LaTeX dokumentumból készíts PDF-et (`print_badges.tex` a megadott kimeneti fájl neve):

     `pdflatex print_badges.tex`

Kész.
