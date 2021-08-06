#!/bin/bash

# Written by: T. Ryan Rogers
# Last updated: 02/07/2019
#
# As of Oct. 3rd, 2019, this script creates files named as:    note_YY-MM-DD[a-z].txt
# since these are easier to sort chronologically.
# A traditional, American-style date-- MM/DD/YYYY-- is still printed inside the
# notes near the top.
#
# The 1st version of this script had the double-thick pound signs at the top
# of the new note text files. However, they have now been placed at the bottom
# of the notes. This is so that one could potentially develop a script that 
# compiled a single "lab notebook" out of all the notes with something like this:
# 
#    for all dirs recursively, {
#        print "ls /dir.path/" >> big_lab_notebook.txt;
#        cat /dir.path/note_$i >> big_lab_notebook.txt;
#    }
#
# This pseudo code is obviously experimental at the moment.
# What is needed is a method to descend into subdirectories and cat their notes
# in the appropriate order. 


date2y=`date +%y-%m-%d`
#echo "date2y = $date2y"   #---DEBUGGING.

last=`ls | grep $date2y | tail -1 | cut -c14`
if [ -z $last ]; then
    next=a
else
    next=$(echo "$last" | tr "0-9a-z" "1-9a-z_")
fi
#echo "next = $next"   #---DEBUGGING.


date4y=`date +%m/%d/%Y`
#echo "date4y = $date4y"   #---DEBUGGING.

time=`date +%r`
#echo "time = $time"   #---DEBUGGING.

#echo "touch note_${date2y}${next}.txt"   #---DEBUGGING.
echo           > note_${date2y}${next}.txt
echo $date4y  >> note_${date2y}${next}.txt
echo	      >> note_${date2y}${next}.txt
echo $time    >> note_${date2y}${next}.txt
echo          >> note_${date2y}${next}.txt    
echo          >> note_${date2y}${next}.txt    
echo          >> note_${date2y}${next}.txt    
echo "---------------------" >> note_${date2y}${next}.txt    
echo "---------------------" >> note_${date2y}${next}.txt    
echo          >> note_${date2y}${next}.txt    
echo          >> note_${date2y}${next}.txt    
echo "---------------------" >> note_${date2y}${next}.txt    
echo "---------------------" >> note_${date2y}${next}.txt    
echo          >> note_${date2y}${next}.txt    
echo          >> note_${date2y}${next}.txt    
echo "---------------------" >> note_${date2y}${next}.txt    
echo "---------------------" >> note_${date2y}${next}.txt    
echo          >> note_${date2y}${next}.txt    
# THIS IS 80 # MARKS
echo "################################################################################" >> note_${date2y}${next}.txt
echo "################################################################################" >> note_${date2y}${next}.txt
