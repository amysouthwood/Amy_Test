view: fire_2 {
  derived_table: {
    datagroup_trigger: triggers_first_2
    create_process: {
      sql_step: create table ${SQL_TABLE_NAME} as select 1 ;;
      sql_step: insert into sandbox_scratch.smoke_signal_2 (name)
                      VALUES (
                       -- if dev -- 'dev_signal'
                       -- if prod -- 'prod_signal'
                       ) ;;
    }
  }
}
#-- if prod — prod_signal

view: smoke_signal_2 {
  sql_table_name: sandbox_scratch.smoke_signal_2 ;;
  dimension: id {
    sql: ${TABLE}.id ;;
  }

  dimension: name {
    sql: ${TABLE}.name ;;
  }
}
