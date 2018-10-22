::======================================
:: Filename: mamske.bat
:: Author:   Joseph
:: Created:  2012 - 07 - 12
:: E-mail:   mrpeng000@gmail.com
::======================================
:: ʹ��˵��
::
::   1�������ĵ�
::   msmake [bachelor|master] [full]
::     �ڵ�ǰĿ¼�±������ģ���ִ��xelatex���������Ӧ��cls/bst�ļ�����ֱ�ӱ���
::      - full Ϊ�״α������ȫ���ʱ��ѡ���ִ��xelatex->bibtex->xelatex->xelatex����
::   2�������ļ�
::   msmake [clean] [more|empty]
::     �ڵ�ǰĿ¼�������������в�������ʱ�ļ�
::     - more �������������в������ļ�������*aux *.bbl �ļ�
::     - empty �������������в������ļ�������*aux *.bbl *.pdf �ļ���������ʹ��
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
:: �����ҵ�����
::======================================
:thesis
echo compling
if not exist buaathesis.cls goto clserr
if not exist buaathesis.bst goto bsterr
if /i {%1}=={bachelor} set mythesis=sample-bachelor
if /i {%1}=={master} set mythesis=sample-master
:: �������ļ������ģ��뽫�����"sample-bachelor"��"sample-master"���ġ�
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
:: ����ļ��Լ���������ļ�
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
:: ������Ϣ
::======================================
:help
::echo            ����msmake+��������ѡ�������Ӧ����
::echo                ���������msmake bachelor��
echo     msmake parameters        explanation          
echo     bachelor/master          compile my files
echo     clean                    delete extra files
echo     help                     display help
echo     bachelor/master full     used when first compile it or after clean more
echo     clean more               delete irrelevant files in current directory
echo Caution: the filename must be sample-bachelor.tex or sample-master.tex
:: �̲�ס�²ۣ�Ϊ����ʾ���룬��Ȼ�ŵ���ô�ң�
goto end

::======================================
:: ���д�����Ϣ
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
:: �����������κξ�������
::======================================
:end
