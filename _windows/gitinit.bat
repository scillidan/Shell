@echo off

git init
git remote add origin https://github.com/scillidan/%1.git
git branch -M main
git add .
git commit -m %2
git push -u origin main