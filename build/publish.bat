7za a -tzip Vikings.love @lovelist
mkdir .\LostVikingsVI
mkdir .\LostVikingsVI\game
copy /b .\love\love.exe + .\Vikings.love .\LostVikingsVI\LostVikingsVI.exe
copy ...\main.lua .\LostVikingsVI\main.lua
copy .\love\*.dll .\LostVikingsVI\.
xcopy ..\game /e .\LostVikingsVI\game