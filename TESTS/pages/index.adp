<%

set_form_vars

ns_puts "<HTML><BODY><H1>PGDIFF</H1>"

if {[nsv_get . demo] != 0} {
    ns_puts "Demo is currently in use, try back in a few minutes or checkout our <B><A HREF='doc.html'>docs and usage</A></B><BR><BR>"
} else {

    ns_puts "This is the demo of <B>pgdiff</B> which is used to create alter scripts for updating Postgresql Database schemas from a source schema into a target schema. No changes are made to the target db instead a test db is loaded with the source schema and then the alter scripts are applied and a comparison is done between the test and target db.  For more info and before running we recommend you checkout the <B><A HREF='doc.html'>Documentation</A></B> or view the <B><A HREF='settings.adp'>Demo Settings</A></B>"

    ns_puts "<BR><BR><TABLE BORDER='1'><TR><TD WIDTH='50%' VALIGN='top'><TABLE  WIDTH='100%' HEIGHT='100%'><TR><TD><B><I>Type I</I></B> <A HREF='more.adp?type=1'>More Info</A>"

    if {[nsv_get . db_source_widget] == ""} {
	ns_puts "<BR><BR> There are no databases setup in the aolserver configuration file to use this type of demo."
    } else {

	startform "main.adp"
	ns_puts "<INPUT TYPE='hidden' name='action' value='rebuild'><TABLE><TR><TH>Source DB</TH><TH>&nbsp;</TH><TH>Target DB</TH></TR><TR><TD>[nsv_get . db_source_widget]</TD><TD>&nbsp;</TD><TD>[nsv_get . db_target_widget]</TD></TR></TABLE>"
	closeform "Pick Databases for Source & Target"
    }

    ns_puts "</TD></TR></TABLE></TD><TD WIDTH='50%' VALIGN='top'><B><I>Type II</I></B> <A HREF='more.adp?type=2'>More Info</A>"

    if {[nsv_get . db_source_widget] == ""} {
	ns_puts "<BR><BR> There are no databases setup in the aolserver configuration file to use this type of demo."
    } else {

	startform "quick.adp"

	ns_puts "<B>Source DB</B><BR>[nsv_get . db_target_widget]<BR><B>Target DB</B><BR><INPUT TYPE='hidden' name='action' value='rebuild'>Input File:"

	if {[nsv_get . online] == 1} {
	    ns_puts " <I>Since this is the online demo we always use a test file</I>"
	}

	ns_puts "<BR><INPUT NAME='inputfile'  TYPE='text' SIZE='30' VALUE='[nsv_get . type2_in_filename]'><BR><BR>Output Alter Script File:<BR><INPUT NAME='scriptfile' TYPE='text' SIZE='30'>"

	closeform "Pick Databases for Source & Target"
    }

    ns_puts "</TD></TR><TR><TD COLSPAN='2'><B><I>Type III</I></B>  <A HREF='more.adp?type=3'>More Info</A><BR><BR>"
    
    if {![info exists test_type]} {
	set test_type 0
    }

    startform "index.adp"

    if {![info exists test_type]} {
	set test_type 0
    } 

    ns_puts "<SELECT NAME='test_type'><OPTION VALUE='0' "

    if {$test_type == 0} {
	ns_puts "SELECTED"
    }

    ns_puts ">Clear Schemas<OPTION VALUE='1' "

    if {$test_type == 1} {
	ns_puts "SELECTED"
    }

    ns_puts ">Adding and Dropping Schemas Objects (Simple)<OPTION VALUE='2' "

    if {$test_type == 2} {
	ns_puts "SELECTED"
    }

    ns_puts ">Alter Table: Dropping Column<OPTION VALUE='3' "

    if {$test_type == 3} {
	ns_puts "SELECTED"
    }

    ns_puts ">Alter Table: Adding Primary Key<OPTION VALUE='4' "

    if {$test_type == 4} {
	ns_puts "SELECTED"
    }

    ns_puts ">Alter Table: Changing Null to Not Null<OPTION VALUE='5' "

    if {$test_type == 5} {
	ns_puts "SELECTED"
    }

    ns_puts ">Alter Table: Renaming a Column + Removing Column<OPTION VALUE='6' "

    if {$test_type == 6} {
	ns_puts "SELECTED"
    }

    ns_puts ">Changing a Column Type</SELECT>"

    closeform "Fill in the Text Boxes with Example Schemas"

    ns_puts "<BR>"

    startform "main.adp"

    if {[info exists test_type]} {
	ns_puts "<INPUT TYPE=hidden NAME='test_type' VALUE='$test_type'>"
    }

    ns_puts "<INPUT TYPE='hidden' name='action' value='rebuild'><INPUT TYPE='hidden' name='textsql' value='1'><B>Source DB Schema:</B><BR><TEXTAREA NAME='source_sql' rows='15' cols='100'>"
    
    if {[info exists test_type]} {
	ns_puts [nsv_get test_source_schema $test_type]
    }

    ns_puts "</textarea><BR><BR><B>Target DB Schema:</B><BR><TEXTAREA NAME='target_sql' rows='15' cols='100'>"

    if {[info exists test_type]} {
	ns_puts [nsv_get test_target_schema $test_type]
    }

    ns_puts "</textarea><BR>"

    closeform "Create Alter Scripts for Source & Target Schemas"
    
    ns_puts "</TD></TR></TABLE>"

}

ns_puts "</BODY></HTML>"

%>

