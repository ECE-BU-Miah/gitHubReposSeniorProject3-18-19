This thesis template was created by Prof. Wail Gueaieb (Thank you Prof. Gueaieb).
 
Wail Gueaieb (Courtesy of Stephen Carr)
Last updated: 2014-01-02

The files included in this package are slighly modified by Suruz Miah to adapt partial requirements in writing project/thesis reports of the Bradley University's Department of Electrical and Computer Engineering.  
 

This "ready-made thesis template" is meant to help the University of Ottawa's
graduate students to write their theses in LaTeX. It is a modified version of
the package made by Stephen M. Carr for the University of Waterloo (Thank you
Stephen). It is NOT an official release of the University of Ottawa.
Nevertheless, it is made to satisfy the thesis' technical standards set by the
University of Ottawa at:
http://web5.uottawa.ca/www3/fespfgps/theses/do-en-2point5num1.htm


The template was originally prepared for EECS students. Students in other 
disciplines may also use it, however they should double check with their 
academic units. Remember that it is the student's responsibility to make sure 
that sources are referenced properly. The Faculty of Graduate and Postdoctoral 
studies at the University of Ottawa mendates that quotation marks are used in 
direct quotations.

This package comes with NO WARRANTY and NO SUPPORT! You may use it at YOUR OWN
RISK!!!

Package Content
---------------
bibliography:
   keylatex.bib:
      This is a bibliography file that contains the references to be inserted
in the Bibliography part of the thesis.


figures:
   This is where I placed the figures. The folder may be divided further
by chapter if you want.


parts:
   This is where you can find the files you'll have to edit for your thesis.
I suggest you place your thesis chapters here too.


private:
   00-frontpage.tex:
      front page material

   01-declarationpage.tex:
      declaration page. This is used by uWaterloo but NOT by uOttawa.
      Don't use it.

   list-of-symbolds.tex:
      This file automatically takes care of Nomenclature.

   thesis-margins-and-spaces.tex:
      This is where the margins and spaces are set.

   toc-lot-lof.tex:
      Automatically inserts, the tables of contents, the list of tables, and
      the list of figures.
   
   Files in the "private" folder are made such that they don't need to be
edited. So, Do not edit them unless you know what you are doing.


00readme.txt:
   This file.

changes.txt:
   Changes between the different versions.

preamble.tex:
   A file to include customized commands and LaTeX packages.

ECE-BU-ReportMain.tex:
   The master file of the report/thesis.


Command Sequence Used to Process These Files
--------------------------------------------
At the prompt, process these source files with the following command sequence:

(pdf)latex ECE-BU-ReportMain	
bibtex ECE-BU-ReportMain
(pdf)latex ECE-BU-ReportMain
(pdf)latex ECE-BU-ReportMain
makeindex -s nomentbl.ist -o ECE-BU-ReportMain.nls ECE-BU-ReportMain.nlo
(pdf)latex ECE-BU-ReportMain	
(pdf)latex ECE-BU-ReportMain	

The makeindex and the following commands are only necessary if you have a 
Nomenclature section.
