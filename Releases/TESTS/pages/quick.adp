<%

set_form_vars

if {[nsv_get . demo_mode] == 1} {
    if {$action != "rebuild"} {
	check_demo_user
    } else {
	login_demo_user
    }
}

reset_db pgdiff_1 [nsv_get . type2_in_filename]

nsv_set . db_source $target
nsv_set . db_target pgdiff_1
nsv_set . pgdiff_file ""
reset_index_map 1
reset_demo	
dump_main_schemas

set results [compare_all_main db_source db_target] 

nsv_set . test_step 1
nsv_set . test_type all
reset_index_map
reset_test_cache
reset_db test [nsv_get . source_schema_path]
dump_test_schemas
compare_all_test db_test db_source

nsv_set . test_step 2
reset_index_map
reset_test_cache
set results [test_script all]
dump_test_schemas	
compare_all_test db_test db_target

update_log 3
pgtest_top 
display_log_items 3
set script [get_script all]

if {$scriptfile != ""} {
    ns_puts "Script File Created: $scriptfile<BR>"
    if {[nsv_get . online] != 1} {
	create_file $script $scriptfile
    }
} else {
    ns_puts "No file was given for create file.<BR>"
}

ns_puts "<BR><B>Alter Script was:</B><BR><PRE>$script</PRE><HR>Differences:<BR>"

set attributes [nsv_get . attributes]
foreach attr $attributes {
    if {[nsv_get db_test-db_target $attr] == "NO"} {
	ns_puts "<B>VIEW DIFFERENCE : $attr</B><HR><PRE>[get_items [nsv_get . alter_test_$attr]]</PRE><HR>"
    }
}

%>

