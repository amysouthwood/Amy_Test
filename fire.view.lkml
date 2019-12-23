view: fire {
  derived_table: {
    datagroup_trigger: triggers_first
    create_process: {
      sql_step: create table ${SQL_TABLE_NAME} as select 1 ;;
      sql_step: insert into sandbox_scratch.smoke_signal (name, trigger_at)
                      VALUES (
                        if dev -- 'dev_signal'
                        if prod -- 'prod_signal'
                      , current_timestamp
                       ) ;;
    }
  }

}

view: smoke_signal {
  sql_table_name: sandbox_scratch.smoke_signal ;;

  dimension: name {
    sql: ${TABLE}.name ;;
  }

  dimension: date {
    sql: ${TABLE}.trigger_at ;;
  }
}

# create table sandbox_scratch.smoke_signal (
#               name varchar(32),
#               trigger_at datetime
#               );
