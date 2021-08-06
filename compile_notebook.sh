#!/bin/bash                                                                 

#====================================
#===== HELP/MAN PAGE SUBROUTINE =====
function help {
    echo "
===================================================================================
 compile_notebook.sh  (COMPILE a single NOTEBOOK of many notes, in a specfic order)

 Written by:           T. Ryan Rogers (ryan\@tryanrogers.com)
 Last modified:        08/05/2021
-----------------------------------------------------------------------------------
    USAGE :     compile_notebook.sh   DIRECTORY   [OPTIONS...]
	       
 SYNOPSIS :
    This script looks for individual note files in DIRECTORY, and contatenates all 
of them together, according to an ordering rule set by OPTIONS. Currently, three 
different options for how the output notebook is organized are available. See the
OPTIONS sub-descriptions for more details. One, more than one, or all OPTIONS can
be used simultaneously without conflict. 
    Output file(s) created by this script are always sent to
DIRECTORY/NOTEBOOK_DIRECTORY_DESCRIPTOR.txt
where \"NOTEBOOK\" is a string fixed by the script, and \"DESCRIPTOR\" is another
string fixed by the script, which designates which OPTIONS were used to generate 
the notebook. For example, if DIRECTORY=\"methanol\", & OPTIONS=\"-f\", then a 
single output file is created as \"methanol/NOTEBOOK_methanol_FindOrder.txt\".
    If more than one argument is used in OPTIONS, but one or more are stopped by
the script due to an attempted over-write, the other, non-offending OPTIONS are
still used. 

DIRECTORY :    

 OPTIONS  :    >= 1 option required. Available options include: 

               -h    Print this man/help page, then quit. This option will stop the
	       	     script even if DIRECTORY was supplied.

	       -c    Generate a semi-chronologically-ordered notebook. Notebook is
	       	     created as DIRECTORY/NOTEBOOK_DIRECTORY_Chronologic.txt

	       -d    Generate a notebook based on directory depth ordering. The
	       	     notebook created is 
		     DIRECTORY/NOTEBOOK_DIRECTORY_DepthOrder.txt

	       -f    Generate a notebook based on the order of all notes as seen 
	       	     by the \"find\" command. The created notebook file is called
		     DIRECTORY/NOTEBOOK_DIRECTORY_FindOrder.txt
-----------------------------------------------------------------------------------
 SAMPLE OUTPUT :

./compile_notebook.sh methanol -f -d -c
    Creating a semi-chronologically-ordered notebook...
    50 note files processed...
    100 note files processed...
    Creating a notebook ordered by subdirectory depths...
    50 note files processed...
    100 note files processed...
    Creating a notebook based on the order of a \"find\" command...
    50 note files processed...
    100 note files processed...

And the following files were created: 
    methanol/NOTEBOOK_methanol_Chronologic.txt
    methanol/NOTEBOOK_methanol_DepthOrder.txt
    methanol/NOTEBOOK_methanol_FindOrder.txt
===================================================================================

";
}


#========================================
#===== NOTEBOOK STYLE #1 SUBROUTINE =====
function style_findorder {
    notebook_name="$notebook_dir/NOTEBOOK_${notebook_dir}_FindOrder.txt"
    if test -f $notebook_name; then
	echo 
	echo "A file named $notebook_name exists; skipping this step to prevent overwriting!"
	echo 
	:   #DO NOTHING, SUCCESSFULLY.
    else
	#PRINT THIS "MAN PAGE" AT THE TOP OF THE NOTEBOOK BEING COMPILED:
	echo "********************************************************************************"              > $notebook_name  
	printf "**  %-72s  **\n" ""									    >> $notebook_name
	printf "**  %-72s  **\n" $notebook_name								    >> $notebook_name
	printf "**  %-72s  **\n" "Date compiled:    $date4y"						    >> $notebook_name
	printf "**  %-72s  **\n" ""									    >> $notebook_name
	printf "**  %-72s  **\n" "In this notebook style (\"FindOrder\"), notes are printed in the order"   >> $notebook_name
	printf "**  %-72s  **\n" "they are found via the \"find\" command. That is, directories are"	    >> $notebook_name
	printf "**  %-72s  **\n" "investigated in order, and all subdirectories within one directory are"   >> $notebook_name
	printf "**  %-72s  **\n" "investigated before moving on to the next directory. Note that, in this"  >> $notebook_name
	printf "**  %-72s  **\n" "case, notes of the very top directory are actually printed last!"	    >> $notebook_name
	printf "**  %-72s  **\n" ""									    >> $notebook_name
	echo "********************************************************************************"             >> $notebook_name
	echo >> $notebook_name
	echo >> $notebook_name   #EXTRA BLANK LINES BETWEEN "MAN" PAGE & ACTUAL NOTES.
	echo >> $notebook_name

	counter=1
	for note_file in `find $notebook_dir -name "note_??-??-??[a-z].txt" -type f`; do
	    if ! ((counter % 50)); then
		echo "$counter note files processed..."
	    fi
	    echo ">>>>>  $note_file  <<<<<" >> $notebook_name
	    cat $note_file >> $notebook_name   #
	    counter=$((counter+1))             #
	done                                   #	
	counter=$((counter-1))                 #FIX OVER-COUNTING FROM LAST LOOP.
	echo "...Processed a total of $counter note files."
    fi                                         #
}                                              #END SUBROUTINE FOR find-COMMAND-ORDERED NOTEBOOK.



#========================================
#===== NOTEBOOK STYLE #2 SUBROUTINE =====
function style_depthorder {
    notebook_name="$notebook_dir/NOTEBOOK_${notebook_dir}_DepthOrder.txt"
    if test -f $notebook_name; then
	echo 
	echo "A file named $notebook_name exists; skipping this step to prevent overwriting!"
	echo 
	:   #DO NOTHING, SUCCESSFULLY.
    else
	#PRINT THIS "MAN PAGE" AT THE TOP OF THE NOTEBOOK BEING COMPILED:
	echo "********************************************************************************"              > $notebook_name  
	printf "**  %-72s  **\n" ""									    >> $notebook_name
	printf "**  %-72s  **\n" $notebook_name								    >> $notebook_name
	printf "**  %-72s  **\n" "Date compiled:    $date4y"						    >> $notebook_name
	printf "**  %-72s  **\n" ""									    >> $notebook_name
	printf "**  %-72s  **\n" "In this notebook style (\"DepthOrder\"), all notes at a given directory"  >> $notebook_name
	printf "**  %-72s  **\n" "depth are printed to the notebook before descending to the next depth"    >> $notebook_name
	printf "**  %-72s  **\n" "to print. That is, all notes at the top-most level are printed first,"    >> $notebook_name
	printf "**  %-72s  **\n" "then all notes at the 2nd level are printed, etc."                        >> $notebook_name
	printf "**  %-72s  **\n" ""									    >> $notebook_name
	echo "********************************************************************************"             >> $notebook_name
	echo >> $notebook_name
	echo >> $notebook_name   #EXTRA BLANK LINES BETWEEN "MAN" PAGE & ACTUAL NOTES.
	echo >> $notebook_name

	deepest=0
	for line in `find $notebook_dir -maxdepth 999 -type d`; do
	    this_depth=`echo $line | awk 'BEGIN {FS = "/"}; {print NF}'`
	    if [[ $this_depth > $deepest ]]; then   #
		deepest=$this_depth                 #
	    fi	                                    #
	done
#	echo "The deepest directory I found has a depth of $deepest"   #---DEBUGGING.

	counter=1
	for ((depth=0; depth<$((deepest+1)); depth++)); do
#	    find $notebook_dir -maxdepth $depth -mindepth $depth -type d;   #---DEBUGGING.
#	    find $notebook_dir -maxdepth $depth -mindepth $depth -name "note_??-??-??[a-z].txt" -type f   #---DEBUGGING.
	    for note_file in `find $notebook_dir -maxdepth $depth -mindepth $depth -name "note_??-??-??[a-z].txt" -type f`; do
		if ! ((counter % 50)); then                         #
		    echo "$counter note files processed..."         #
		fi                                                  #
		echo ">>>>>  $note_file  <<<<<" >> $notebook_name   #
		cat $note_file >> $notebook_name                    #
		counter=$((counter+1))                              #
	    done                                                    #
	done
	counter=$((counter-1))                                      #FIX OVER-COUNTING FROM LAST LOOP.
	echo "...Processed a total of $counter note files."
    fi
}   #END SUBROUTINE FOR DEPTH-ORDERED NOTEBOOK STYLE.



#========================================
#===== NOTEBOOK STYLE #3 SUBROUTINE =====
function style_chronologic {
    notebook_name="$notebook_dir/NOTEBOOK_${notebook_dir}_Chronologic.txt"
    if test -f $notebook_name; then
	echo 
	echo "A file named $notebook_name exists; skipping this step to prevent overwriting!"
	echo 
	:   #DO NOTHING, SUCCESSFULLY.
    else
	#PRINT THIS "MAN PAGE" AT THE TOP OF THE NOTEBOOK BEING COMPILED:
	echo "********************************************************************************"              > $notebook_name  
	printf "**  %-72s  **\n" ""									    >> $notebook_name
	printf "**  %-72s  **\n" $notebook_name								    >> $notebook_name
	printf "**  %-72s  **\n" "Date compiled:    $date4y"						    >> $notebook_name
	printf "**  %-72s  **\n" ""									    >> $notebook_name
	printf "**  %-72s  **\n" "In this notebook style (\"Chronologic\"), individual note files are"      >> $notebook_name
	printf "**  %-72s  **\n" "printed in the notebook in semi-chronological order. That is, they"       >> $notebook_name
	printf "**  %-72s  **\n" "are first grouped according to the dates in their filenames, & then"	    >> $notebook_name
	printf "**  %-72s  **\n" "they are sorted according to the \"last modified time\". However,"	    >> $notebook_name
	printf "**  %-72s  **\n" "this implicitly relies on the assumption that-- for the most part--"	    >> $notebook_name
	printf "**  %-72s  **\n" "notes are not edited long after they are created."			    >> $notebook_name
	printf "**  %-72s  **\n" ""									    >> $notebook_name
	echo "********************************************************************************"             >> $notebook_name
	echo >> $notebook_name
	echo >> $notebook_name   #EXTRA BLANK LINES BETWEEN "MAN" PAGE & ACTUAL NOTES.
	echo >> $notebook_name

	counter=1
	note_days=(`ls -R $notebook_dir | grep -o -e "note_..-..-..[a-z]\.txt" | cut -c 1-13 | sort | uniq`)
	for day in ${note_days[@]}; do
	    echo "Processing notes \"$day*\"..."
	    all_notes_from_day=(`find $notebook_dir -name ${day}?\.txt -type f`)
	    for note in ${all_notes_from_day[@]}; do
		mod_time=`stat $note | grep Modify`
		echo "$mod_time    $note"
	    done | sort | awk '{print $5}' > __TMP_$$

	    for note_file in `cat __TMP_$$`; do
		if ! ((counter % 50)); then
                    echo "$counter note files processed..."
                fi
		echo ">>>>>  $note_file  <<<<<" >> $notebook_name		
		cat $note_file >> $notebook_name   #
                counter=$((counter+1))             #PROGRESS COUNTER OF INDIVIDUAL NOTE FILES BY 1.
	    done                                   #END "cat EACH INDIVIDUAL NOTE FILE" LOOP.
	done                                       #END "ORGANIZE EACH UNIQUE DAY'S NOTES" LOOP.
	counter=$((counter-1))                     #FIX OVER-COUNTING FROM LAST LOOP.
	echo "...Processed a total of $counter note files."
	rm __TMP_$$                                #DELETE TEMPORARY FILE THAT HELD PROPER NOTES' cat ORDER.
    fi                                             #END "IF NOTEBOOK FILE DOES NOT ALREADY EXIST" LOOP.
}   #END SUBROUTINE FOR SEMI-CHRONOLOGICALLY-ORDERED NOTEBOOK STYLE.



#===================================================
#===== PRINT HELP/MAN PAGE OR CREATE NOTEBOOKS =====
args=("$@")                           #SAVE ALL COMMANDLINE ARGUMENTS TO THE SCRIPT TO A MORE READABLE ARRAY NAME.
if [[ "${args[@]}" =~ "-h" ]]; then   #IF ANY ONE OF THE INPUT ARGUMENTS CONTAINS THE STRING "-h", THEN...
    help                              #...EXECUTE THE "help" SUBROUTINE TO PRINT HELP PAGE, THEN...
    exit 1                            #...EXIT SCRIPT.
else                                  #HOWEVER, IF THE HELP PAGE WAS NOT REQUESTED, THEN...
    date4y=`date +%m/%d/%Y`
    notebook_dir=${args[0]}
    if [[ "$notebook_dir" =~ "/" ]]; then
	echo
	echo "Remove the / from your project directory name!";
	echo 
	exit 1
    else

	if [[ "${args[@]}" =~ "-c" ]]; then
	    echo "Creating a semi-chronologically-ordered notebook..."
	    style_chronologic
	fi
	if [[ "${args[@]}" =~ "-d" ]]; then
	    echo "Creating a notebook ordered by subdirectory depths..."
	    style_depthorder
	fi
	if [[ "${args[@]}" =~ "-f" ]]; then
	    echo "Creating a notebook based on the order of a \"find\" command..."
	    style_findorder
	fi

    fi
fi



### POSSIBLE TO-DO LIST:
###     1. Consider whether you might want to add a style that prints in last-
###        modified-time chronological order, similar to style #3... But I don't
###        think you really want this...
###     2. Consider adding a "tree" section at the top of the NOTEBOOK_* files!
###        However, you should learn how to omit similar directories, e.g.
###        you would not want to print 100 lines for the con???/ dir.s in every
###        QM-MM_??/ dir.!
