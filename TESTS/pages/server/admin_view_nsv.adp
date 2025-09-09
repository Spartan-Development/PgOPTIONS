<%

admin_top

set form [ns_conn form]

set id [ns_set get $form view_id]

if {$id != "user_passwd"} {
    ns_puts "<CENTER><BR><BR><B>NSV ARRAY = $id</B></CENTER><BR><BR>"

    ns_puts "<TABLE BORDER=\"1\"><TR><TD><BR><B>ARRAY SUBSCRIPT<B><BR></TD>"
    ns_puts "<TD><BR><B>VALUE<B><BR></TD></TR>"

    set nsv_names [nsv_array names $id]
    set sorted [lsort $nsv_names]
    foreach arrayval $sorted {
	ns_puts "<TR><TD><B>$arrayval</B></TD><TD><B>[nsv_get $id $arrayval]</B></TD></TR>"
    }

    ns_puts "</TABLE>"
}

ns_puts "</BODY></HTML>"

%>
