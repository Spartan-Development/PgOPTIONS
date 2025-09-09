<html>
<title>pgdiff Demo Type Explaination</title>
<body>

<h3>pgdiff Demo Type Explaination</h3>

<%

set_form_vars

if {$type == 1} {
    
    ns_puts "<B>Type I:</B><BR>This type of Demo takes a source and target db and creates the alter scripts for transforming between the two. You must choose a source and target db and they must not be the same. The options for the source and target db come from the nsd.tcl config file and you would add these to your own for working with pgdiff. After the alter scripts are created, you can preview and modify these scripts, save them to a file, and test them. The testing process is competed in two steps:
<UL><LI>Step 1
<UL><LI>Create a new database named <B>test</B>
<LI>Load the schema for the source DB into test
<LI>Show comparison of the db schemas for the source and test db
</UL>
<LI>Step 2
<UL><LI>Apply the Alter Scripts submitted for testing to the test db
<LI>Compare the target db schema to the altered test db
</UL>
</UL>"

} elseif {$type == 2} {

   ns_puts "<B>Type II:</B><BR>This type of Demo takes a source db selected from the options in the nsd.tcl config file, a target db schema that is pulled from a file, and a file in which to write the created alter scripts. After the alter scripts are created and saved in the file this type jumps directly to the testing result page. Like Type I and Type III the alter scripts after being created are applied against the test db.  The testing process is competed in two steps:
<UL><LI>Step 1
<UL><LI>Create a new database named <B>test</B>
<LI>Load the schema for the source DB and the target DB (from file)
<LI>Show comparison of the db schemas for the source and test db
</UL>
<LI>Step 2
<UL><LI>Apply the Alter Scripts submitted for testing to the test db
<LI>Compare the target db schema to the altered test db
</UL>
</UL>"
} elseif {$type == 3} {

   ns_puts "<B>Type III:</B><BR>This type of Demo allows you to test what alter scripts must be applied for various schema by allowing the user to input the source and target schemas in text boxes or pick from a few example tests. After the alter scripts are created, you can preview and modify these scripts, save them to a file, and test them. The testing process is competed in two steps:
<UL><LI>Step 1
<UL><LI>Create a new database named <B>test</B>
<LI>Load the schema for the source DB into test
<LI>Show comparison of the db schemas for the source and test db
</UL>
<LI>Step 2
<UL><LI>Apply the Alter Scripts submitted for testing to the test db
<LI>Compare the target db schema to the altered test db
</UL>
</UL>"
}

ns_puts "</body></html>"

%>

