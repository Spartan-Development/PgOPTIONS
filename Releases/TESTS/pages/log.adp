<html>
<title>pgdiff Log</title>
<body>

<%

ns_puts "<TABLE WIDTH='100%'><TR><TD><B><A HREF='log.adp'>Server Log</A></B></TD><TD><A HREF=main.adp>Alter Scripts Page</A></TD><TD ALIGN='RIGHT'> <A HREF='log.adp?aolserver=1'>View AOLserver Raw Log File</A></TD></TR></TABLE><BR><BR>"

set_form_vars

if {![info exists aolserver]} {

    if {[info exists log_id]} {
	set log_item [nsv_get log_data $log_id]
	ns_puts "<B>Log Item for Session:<HR>[lindex $log_item 0]</B><BR><PRE>[lindex $log_item 2]</PRE>"
    } else {
	ns_puts "<B>Log Items for Session:</B>"
	for {set i 1} {$i <= [nsv_get . log_id]} {incr i} {
	    set log_item [nsv_get log_data $i]
	    ns_puts "<HR><A HREF='log.adp?log_id=$i'>[lindex $log_item 0]</A><BR>"
	    if {[lindex $log_item 1] == ""} {
		ns_puts "No Errors Reported"
	    } else {
		ns_puts "<PRE>[lindex $log_item 1]</PRE>"
	    }
	}
    }
    ns_puts "<BR><BR>
<B>Note</B><BR>
<p>Not all errors that show up in log may be a problem. For instance, sometimes you may drop a temp table that does not currently exist. Or you may drop an index on a column that may not exist because the corresponding table was dropped as well. The Error Log should be examined along with the resulting schemas but errors often are not a real concern. 
<p>
</body></html>"
    ns_adp_return
}

if [regexp {STDOUT} [ns_info log]] {
    ns_puts "<b>Log is on stdout and cannot be viewed from here.</b>"
    ns_puts "</body></html>"
    ns_return
}
%>

<%
if { [set logsize [ns_queryget logsize]] == "" } {
    set logsize 50000
}
%>

Last <%=$logsize%> bytes of server log <%=[ns_info log]%>.

<PRE>
<%
if [catch {
    ## Server log can be very small so make sure requested size won't kill us.
    set filesize [file size [ns_info log]]
    set fd [open [ns_info log]]
    if { $filesize > $logsize } {
	seek $fd -$logsize end
    } else {
	seek $fd 0 start
    }
    ns_puts [read $fd]
} errMsg] {
    ns_log error "[ns_conn url]: error accessing log: \"$errMsg\""
    ns_puts "Unable to access server.log: error \"$errMsg\""
}
close $fd
%>
</PRE>
<BR><BR>
<B>Note</B><BR>
<p>Not all errors that show up in log may be a problem. For instance, sometimes you may drop a temp table that does not currently exist. Or you may drop an index on a column that may not exist because the corresponding table was dropped as well. The Error Log should be examined along with the resulting schemas but errors often are not a real concern. 
<p>

</body>
</html>

