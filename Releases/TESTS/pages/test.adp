<%

set_form_vars

if {[nsv_get . demo_mode]} {
    check_demo_user
}

if {[info exists step]} {
    if {$step == 1} {
	nsv_set . test_step 1
	nsv_set . test_type $type
	reset_index_map
	reset_test_cache
	reset_db test [nsv_get . source_schema_path]
	dump_test_schemas
	compare_all_test db_test db_source
	update_log 1	
	pgtest_top 
	display_log_items 1
    } else {
	nsv_set . test_step 2
	reset_index_map
	reset_test_cache
	set type [nsv_get . test_type]
	set results [test_script $type]
	dump_test_schemas	
	compare_all_test db_test db_target
	update_log 1	
	pgtest_top 
	display_log_items 1
	set attributes [nsv_get . attributes]
	foreach attr $attributes {
	    if {[nsv_get db_test-db_target $attr] == "NO"} {
		ns_puts "<B>VIEW DIFFERENCE : $attr</B><HR><PRE>[get_items [nsv_get . alter_test_$attr]]</PRE><HR>"
	    }
	}
    }
} elseif {[info exists action]} {

    if {$action == "show"} {
 
	if {[info exists type] && [info exists db]} {
	    pgtest_top
	    set db_objects [nsv_get $db $type]
	    ns_puts "<CENTER><B>DB ([string range $db 3 end]) Schema Object ($type) Summary</B></CENTER>"
	    foreach object $db_objects {
		ns_puts "<HR>"
		if {$type == "tables" && [nsv_get . alter_$type] != ""} {
		    set tablename [lindex $object 0]
		    ns_puts "<A HREF='test.adp?action=compare&table=[ns_urlencode $tablename]'>$tablename</A><BR>"
		}
		ns_puts "<PRE> [lindex $object 1] </PRE>"
	    }
	}
    } elseif {$action == "script"} {
	pgtest_top
	ns_puts "<B>VIEW ALTER SCRIPT: [nsv_get . test_type]</B><HR>"
	if {[nsv_get . test_type] == "file"} {
	    ns_puts "<PRE>"
	    ns_adp_include [nsv_get . pgdiff_file]
	    ns_puts "</PRE>"
	} else {
	    view_script [nsv_get . test_type]
	}
    } elseif {$action == "compare"} {
	if {[nsv_get . test_step] == 1} {
	    set db "db_source"
	} else {
	    set db "db_target"
	}
	pgtest_top	
	set found 0
	ns_puts "<CENTER><B>Table Comparison ($table)</B></CENTER><HR>"
	set db_objects [nsv_get db_test tables]
	foreach object $db_objects {
	    set objname [lindex $object 0]
	    if {$objname == $table} {
		set found 1
		set source_table [lindex $object 1]
	    }
	}
	set db_objects [nsv_get $db tables]
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
		ns_puts "<TD VALIGN='top' WIDTH='400'><B>db_test TABLE INFO</B><BR><PRE>$source_table</PRE>"
		display_indexs db_test $table	
		ns_puts "</TD>"
	    }
	    if [info exists target_table] {
		ns_puts "<TD VALIGN='top' WIDTH='400'><B>$db TABLE INFO</B><BR><PRE>$target_table</PRE>"
		display_indexs $db $table	
		ns_puts "</TD>"
	    }
	    ns_puts "</TR></TABLE>"
	}
    }
}

ns_puts "</BODY></HTML>"

%>

