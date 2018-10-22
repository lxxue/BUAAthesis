::======================================
:: Filename: mamske.bat
:: Author:   Joseph
:: Created:  2012 - 07 - 12
:: E-mail:   mrpeng000@gmail.com
::======================================
:: 使用说明
::
::   1、生成文档
::   msmake [bachelor|master] [full]
::     在当前目录下编译论文，将执行xelatex命令，若无相应的cls/bst文件，将直接报错
::      - full 为首次编译或完全清空时的选项，将执行xelatex->bibtex->xelatex->xelatex命令
::   2、清理文件
::   msmake [clean] [more|empty]
::     在当前目录下清理编译过程中产生的临时文件
::     - more 将清除编译过程中产生的文件，包括*aux *.bbl 文件
::     - empty 将清除编译过程中产生的文件，包括*aux *.bbl *.pdf 文件，不建议使用
::
::======================================

@echo off
:init
if /i {%1}=={bachelor} goto thesis
if /i {%1}=={master} goto thesis
if /i {%1}=={clean} goto clean
if /i {%1}=={help} goto help
if /i {%1}=={} goto help
goto help

::======================================
:: 编译我的论文
::======================================
:thesis
echo compling
if not exist buaathesis.cls goto clserr
if not exist buaathesis.bst goto bsterr
if /i {%1}=={bachelor} set mythesis=sample-bachelor
if /i {%1}=={master} set mythesis=sample-master
:: 如若主文件名更改，请将上面的"sample-bachelor"或"sample-master"更改。
call xelatex %mythesis%
if {%2}=={full} (goto full)
if errorlevel 1 goto myerr1
echo success!
call %mythesis%.pdf
goto end
:full
call bibtex %mythesis%
:: Negligible errors will occur when build the bib library.
:: if errorlevel 1 goto biberr
if not exist %mythesis%.bbl goto biberr
call xelatex %mythesis%
call xelatex %mythesis%
echo success!
call %mythesis%.pdf
goto end

::======================================
:: 清除文件以及清除更多文件
::======================================
:clean
echo delete temp files
del /f /q /s *.log *.glo *.ilg *.lof *.ind *.out *.thm *.toc *.lot *.loe *.out.bak *.blg *.synctex.gz
del /f /q *.idx
del /f /s *.dvi *.ps
if {%2}=={more} (goto cleanmore)
if {%2}=={empty} (goto cleanempty)
goto end
:cleanmore
del /f /q /s *.aux *.bbl
goto end
:cleanempty
del /f /q /s *aux *.bbl *.pdf
goto end

::======================================
:: 帮助信息
::======================================
:help
::echo            输入msmake+下面的命令，选择进入相应操作
::echo                如输入命令“msmake bachelor”
echo     msmake parameters        explanation          
echo     bachelor/master          compile my files
echo     clean                    delete extra files
echo     help                     display help
echo     bachelor/master full     used when first compile it or after clean more
echo     clean more               delete irrelevant files in current directory
echo Caution: the filename must be sample-bachelor.tex or sample-master.tex
:: 忍不住吐槽，为了显示对齐，居然排得这么乱！
goto end

::======================================
:: 运行错误信息
::======================================
:myerr1
echo fail to compile
goto end
:biberr
echo bib not found
goto end
:clserr
echo cls not found
goto end
:bsterr
echo bst not found
goto end

::======================================
:: 结束符，无任何具体意义
::======================================
:end
