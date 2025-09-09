<%

set_form_vars

if {[info exists action]} {

    if {[nsv_get . demo_mode] == 1} {
	if {$action != "rebuild"} {
	    check_demo_user
	} else {
	    reset_index_map 1
	    reset_demo	
	    login_demo_user
	    nsv_set . pgdiff_file ""
	}
    }

    switch $action {
	rebuild {
	    if {[info exists textsql]} {
		
		if {[nsv_get . security] == 1} {
		    set source_sql [nsv_get test_source_schema $test_type]
		    set target_sql [nsv_get test_target_schema $test_type]
		}

		nsv_set . db_source pgdiff_1
		nsv_set . db_target pgdiff_2

		create_file $source_sql [nsv_get . test_schema_path]
		reset_db pgdiff_1 [nsv_get . test_schema_path]
		nsv_set . db_source_schema $source_sql
	
		create_file $target_sql [nsv_get . test_schema_path]
		reset_db pgdiff_2 [nsv_get . test_schema_path]
		nsv_set . db_target_schema $target_sql

		dump_main_schemas
		set results [compare_all_main db_source db_target] 	
		update_log 2
		pgdiff_top
		display_log_items 2
		ns_puts "All scripts constructed."

	    } else {
		if {![info exists source] || ![info exists target]} {
		    logout_demo_user	
		    error_page "The Source and Target db must be picked."
		} elseif {$source == $target} {
		    logout_demo_user
		    error_page "The Source and Target db cannot be the same."
		} else {
		    nsv_set . db_source $source
		    nsv_set . db_target $target
		    dump_main_schemas
		    set results [compare_all_main db_source db_target] 	
			
		    pgdiff_top 
		    ns_puts "All scripts constructed."
		}
	    }
	}
 
	logout { 
	    logout_demo_user
	    ns_returnredirect "index.adp"
	}

	show {
	    if {[info exists type] && [info exists db]} {
		pgdiff_top 
		set db_objects [nsv_get $db $type]
		ns_puts "<CENTER><B>DB ([string range $db 3 end]) Schema Object ($type) Summary</B></CENTER>"
		foreach object $db_objects {
		    ns_puts "<HR>"
		    if {$type == "tables" && [nsv_get . alter_$type] != ""} {
			set tablename [lindex $object 0]
			ns_puts "<A HREF='main.adp?action=compare&table=[ns_urlencode $tablename]'>$tablename</A><BR>"
		    }
		    ns_puts "<PRE> [lindex $object 1] </PRE>"
		}
	    }
	}
	
	compare {
	    if {[info exists table]} {
		pgdiff_top 
		set found 0
		ns_puts "<CENTER><B>Table Comparison ($table)</B></CENTER><HR>"
		set db_objects [nsv_get db_source tables]
		foreach object $db_objects {
		    set objname [lindex $object 0]
		    if {$objname == $table} {
			set found 1
			set source_table [lindex $object 1]
		    }
		}
		set db_objects [nsv_get db_target tables]
		foreach object $db_objects {
		    set objname [lindex $object 0]
		    if {$objname == $table} {
			set found 1
			set target_table [lindex $object 1]
		    }
		}
		if {$found != 1} {
		    ns_puts "Table Not Found"
		} else {
		    ns_puts "<TABLE WIDTH='800'><TR>"
		    if [info exists source_table] {
			ns_puts "<TD VALIGN='top' WIDTH='400'><B>SOURCE TABLE INFO</B><BR><PRE>$source_table</PRE>"
			
			display_indexs db_source $table
			ns_puts "</TD>"
		    }
		    if [info exists target_table] {
			ns_puts "<TD VALIGN='top' WIDTH='400'><B>TARGET TABLE INFO</B><BR><PRE>$target_table</PRE>"
			display_indexs db_target $table	
			ns_puts "</TD>"
		    }
		    ns_puts "</TR></TABLE>"
		}
	    }
	}
 
	view {
	    pgdiff_top 
	    ns_puts "<B>VIEW ALTER SCRIPT: $type</B><HR>"
	    view_script $type
	} 

	modify {
	    pgdiff_top 
	    ns_puts "<B>MODIFY ALTER SCRIPT: $type</B><HR>"
	    # Make sure security is not on for public servers allowing
	    # adding of malicious sql
	    if {[info exists mod_type] && [nsv_get . security] != 1} {
		switch $mod_type {
		    "delete" { delete_script_item $type $index }
		    "insert" { insert_script_item $type $index }
		    "edit" { edit_script_item $type $index } 
		    "replace" { replace_script_item $type $index $text } 
		    "newitem" { new_script_item $type $index $text }
		}
	    } else {
		modify_script $type
	    } 
	}

	save {
	    if [info exists filename] {
		nsv_set . alter_script ""
		set all_scipts 0
		if {[info exists all]} {
		    set all_scipts 1
		}
		set attributes [list tables index seq function constraint other]
		foreach attr $attributes {
		    if {[info exists $attr] || $all_scipts == 1} {
			nsv_append . alter_script [get_items [nsv_get . alter_$attr]]
		    }	 
		}   
		set script [nsv_get . alter_script]
		if {$filename != ""} {
		set filepath [ns_normalizepath $filename]
		    if {[file exists $filename] && [regexp {^/tmp/} $filepath] != 1} {
			set status "Could not Create File: $filename<BR>File not in /tmp and exists<BR>"
		    } else {
			if [catch {open $filename w} fId] {
			    set status "Could not open script file because $fId.<BR><BR>"
			} else {
			    puts $fId $script     
			    close $fId
			    set status "Created Sciptfile: $filename<BR><BR>"
			    nsv_set . pgdiff_file $filename
			}
		    }
		}
		pgdiff_top 
		ns_puts "$status<B>Alter Scipt:<BR><PRE>$script</PRE>"	
	    } 
	}

	create {	
	    set showscripts 1
	    switch -exact $type {
		"tables" { 
		    set results [compare_tables db_source db_target] 
		    nsv_set . alter_tables $results
		}
		"index" { 
		    set results [compare_indexs db_source db_target] 
		    nsv_set . alter_index $results
		}
		"seq" { 
		    set results [compare_seqs db_source db_target] 
		    nsv_set . alter_seq $results
		}
		"function" { 
		    set results [compare_functions db_source db_target]
		    nsv_set . alter_function $results 
		}
		"constraint" { 
		    set results [compare_constraints db_source db_target]
		    nsv_set . alter_constraint $results
		}
		"other" { 
		    set results [compare_others db_source db_target]
		    nsv_set . alter_other $results
		}
		"all" { 
		    set results [compare_all_main db_source db_target] 
		    set showscripts 0
		}
	    }
	    pgdiff_top 
	    if {$showscripts} {
		ns_puts "ALTER SCRIPT:<BR><PRE>[get_items $results]</PRE>"
	    } else {
		ns_puts "All scripts constructed."
	    }
	}

	clear {
	    clear_cache $type
	    pgdiff_top 
	    ns_puts "<BR><B>$type Cache Cleared.</B>"
	} 

	default {
	    pgdiff_top 
	}
    }
} else {
    pgdiff_top 
}
ns_puts "</BODY></HTML>"

%>

