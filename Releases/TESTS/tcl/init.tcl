
proc initialize { } {

    nsv_set . pg_bin_path "/usr/local/pgsql/bin/"

    nsv_set . pg_dump_path "/usr/local/pgsql/bin/pg_dump"
    nsv_set . psql_path "/usr/local/pgsql/bin/psql"
    nsv_set . source_schema_path "/tmp/pgdiff_schema"
    nsv_set . test_schema_path "/tmp/pgdiff_test_schema"
    nsv_set . test_script_path "/tmp/alter_test_script"

    nsv_set . pg_version "7.2"

    nsv_set . pgdiff_file ""
    nsv_set . rename_cols 1

    # The security flag if for running on publically accessible machines
    # Prevents modifying scripts and text input schemas

    nsv_set . security 1

    # We initialize cache tables so exists

    nsv_set db_source 0 0
    nsv_set db_target 0 0
    nsv_set db_test 0 0

    set source ""
    set target ""

    foreach section [ns_configsections] {
	set name [ns_set name $section]
	if {[regexp {ns/db/pool/(.*)} $name match poolname]} {
	    if {$poolname != "test" && $poolname != "pgdiff_1" && $poolname != "pgdiff_2"} {
		append source "<INPUT TYPE=\"radio\" name=\"source\" value=\"$poolname\">$poolname<BR CLEAR=\"ALL\">"
		append target "<INPUT TYPE=\"radio\" name=\"target\" value=\"$poolname\">$poolname<BR CLEAR=\"ALL\">"
	    }
	}
    }


    nsv_set . db_test "test"
    nsv_set . attributes [list tables index seq function constraint other]

    nsv_set . index_hash 0

    nsv_set . online 1
    nsv_set . type2_in_filename "/tmp/all.sql"

    nsv_set . demo 0
    nsv_set . demo_ip 0
    nsv_set . demo_mode 1
    nsv_set . demo_session_id 0

    nsv_set test_source_schema 0 ""
    nsv_set test_target_schema 0 ""

    nsv_set test_source_schema 1 "

create sequence category_id_sequence;

create table categories (
	category_id	integer not null primary key,
	category_title	varchar(50) not null,
	category_description    varchar(4000),
	-- e.g., for a travel site, 'country', or 'activity' 
	-- could also be 'language'
	category_type	varchar(50),
	-- language probably would weight higher than activity 
	profiling_weight	float4 default 1 check(profiling_weight >= 0),
	enabled_p	char(1) default 't' check(enabled_p in ('t','f')),
	mailing_list_info	varchar(4000)
);

create table category_hierarchy (
   parent_category_id     integer references categories,
   child_category_id      integer references categories,
   unique (parent_category_id, child_category_id)
);
"
    nsv_set test_target_schema 1 "

create sequence user_id_sequence;


create table users (
	user_id			integer not null primary key,
	first_name		varchar(100) not null,
	last_name		varchar(100) null,
	email			varchar(100) not null unique
      
);

create index users_by_email on users (email);
"

    nsv_set test_source_schema 2 "
create table users (
	user_id			integer not null primary key,
	first_name		varchar(100) not null,
	last_name		varchar(100) null,
	email			varchar(100) not null unique
      
);
"
    nsv_set test_target_schema 2 "
create table users (
	user_id			integer not null primary key,
	first_name		varchar(100) not null,
	last_name		varchar(100) null
   
);
"

     nsv_set test_source_schema 3 "
create table users (
	user_id			integer,
	first_name		varchar(100) not null,
	last_name		varchar(100) null,
	email			varchar(100) not null unique
      
);
"
    nsv_set test_target_schema 3 "
create table users (
	user_id			integer not null primary key,
	first_name		varchar(100) not null,
	last_name		varchar(100) null,
	email			varchar(100) not null unique
);
"
   
     nsv_set test_source_schema 4 "
create table users (
	user_id			integer not null primary key,
	first_name		varchar(100) not null,
	last_name		varchar(100) null,
	email			varchar(100) not null unique
      
);
"
    nsv_set test_target_schema 4 "
create table users (
	user_id			integer not null primary key,
	first_name		varchar(100) not null,
	last_name		varchar(100) not null,
	email			varchar(100) not null unique
);
    
"

     nsv_set test_source_schema 5 "
create table users (
	user_id			integer not null primary key,
	first_name		varchar(100) not null,
	last_name		varchar(100) null,
	email			varchar(100) not null unique
      
);
"
    nsv_set test_target_schema 5 "
create table users (
	user_id			integer not null primary key,
	first_name		varchar(100) not null,
	user_email		varchar(100) not null unique
);
    
"

     nsv_set test_source_schema 6 "
create table users (
	user_id			integer not null primary key,
	first_name		varchar(100) not null,
	last_name		varchar(100) null,
	email			varchar(100) not null unique
      
);
"
    nsv_set test_target_schema 6 "
create table users (
	user_id			integer not null primary key,
	first_name		varchar(100) not null,
	last_name		text,
	email			varchar(100) not null unique
      
);
"

    nsv_set . db_source_widget $source
    nsv_set . db_target_widget $target

}


initialize


if {[nsv_get . demo_mode]} {

    ns_schedule_proc -thread 60 check_demo_timeout

    proc logout_demo_user { } {
	
	set temp(0) ""
	nsv_set . demo 0
	nsv_set . demo_ip 0
	nsv_array reset log_data [array get temp]
	ns_logroll [ns_info log] 2
    }

    proc check_demo_timeout { } {

	set login_time [nsv_get . demo]
	if {$login_time != 0 && [expr [ns_time] - $login_time] > 600} {
	    logout_demo_user
	}
    }

    proc login_demo_user { } {
	
	set peer_ip [ns_conn peeraddr]	
	nsv_set . demo [ns_time]
	nsv_set . demo_ip $peer_ip
	nsv_set . log_id 0
	nsv_incr . demo_session_id
	nsv_set log_data 0 [list "" "Start of Demo"]
    }

    proc check_demo_user { } {
	
	set peer_ip [ns_conn peeraddr]	
	set demo_ip [nsv_get . demo_ip] 
	if {$demo_ip != $peer_ip} {
	    ns_returnredirect "index.adp"
	}
    }
    
}