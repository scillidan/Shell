; Create the array, initially empty:
Array := Array()

; Write to the array:
Loop, Read, lively_wallpapers.txt ; This loop retrieves each line from the file, one at a time.
{
    Array.Push(A_LoopReadLine) ; Append this line to the array.
}

#z::
command := "lively setwp --file " . """"Array[random(Array.MinIndex(), Array.MaxIndex())]""""
Run cmd.exe /c %command%,,hide

random( x, y )
{
   Random, var, %x%, %y%
   return var
}