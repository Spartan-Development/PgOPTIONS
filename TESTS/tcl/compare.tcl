
proc compare_table { table_name source_table target_table db1} {

    set script [list]
    set source [split [string trim $source_table] \n]
    set target [split [string trim $target_table] \n]
    
    for {set i 1} {$i < [expr [llength $source] - 1]} {incr i} {
	set line [string trim [lindex $source $i]]
	regsub {,$} $line "" line
	if {[regexp -nocase {^constraint} $line]} {
	    regexp {\"(.*)} $line match shortline
	    regexp {(.*)\" (.*)} $shortline match con_name con_value
	    set s_con($con_name) $con_value
	} else {
	    regexp {^\"(.*)\" (.*)} $line match name value
	    set s_col($name) $value
	}
    }

    for {set i 1} {$i < [expr [llength $target] - 1]} {incr i} {
	set line [string trim [lindex $target $i]]
	regsub {,$} $line "" line
	if {[regexp -nocase {^constraint} $line]} {
	    regexp {\"(.*)} $line match shortline
	    regexp {(.*)\" (.*)} $shortline match con_name con_value
	    set t_con($con_name) $con_value
	} else {
	    regexp {^\"(.*)\" (.*)} $line match name value
	    set t_col($name) $value
	}
    }

    set fix_col [list]
    set fixed_col [list]
    set del_col [list]
    set add_col [list]
    set same_col [list]
    set new_col [list]
    set rename_col [list]
    
    set replace_con [list]
    set del_con [list]
    set add_con [list]
    set same_con [list]

    set need_special 0

    foreach column [array names s_col] {
	if [info exists t_col($column)] {
	    if {$s_col($column) != $t_col($column)} {
		lappend fix_col $column
		append new_script "-- NOTICE FIXING COLUMN $column from $s_col($column) to $t_col($column)\n\n"
	    } else {
		lappend same_col $column
		lappend import_col $column
		lappend export_col $column
	    }
	} else {
	    lappend del_col $column
	}
    }

    foreach column [array names t_col] {
	if ![info exists s_col($column)] {
	    lappend add_col $column
	    if {[regexp { DEFAULT } $t_col($column)]} {
		set need_special 1
	    } elseif {[regexp { NOT NULL } $t_col($column)] } {
		set need_special 1
	    } 
	}
    }

    # Although constraints wont make it special
    # if it is we can eliminate removing and add at table creation

    foreach constraint [array names s_con] {
	if [info exists t_con($constraint)] {
	    if {$s_con($constraint) != $t_con($constraint)} {
		lappend replace_con $constaint
	    } else {
		lappend same_con $constraint
	    }
	} else {
	    lappend del_con $constraint
	}
    }

    foreach constraint [array names t_con] {
	if ![info exists s_con($constraint)] {
	    lappend add_con $constraint
	}
    }

    # Now we determine if we need the special dump/reload build
    
    if {[nsv_get . rename_cols] == 1} {
	foreach col $del_col {
	    for {set i 0} {$i < [llength $add_col]} {incr i} {
		set compare [lindex $add_col $i]
		if {$s_col($col) == $t_col($compare)} {
		    lappend rename_col $compare
		    set temp [lreplace $add_col $i $i]
		    set add_col $temp
		    set renamecol_text "ALTER TABLE $table_name RENAME COLUMN $col TO $compare;\n"
		    lappend import_col $compare
		    lappend export_col $col
		    append new_script "-- NOTICE RENAMING COLUMN $col to $compare\n\n"
		    break
		}
	    }
	}
    }

    # Now if any deleted columns still exist we need special case
    if {[llength $del_col] > 0} {
	set need_special 1
    }
    
    # Next we determine how to *FIX* columns
    # If it only the DEFAULT that is changed then we just use ALTER
    # If it the type of COL and castable then we can add to import/export
    # Otherwise it is just a NOTICE in LOG and we lose data with new col

    foreach col $fix_col {
	lappend import_col $col
	lappend export_col $col
	set need_special 1
    }

    if {$need_special} {
	
	set db [nsv_get . $db1]
	set dbhandle [ns_db gethandle -timeout 5 $db]
	set sql "SELECT tgargs FROM pg_trigger WHERE tgname NOT LIKE 'pg_%';"

	set row [ns_db select $dbhandle $sql]
	set fk_reconstruct [list]
	set saved_cd [list 0 0 0 0]
	while {[ns_db getrow $dbhandle $row]} {
	    set args [ns_set value $row 0]
	    regsub -all {\\000} $args " " args
	    set arglist [split $args]
	    set alter ""
	    if {[lindex $arglist 1] == $table_name} {
		if {[lindex $arglist 0] != [lindex $saved_cd 0] || [lindex $arglist 1] != [lindex $saved_cd 1] || [lindex $arglist 2] != [lindex $saved_cd 2] || [lindex $arglist 3] != [lindex $saved_cd 3]} {
		    set saved_cd $arglist
		    append alter "ALTER TABLE [lindex $arglist 1] ADD CONSTRAINT "
		    if {[lindex $arglist 0] != "" && [lindex $arglist 0] != "<unnamed>"} {
			set fk [lindex $arglist 0]
		    } else {
			set fk "fk__[lindex $arglist 1]__[lindex $arglist 2]"
		    }
		    append alter $fk " FOREIGN KEY ( [lindex $arglist 4] ) REFERENCES [lindex $arglist 2] ( [lindex $arglist 5] )  "
		    if {[lindex $arglist 3] != "UNSPECIFIED"} {
			append alter " MATCH [lindex $arglist 3] "
		    }
		    append alter ";\n\n"
		    lappend fk_reconstruct $alter
		}	    
	    }
	}
	ns_db releasehandle $dbhandle
	
	if {[llength $fk_reconstruct] > 0} {
            foreach reconstruct $fk_reconstruct {
	        append fk_script $reconstruct
	    }
	    nsv_lappend . fk_reconstruct $fk_script
	}


	nsv_lappend . special_tables $table_name

	append new_script "DROP TABLE pgdiff_tmp_$table_name;\n\n"
	append new_script "SELECT * into pgdiff_tmp_$table_name from $table_name; \n\n"
	append new_script "DROP TABLE $table_name; \n\n"
	
	append new_script "CREATE TABLE \"$table_name\" (\n"

	# First we add the columns that didnt change
	
	for {set i 0} {$i < [llength $same_col]} {incr i} {
	    set col [lindex $same_col $i]
	    append new_script "       \"$col\" "  $s_col($col) ",\n"
	}

	for {set i 0} {$i < [llength $add_col]} {incr i} {
	    set col [lindex $add_col $i]
	    append new_script "       \"$col\" "  $t_col($col) ",\n"
	}

	for {set i 0} {$i < [llength $fix_col]} {incr i} {
	    set col [lindex $fix_col $i]
	    append new_script "       \"$col\" "  $t_col($col) ",\n"
	}

	for {set i 0} {$i < [llength $rename_col]} {incr i} {
	    set col [lindex $rename_col $i]
	    append new_script "       \"$col\" "  $t_col($col) ",\n"
	}

	# Last we add the constraints that didnt change or replace same named
	foreach con $same_con {
	    append new_script "       CONSTRAINT $con $t_con($con),\n"
	}
	foreach con $add_con {
	    append new_script "       CONSTRAINT $con $t_con($con),\n"
	}
	# No need to drop previous constraint of same name
	foreach con $replace_con {
	    append new_script "       CONSTRAINT $con $t_con($con),\n"
	}
	regsub {,.$} $new_script "\n" new_script
	append new_script ");\n\n"

	set next_to_last [expr [llength $import_col] - 1]
	set last_index -1
	for {set i 0} {$i < $next_to_last} {incr i} {
	    append import_col_text "       [lindex $import_col $i],\n"
	    set last_index $i
	}
	append import_col_text "       [lindex $import_col [expr $last_index + 1]]  "

	for {set i 0} {$i < $next_to_last} {incr i} {
	    append export_col_text "       [lindex $export_col $i],\n"
	}
	append export_col_text "       [lindex $export_col [expr $last_index + 1]]\n"
	
	append new_script "INSERT INTO $table_name ( 
$import_col_text ) 
SELECT 
$export_col_text FROM 
       pgdiff_tmp_$table_name;\n\n"
	
	append new_script "DROP TABLE pgdiff_tmp_$table_name;\n\n"

	lappend script $new_script

    } else {

	foreach col $add_col {
	    lappend script "ALTER TABLE $table_name ADD COLUMN $col $t_col($col);\n"
	}

	foreach col $fixed_col {
	    lappend script "ALTER TABLE $table_name $fixcol_text($col);\n"
	}

	foreach col $rename_col {
	    lappend script "$renamecol_text($col);\n"
	}

	foreach con $replace_con {
	    lappend script "ALTER TABLE $table_name DROP CONSTRAINT $constraint;\n"
	    lappend script "ALTER TABLE $table_name ADD CONSTRAINT $constraint $t_con($constraint);\n"
	}

	foreach con $add_con {
	    lappend script "ALTER TABLE $table_name ADD CONSTRAINT $constraint $t_con($constraint);\n"
	}

	foreach con $del_con {
	    lappend script "ALTER TABLE $table_name DROP CONSTRAINT $constraint;\n" 
	}
    }
    return $script 
}

proc compare_tables { db1 db2 } {

    set script ""

    set source_tables [nsv_get $db1 tables]
    set target_tables [nsv_get $db2 tables]

    nsv_set . special_tables [list]
    nsv_set . fk_reconstruct [list]
    
    foreach source_table $source_tables {
	set tablename [lindex $source_table 0]
	set tablecode [lindex $source_table 1]
	set source($tablename) $tablecode
    }

    foreach target_table $target_tables {
	set tablename [lindex $target_table 0]
	set tablecode [lindex $target_table 1]
	set target($tablename) $tablecode
    }

    foreach table [array names source] {
	if [info exists target($table)] {
	    if {$source($table) != $target($table)} {
		set table_script [compare_table $table $source($table) $target($table) $db1]
		if {[llength $table_script] > 0} {
		    lappend script "-- Begin Alter Table $table \n"
		    foreach alter_piece $table_script {
			lappend script $alter_piece
		    }
		    lappend script "-- End Alter Table $table \n"
		}
	    }
	} else {
	    lappend script "DROP TABLE $table; \n"
	}
    }
    foreach table [array names target] {
	if ![info exists source($table)] {
	    lappend script "$target($table) \n"
	}
    }

    foreach table [nsv_get . special_tables] {

	set varname "$db1 $table"
	if {[nsv_exists index_map $varname]} {
	    set i_map [nsv_get index_map $varname]
	    set found 0
	    foreach index_item $i_map {
		if {$found == 0} {
		    lappend script "-- Special Case Table $table Adding back all Indexs\n\n"
		    set found 1
		}
		lappend script "[lindex $index_item 1]\n\n"
	    }
	    if {$found} {
		lappend script "-- Done Adding back all Indexs\n\n"
	    }
	}
    }
    set found 0
    foreach fk_script [nsv_get . fk_reconstruct] {
	if {$found == 0} {
	    lappend script "-- Adding back all Foreign Keys\n\n"
	    set found 1
	}
	lappend script "$fk_script"
    }
    if {$found} {
	lappend script "-- Done Adding back all Foreign Keys\n"
    }
    
    set_compare_text $db1 $db2 tables $script

    return $script
}

proc compare_indexs { db1 db2 } {

    set script ""

    set source_indexs [nsv_get $db1 index]
    set target_indexs [nsv_get $db2 index]

    foreach source_index $source_indexs {
	set indexname [lindex $source_index 0]
	set indexcode [lindex $source_index 1]
	set source($indexname) $indexcode
    }

    foreach target_index $target_indexs {
	set indexname [lindex $target_index 0]
	set indexcode [lindex $target_index 1]
	set target($indexname) $indexcode
    }

    foreach index [array names source] {
	if [info exists target($index)] {
	    if {$source($index) != $target($index)} {
		lappend script "DROP INDEX $index; \n$target($index) \n"
	    }
	} else {
	    # Here we need to check to see if special case occured on table
	    # If so dropping is unnecessary and will create bogus Error in log
	    set index_text $source($index)
	    set comment ""
	    if {[regexp {CREATE  INDEX \"(.*)\" on \"(.*)\" using } $index_text match key table] || [regexp {CREATE UNIQUE INDEX \"(.*)\" on \"(.*)\" using } $index_text match key table]} {
		if {[lsearch -exact [nsv_get . special_tables] $table] != -1} {
		    set comment "-- Note we don't have to drop below index since special case did it for us.\n--"
		}
	    }
	    lappend script "$comment DROP INDEX $index; \n"
	}
    }
    foreach index [array names target] {
	if ![info exists source($index)] {
	    lappend script "$target($index) \n"
	}
    }
    set_compare_text $db1 $db2 index $script

    return $script

}

proc compare_functions { db1 db2 } {
    
    set script ""
    set source_functions [nsv_get $db1 function]
    set target_functions [nsv_get $db2 function]

    foreach source_function $source_functions {
	set functionname [lindex $source_function 0]
	set functioncode [lindex $source_function 1]
	set source($functionname) $functioncode
    }

    foreach target_function $target_functions {
	set functionname [lindex $target_function 0]
	set functioncode [lindex $target_function 1]
	set target($functionname) $functioncode
    }

    foreach function [array names source] {
	if [info exists target($function)] {
	    if {$source($function) != $target($function)} {
		lappend script "DROP FUNCTION $function; \n$target($function) \n"
	    }
	} else {
	    lappend script "DROP FUNCTION $function; \n"
	}
    }
    foreach function [array names target] {
	if ![info exists source($function)] {
	    lappend script "$target($function) \n"
	}
    }
    set_compare_text $db1 $db2 function $script

    return $script
}

proc compare_seqs { db1 db2 } {

    set script ""

    set source_seqs [nsv_get $db1 seq]
    set target_seqs [nsv_get $db2 seq]

    foreach source_seq $source_seqs {
	set seqname [lindex $source_seq 0]
	set seqcode [lindex $source_seq 1]
	set source($seqname) $seqcode
    }

    foreach target_seq $target_seqs {
	set seqname [lindex $target_seq 0]
	set seqcode [lindex $target_seq 1]
	set target($seqname) $seqcode
    }

    foreach seq [array names source] {
	if [info exists target($seq)] {
	    if {$source($seq) != $target($seq)} {
		lappend script "DROP SEQUENCE $seq; \n$target($seq) \n"
	    }
	} else {
	    lappend script "DROP SEQUENCE $seq; \n"
	}
    }
    foreach seq [array names target] {
	if ![info exists source($seq)] {
	    lappend script "$target($seq) \n"
	}
    }
    set_compare_text $db1 $db2 seq $script 

    return $script
}

proc compare_constraints { db1 db2 } {

    set script ""
# Temporarily not worrying about constraints
# Remove next 2 lines .... when done
    set_compare_text $db1 $db2 constraint $script
    return $script
# End Remove
    set source_constraints [nsv_get $db1 constraint]
    set target_constraints [nsv_get $db2 constraint]

    foreach source_constraint $source_constraints {
	set constraintname [lindex $source_constraint 0]
	set constraintcode [lindex $source_constraint 1]
	set source($constraintname) $constraintcode
    }

    foreach target_constraint $target_constraints {
	set constraintname [lindex $target_constraint 0]
	set constraintcode [lindex $target_constraint 1]
	set target($constraintname) $constraintcode
    }

    foreach constraint [array names source] {
	if [info exists target($constraint)] {
	    if {$source($constraint) != $target($constraint)} {
		lappend script "DROP CONSTRAINT $constraint; \n$target($constraint) \n"
	    }
	} else {
	    lappend script "DROP CONSTRAINT $constraint; \n"
	}
    }
    foreach constraint [array names target] {
	if ![info exists source($constraint)] {
	    lappend script "$target($constraint) \n"
	}
    }
    set_compare_text $db1 $db2 constraint $script

    return $script
}

proc compare_others { db1 db2 } {
    
    set script ""
    set source_others [nsv_get $db1 other]
    set target_others [nsv_get $db2 other]

    foreach source_other $source_others {
	set othername [lindex $source_other 0]
	set othercode [lindex $source_other 1]
	set source($othername) $othercode
    }

    foreach target_other $target_others {
	set othername [lindex $target_other 0]
	set othercode [lindex $target_other 1]
	set target($othername) $othercode
    }

    foreach other [array names source] {
	if [info exists target($other)] {
	    if {$source($other) != $target($other)} {
		lappend script "-- DROP OTHER $other; \n$target($other) \n"
	    }
	} else {
	    lappend script "-- DROP OTHER $other; \n"
	}
    }
    foreach other [array names target] {
	if ![info exists source($other)] {
	    lappend script "$target($other) \n"
	}
    }
    set_compare_text $db1 $db2 other $script

    return $script
}


proc compare_all_main { db1 db2 } {
    
    nsv_set . alter_tables [compare_tables $db1 $db2]
    nsv_set . alter_index [compare_indexs $db1 $db2]
    nsv_set . alter_function [compare_functions $db1 $db2]
    nsv_set . alter_seq [compare_seqs $db1 $db2]
    nsv_set . alter_constraint [compare_constraints $db1 $db2]
    nsv_set . alter_other [compare_others $db1 $db2]
    return 1
}


proc compare_all_test { db1 db2 } {
    
    nsv_set . alter_test_tables [compare_tables $db1 $db2]
    nsv_set . alter_test_index [compare_indexs $db1 $db2]
    nsv_set . alter_test_function [compare_functions $db1 $db2]
    nsv_set . alter_test_seq [compare_seqs $db1 $db2]
    nsv_set . alter_test_constraint [compare_constraints $db1 $db2]
    nsv_set . alter_test_other [compare_others $db1 $db2]
    return 1
}
