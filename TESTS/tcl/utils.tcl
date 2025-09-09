proc set_form_vars { } {

    uplevel #0 {
	set form [ns_getform] 
	if {$form != ""} {	
	    set form_size [ns_set size $form]
	    set form_counter_i 0
	    while {$form_counter_i<$form_size} {
		set name [ns_set key $form $form_counter_i]
		set value [ns_set value $form $form_counter_i]
		set $name $value
		incr form_counter_i
	    }
	}
    }
}

proc error_page { error } {

    ns_puts "<HTML><BODY><H1>pgdiff Error encountered</H1><BR><BR>$error</BODY></HTML>"
}

proc startform { action } {
	
    ns_puts "<FORM ACTION=\"$action\" ENCTYPE=\"x-www-form-urlencoded\" METHOD=\"POST\">"

}

proc closeform { buttontext } {
	
    ns_puts "<INPUT TYPE=\"submit\" NAME=\"name\" VALUE=\"$buttontext\"></FORM>"

}

proc reset_cache { db } {
 
    set attributes [list tables index seq function constraint other]
    foreach attr $attributes {
	nsv_set $db $attr [list]
    }
}

proc reset_demo { } {

    set attributes [list tables index seq function constraint other]
    foreach attr $attributes {
	nsv_set db_source-db_target $attr "-"
	nsv_set . alter_$attr [list]
    }	
    
    reset_cache db_source
    reset_cache db_target	
    reset_cache db_test
}


proc reset_test_cache { } {

    set attributes [nsv_get . attributes]
    foreach attr $attributes {
	nsv_set db_test $attr [list]
	nsv_set db_test-db_source $attr "-"
	nsv_set db_test_db_target $attr "-"
    }
}


proc exec_db_command { db db_call {inputfile ""} } {


    switch $db_call {
	"dump" {
	    append pg_cmd [nsv_get . pg_bin_path] "pg_dump"
	    set command "exec $pg_cmd $db -s"
	}
	"psql" {
	    append pg_cmd [nsv_get . pg_bin_path] "psql"
	    set command "exec $pg_cmd $db < $inputfile"
	}
	"drop" {
	    append pg_cmd [nsv_get . pg_bin_path] "dropdb"
	    set command "exec $pg_cmd $db"
	}
	"create" {
	    append pg_cmd [nsv_get . pg_bin_path] "createdb"
	    set command "exec $pg_cmd $db"
	}
	default { return 0 } # CALL NOT SUPPORTED
    }
    ns_log Notice "Calling db command $command"
    if {[catch {eval $command} errMsg]} {
	ns_log Notice "PG results returned:\n$errMsg"
	return 0
    } else {
	return 1
    }
}

proc set_compare_text { db1 db2 type script } {

    append nsvvarname $db1 "-" $db2
    if {$script == ""} {
	nsv_set $nsvvarname $type "YES"
    } else {
	nsv_set $nsvvarname $type "NO"
    }
}

proc reset_db { db schema_filename } {

    log_start_item "Recreating $db from file: $schema_filename"
    set results [exec_db_command $db "drop"]
    set results [exec_db_command $db "create"]
    set results [exec_db_command $db "psql" $schema_filename]
    log_stop_item "Recreating $db from file: $schema_filename"

}



proc delete_script_item { type index } {
    
    set items [nsv_get . alter_$type]
    set item [lindex $items $index]
    set newlist [lreplace $items $index $index]
    nsv_set . alter_$type $newlist
    ns_puts "Deleted Item from Alter Script: $type<BR><PRE>$item</PRE>"
}


proc replace_script_item { type index text } {
    
    set items [nsv_get . alter_$type]
    set item [lindex $items $index]
    set newlist [lreplace $items $index $index $text]
    nsv_set . alter_$type $newlist
    ns_puts "Replaced Item from Alter Script: $type<BR><BR>OldItem:<BR><PRE>$item</PRE><BR><BR>NewItem:<BR><PRE>$text</PRE>"
}


proc new_script_item { type index text } {
    
    set items [nsv_get . alter_$type]
    set item [lindex $items $index]
    append text "\n"
    set newlist [linsert $items $index $text]
    nsv_set . alter_$type $newlist
    ns_puts "Inserted Item in Alter Script: $type<BR><PRE>$text</PRE>"
}


proc insert_script_item { type index } {

    set items [nsv_get . alter_$type]
    set item [lindex $items $index]
    ns_puts "Insert Item Before Alter($type) Script Item:<BR><PRE>$item</PRE>"
    startform "main.adp"
    ns_puts "<INPUT type='hidden' name='action' value='modify'>
<INPUT type='hidden' name='mod_type' value='newitem'>
<INPUT type='hidden' name='type' value='$type'>
<INPUT type='hidden' name='index' value='$index'>
<textarea name='text' cols=70 rows=4></textarea><BR>"
    closeform "Insert Item Into Script"
}
  

proc edit_script_item { type index } {
    
    set items [nsv_get . alter_$type]
    set item [lindex $items $index]
    ns_puts "Edit Item in Alter($type) Script Item:"
    startform "main.adp"
    ns_puts "<INPUT type='hidden' name='action' value='modify'>
<INPUT type='hidden' name='mod_type' value='replace'>
<INPUT type='hidden' name='type' value='$type'>
<INPUT type='hidden' name='index' value='$index'>
<textarea name='text' cols=70 rows=10>$item</textarea><BR>"
    closeform "Edit Alter Script Item"
}


proc alter_row { attr } {

    set found 0
    ns_puts "<TR><TD>Alter: <B>$attr</B></TD><TD><A HREF=main.adp?action=create&type=$attr>ReConstruct</A></TD>"
    if {[nsv_get . alter_$attr] != ""} {
	set found 1
	ns_puts "<TD><A HREF=main.adp?action=clear&type=$attr>Clear</A></TD><TD><A HREF=main.adp?action=view&type=$attr>View </A></TD><TD><A HREF=main.adp?action=modify&type=$attr>Modify</A></TD><TD><A HREF=test.adp?step=1&type=$attr>Test Script</A></TD><TD><INPUT TYPE='checkbox' NAME='$attr'></TD>"
    } else {
	ns_puts "<TD COLSPAN='5'>&nbsp;</TD>"
    }  
    ns_puts "</TR>"    
    return $found
}

proc pg_summary { pageurl db1 db2 } {

    ns_puts "<TABLE BORDER='1'><TR BGCOLOR='#d0d0d0'><TH>DB Object</TH><TH>$db1<BR> ([nsv_get . $db1])</TH><TH>$db2<BR> ([nsv_get . $db2])</TH><TH>Same</TH></TR>"
    set attributes [list tables index seq function other]
    append varname $db1 "-" $db2
    foreach attr $attributes {
	ns_puts "<TR><TD>$attr</TD><TD ALIGN='center'><A HREF=$pageurl?action=show&db=$db1&type=$attr>[llength [nsv_get $db1 $attr]]</TD><TD ALIGN='center'><A HREF=$pageurl?action=show&db=$db2&type=$attr>[llength  [nsv_get $db2 $attr]]</TD><TD ALIGN='center'>[nsv_get $varname $attr]</TD></TR>"
    }
    ns_puts "</TABLE>"
}

proc pgdiff_top { } {
    
    ns_puts "<HTML><BODY><TABLE width='100%' COLSPACING='0'><TR BGCOLOR='#d0d0d0'><TD WIDTH='100'><B>pgdiff: Manange Alter Scripts Page</B></TD><TD>&nbsp;</TD><TD ALIGN='right'><A HREF='doc.html'>Docs</A>&nbsp;&nbsp;&nbsp;<A HREF='log.adp'>Server Log</A>&nbsp;&nbsp;&nbsp;<A HREF='main.adp?action=logout'>Logout of Demo</A>&nbsp;</TD></TR><TR><TD VALIGN='top'><B>Current DB Summary</B><br>"

    pg_summary main.adp "db_source" "db_target"

    ns_puts "</TD><TD>&nbsp;</TD><TD>"

    startform "main.adp"

    ns_puts "<B>Alter DB Scripts</B><TABLE BORDER='1' CELLPADDING='2' VALIGN='top'><TR BGCOLOR='#d0d0d0'><TH>Script</TH><TH COLSPAN='5'>&nbsp;</TH><TH>Include In File</TH></TR>"

    set found 0
    set attributes [list tables index seq function other]
    foreach attr $attributes {
	set found [expr $found + [alter_row $attr]]
    }

    ns_puts "<TR><TD><B>All Scripts</B></TD><TD><A HREF=main.adp?action=create&type=all>ReConstruct</A></TD>"

    if {$found > 0} {
	set filename [nsv_get . pgdiff_file]
	ns_puts "<TD><A HREF=main.adp?action=clear&type=all>Clear</A></TD><TD><A HREF=main.adp?action=view&type=all>View </A></TD><TD>&nbsp;</TD><TD><A HREF=test.adp?step=1&type=all>Test Script</A></TD><TD><INPUT TYPE='checkbox' NAME='all'></TD><TR><TD COLSPAN='7'>FILENAME: <INPUT TYPE='text' NAME='filename' SIZE='50' value='$filename'><INPUT TYPE='hidden' NAME='action' value='save'><BR>"
	if {$filename != ""} {
	    ns_puts "&nbsp;<A HREF=test.adp?step=1&type=file>Test Existing Script File</A>"
	}
	closeform "Create New Alter Scipt File"
    } else {
	ns_puts "<TD COLSPAN='5'> </FORM>&nbsp;"
    }

    ns_puts "</TD></TR></TABLE></TD></TR></TABLE><HR>"

}


proc pgtest_top { } {

    if {[nsv_get . test_step] == 1}  {
	set other_db "db_source"
    } else {
	set other_db "db_target"
    }

    ns_puts "<HTML><BODY><TABLE width='100%' COLSPACING='0'><TR BGCOLOR='#d0d0d0'><TD><B>pgdiff: Testing Page - Step [nsv_get . test_step]</B></TD>"

    if {[nsv_get . test_step] == 1}  {
	 ns_puts "<TD><B><A HREF='test.adp?step=2'>Perform Testing Stage 2</A></B></TD>"
    }

    ns_puts "<TD><A HREF='main.adp'>Return to Alter Scripts Page</A></TD><TD ALIGN='right'><A HREF='doc.html'>Docs</A>&nbsp;&nbsp;&nbsp;<A HREF='log.adp'>Server Log</A>&nbsp;&nbsp;&nbsp;<A HREF='main.adp?action=logout'>Logout of Demo</A>&nbsp;</TD></TR></TABLE><BR>
    Testing for Alter Script Type: <B>[nsv_get . test_type]</B> "
   
    if {[nsv_get . test_step] == 1}  {
	ns_puts "(Not Yet Applied in Step 2)"
    }
	
    ns_puts " <A HREF='test.adp?action=script'>View Script</A><BR><BR><B>Current Test DB Summary</B>"

    pg_summary "test.adp" db_test $other_db
    ns_puts "<BR>"
}


proc display_indexs { target_db table_name } {

    append varname $target_db " " $table_name
    if [nsv_exists index_map $varname] {
	set i_map [nsv_get index_map $varname]
	
	ns_puts "<HR>Indexs for Table:<BR>"
	
	foreach index_item $i_map {
	    ns_puts "<B>[lindex $index_item 0]</B>:<BR>[lindex $index_item 1]<BR><BR>"
	}	
    }
}

proc process_chunk { target_db chunk } {

    set chunk [string trim $chunk]
    set schema [split $chunk \n]
    set firstline [lindex $schema 0]
    if {[regexp {CREATE TABLE \"(.*)\"} $firstline match key]} {
	nsv_lappend $target_db tables [list $key $chunk] 
    } elseif {[regexp {CREATE  INDEX \"(.*)\" on \"(.*)\" using } $firstline match key table] || [regexp {CREATE UNIQUE INDEX \"(.*)\" on \"(.*)\" using } $firstline match key table]} {
	nsv_lappend $target_db index [list $key $chunk] 
	set varname "$target_db $table"
	nsv_lappend index_map $varname [list $key $chunk]

    } elseif {[regexp {CREATE FUNCTION \"(.*)\"} $firstline match key]} {
	nsv_lappend $target_db function [list $key $chunk] 
    } elseif {[regexp {CREATE SEQUENCE \"(.*)\"} $firstline match key]} {
	nsv_lappend $target_db seq [list $key $chunk] 
    } elseif {[regexp {CREATE CONSTRAINT TRIGGER \"(.*)\"} $firstline match key]} {
	nsv_lappend $target_db constraint [list $key $chunk] 
    } else {
	nsv_lappend $target_db other [list 0 $chunk] 	
    }	
}

proc reset_index_map { { all 0 }  } {
    set temp_cache(0) 0
    if {$all} {
	nsv_array reset index_map [array get temp_cache]
    } else {
	foreach name [nsv_array names index_map] {
	    if {[regexp {^db_test} $name]} {
		nsv_unset index_map $name
	    }
	}
    }
}

proc parse_schema { target_db db_schema } {

    set schema [split $db_schema \n]
    set chunk ""
    nsv_set $target_db schema [list]

    for {set i 9} {$i < [llength $schema]} {incr i} {
	set line [lindex $schema $i]
	if {[regexp {\\connect } $line]} {
	    continue
	}
	if {[string range $line 0 1] == "--" && [string range [lindex $schema [expr $i + 1]] 0 9] == "-- TOC Ent"} {
	    if {$chunk != ""} {
		nsv_lappend $target_db schema $chunk
		process_chunk $target_db $chunk
		set chunk ""
	    }
	    set i [expr $i + 4]
	    continue
	}
	append chunk $line "\n"
    }
    set chunk [string trim $chunk]
    if {$chunk != ""} {
	nsv_lappend $target_db schema $chunk
	process_chunk $target_db $chunk
    }
}

proc dump_main_schemas { } {

    set pg_dump [nsv_get . pg_dump_path]
    set db [nsv_get . db_source]
    set options "-s"
    set schema [exec $pg_dump $options $db]

    nsv_set . db_source_schema $schema
    if [catch {open [nsv_get . source_schema_path] w} fId] {
	ns_puts "Could not open schema file because $fId."
    } else {
	puts $fId $schema     
	close $fId
    }
    parse_schema "db_source" $schema
    set db [nsv_get . db_target]
    set options "-s"
    set schema [exec $pg_dump $options $db]
    nsv_set . db_target_schema $schema	
    parse_schema "db_target" $schema
}

proc dump_test_schemas { } {

    set pg_dump [nsv_get . pg_dump_path]
    set db test
    set options "-s"
    set schema [exec $pg_dump $options $db]
    nsv_set . db_test_schema $schema
    parse_schema "db_test" $schema
}

proc get_items { items } {
    
    set results ""
    foreach item $items {
	append results $item "\n"
    }
    append results "\n"
    return $results
}


proc clear_cache { type } {

    switch -exact $type {
	"other" { nsv_set . alter_other [list] }
	"constraint" { nsv_set . alter_constraint [list] }
	"seq" { nsv_set . alter_seq [list] }
	"index" { nsv_set . alter_index [list] }
	"function" { nsv_set . alter_function [list] }
	"tables" { nsv_set . alter_tables [list] }
	"all" { 
	    nsv_set . alter_tables [list]
	    nsv_set . alter_index [list]
	    nsv_set . alter_function [list]
	    nsv_set . alter_constraint [list]
	    nsv_set . alter_seq [list]
	    nsv_set . alter_other [list]
	}
    }
}


proc modify_items { type items } {

    set results ""
    set count 0
    set item_size [llength $items]
    for {set i 0} {$i < $item_size} {incr i} {
	set item [lindex $items $i]
	append results "<HR><A HREF='main.adp?action=modify&mod_type=edit&type=$type&index=$i'>Edit</A> &nbsp; <A HREF='main.adp?action=modify&mod_type=delete&type=$type&index=$i'>Delete</A> &nbsp; <A HREF='main.adp?action=modify&mod_type=insert&type=$type&index=$i'>Insert</A><BR> <PRE>$item</PRE><BR>"
    }
    append results "<BR>"
    return $results    

}

proc modify_script { type } {
   
	if {$type == "all"} {
	    ns_puts "<PRE>[get_items [nsv_get . alter_tables]]
[get_items [nsv_get . alter_index]]
[get_items [nsv_get . alter_seq]]
[get_items [nsv_get . alter_function]
[get_items [nsv_get . alter_constraint]
[get_items [nsv_get . alter_other]]
	    </PRE>"
	} else {
	    ns_puts "[modify_items $type [nsv_get . alter_$type]]"
    }
}


proc get_script { type } {
   
    if {$type == "all"} {
	set script "[get_items [nsv_get . alter_tables]]
[get_items [nsv_get . alter_index]]
[get_items [nsv_get . alter_seq]]
[get_items [nsv_get . alter_function]]
[get_items [nsv_get . alter_constraint]]
[get_items [nsv_get . alter_other]]"
    } else {
	set script [get_items [nsv_get . alter_$type]]
    }
    return $script
}

proc view_script { type } {
   
    ns_puts "<PRE>[get_script $type]</PRE>"
}
 
proc log_start_item { description } {

    set demo_session_id [nsv_get . demo_session_id]
    set log_id [nsv_incr . log_id]
    ns_log Notice "PGLOG :: $demo_session_id :: $log_id :: START :: $description"
    
}

proc log_stop_item { description } {

    set demo_session_id [nsv_get . demo_session_id]
    set log_id [nsv_get . log_id]
    ns_log Notice "PGLOG :: $demo_session_id :: $log_id :: STOP :: $description"

}

proc update_log { num_items } {

    set demo_session_id [nsv_get . demo_session_id]
    set log_id [nsv_get . log_id]
    set seek_log_id [expr $log_id - $num_items]

    set logsize [expr $num_items * 10000]

    for {set i seek_log_id} {$i < $demo_session_id} {incr i} {
	nsv_set log_data $i [list "" ""]
    }

    if [catch {
    ## Server log can be very small so make sure requested size won't kill us.
	set filesize [file size [ns_info log]]
	set fd [open [ns_info log]]
	if { $filesize > $logsize } {
	    seek $fd -$logsize end
	} else {
	    seek $fd 0 start
	}
	set log_tail [read $fd]
    } errMsg] {
	ns_log error "[ns_conn url]: error accessing log: \"$errMsg\""
	ns_puts "Unable to access server.log: error \"$errMsg\""
    }
    close $fd

    set log_lines [split $log_tail \n]
    set inchunk 0
    foreach line $log_lines {

	if {[regexp {PGLOG :: (.*) :: (.*) :: START :: (.*)} $line match demo_id log_id log_title]} {
	    if {$demo_id != [nsv_get . demo_session_id] || $log_id < $seek_log_id} {
		continue
	    }
	    set errors ""
	    set logtext ""
	    set inchunk 1
	    continue
	} 
	if {$inchunk != 1} {
	    continue
	}
	if {[regexp {PGLOG :: (.*) STOP ::} $line]} {
	    nsv_set log_data $log_id [list $log_title $errors $logtext]
	    set inchunk 0
	} else {
	    if {[regexp { Notice:} $line] != 1} {
		append logtext $line "\n"
		if {[regexp {^ERROR:} $line]} {
		    if {![regexp {pgdiff_tmp_.*does not exist} $line]} {
			append errors $line "\n"
		    }
		}
	    }
	}
    } 
}

proc display_log_items { num_items } {

    set cur_id [nsv_get . log_id]
    ns_puts "<HR><B>Log Summary for Actions:</B><BR>"
    for {set i [expr $cur_id - $num_items + 1]} {$i <= $cur_id} {incr i} {
	set log_item [nsv_get log_data $i]
	ns_puts "<A HREF='log.adp?log_id=$i'>[lindex $log_item 0]</A><BR>"
	if {[lindex $log_item 1] == ""} {
	    ns_puts "No Errors Reported"
	} else {
	    ns_puts "<PRE>[lindex $log_item 1]</PRE>"
	}
	ns_puts "<BR><BR>"
    }
    ns_puts "<HR>"
}

proc recreate_test_dbs { } {

    exec_db_command test drop
    exec_db_command test create
    exec_db_command pgdiff_1 drop
    exec_db_command pgdiff_1 create
    exec_db_command pgdiff_2 drop
    exec_db_command pgdiff_2 create

}

recreate_test_dbs

proc admin_top {} {

ns_adp_puts "
<HTML><HEAD><TITLE>PGDIFF ADMIN</TITLE></HEAD><BODY BGCOLOR=\"#ffffff\">
<TABLE BORDER=\"1\">
<TR><TD><A HREF=\"index.adp\">ADMIN MAIN </A></TD></TR>
<TR><TD><A HREF=\"nsv.adp\">NSV Vars</A></TD></TR></TABLE><BR>"

}
