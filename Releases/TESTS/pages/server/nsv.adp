<%

admin_top

ns_puts "<CENTER><BR><BR><B>NSV VARIABLES</B></CENTER><BR><BR><TABLE BORDER=\"1\"><TR>"


ns_puts "<TD><B>NSV VARIABLE ARRAY ID</B></TD>"
ns_puts "<TD><B>ARRAY SIZE</B></TD><TD><B>BREAKDOWN OF ARRAY</B></TD>"


set names [nsv_names]
foreach varname [lsort $names] {
	

  

	set size [nsv_array size $varname]
	ns_puts "<TR><TD><B>$varname</B></TD><TD><B>$size</B></TD><TD><A HREF=\"admin_view_nsv.adp?view_id=$varname\">VIEW SET BREAKDOWN</A></TD></TR>"
   
}

ns_puts "</TABLE></BODY></HTML>"

%>
