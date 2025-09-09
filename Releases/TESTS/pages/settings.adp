<%

ns_puts "<HTML><BODY><H1>PGDIFF Settings</H1>"

ns_puts "<BR><TABLE CELLSPACING='3'>
<TR><TD ALIGN='RIGHT'>Postgresql Version: </TD><TD>[nsv_get . pg_version]</TD></TR>
<TR><TD ALIGN='RIGHT'>Online Demo Version: </TD><TD>"

if {[nsv_get . demo_mode]} {
    ns_puts "Yes"
} else {
    ns_puts "No"
}

ns_puts "</TD></TR>
<TR><TD ALIGN='RIGHT'>Postgresql Bin Path: </TD><TD>[nsv_get . pg_bin_path]</TD></TR>
<TR><TD ALIGN='RIGHT'>Test Schema Path: </TD><TD>[nsv_get . test_schema_path]</TD></TR>
<TR><TD ALIGN='RIGHT'>Test Script Path: </TD><TD>[nsv_get . test_script_path]</TD></TR>
<TR><TD ALIGN='RIGHT'>File Path for Type 2 Target Schema: </TD><TD>[nsv_get . type2_in_filename]</TD></TR>
<TR><TD ALIGN='RIGHT'>Rename Columns Option: </TD><TD>"

if {[nsv_get . rename_cols]} {
    ns_puts "Yes Rename if Column Same Except Name"
} else {
    ns_puts "No - Drop Old Column and Create New One"
}

ns_puts "</TD></TR></TABLE></BODY></HTML>"

%>

