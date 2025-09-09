
proc test_alter_file { filename } {

    set result [exec_db_command "test" "psql" $filename]
}

proc create_file { script filename } {

    if [catch {open $filename w} fId] {
	ns_puts "Could not open script file because $fId."
    } else {
	puts $fId $script    
    }
    close $fId
}


proc create_alter_script_file { script filename } {

    if [catch {open $filename w} fId] {
	ns_puts "Could not open script file because $fId."
    } else {
	foreach item $script {
	    puts $fId $item    
	}
	close $fId
    }
}

proc test_alter_script { type } {

    set filename [nsv_get . test_script_path]
    create_alter_script_file [nsv_get . alter_$type] $filename
    test_alter_file $filename
}

proc test_script { type } {

    log_start_item "Beginning Testing Alter Type $type"
    switch $type {
	file { test_alter_file [nsv_get . pgdiff_file] }
	all { 
	    test_alter_script tables
	    test_alter_script index
	    test_alter_script seq
	    test_alter_script function
	    test_alter_script constraint
	    test_alter_script other
	}
	default { test_alter_script $type }
    }
    log_stop_item "Beginning Testing Alter Type $type"
    
}

