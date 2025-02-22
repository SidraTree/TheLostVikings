7za a -tzip Vikings.love @lovelist
mkdir .\LostVikingsVI
mkdir .\LostVikingsVI\game
copy /b .\love\love.exe + .\Vikings.love .\LostVikingsVI\LostVikingsVI.exe
copy ..\*.lua .\LostVikingsVI\.
copy .\love\*.dll .\LostVikingsVI\.
xcopy ..\game /e /y .\LostVikingsVI\game
7za a -tzip LostVikingsVI.zip .\LostVikingsVI
del Vikings.love