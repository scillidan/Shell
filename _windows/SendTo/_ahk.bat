@echo off

setlocal enabledelayedexpansion

for %%I in (%*) do (
    autohotkeyu64 "%%~I"
)