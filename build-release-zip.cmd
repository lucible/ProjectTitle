@ECHO OFF

#make folder
mkdir projecttitle.koplugin

#copy everything into the right folder name
copy *.lua projecttitle.koplugin
xcopy fonts projecttitle.koplugin\fonts /s /i
xcopy icons projecttitle.koplugin\icons /s /i
xcopy resources projecttitle.koplugin\resources /s /i
copy LICENSE projecttitle.koplugin

#zip the folder
7z a -tzip projecttitle.zip projecttitle.koplugin

#delete the folder
rmdir /s /q projecttitle.koplugin
