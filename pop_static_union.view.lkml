

view: pop_static_union {
  derived_table: {
    sql: select b.*, 'L60d' as base, 'cy' as period from demo_db.orders b where created_at >= DATE_ADD(current_date, INTERVAL -60 DAY)
      UNION ALL
      select c.*, 'L90d' as base, 'cy' as period from demo_db.orders c where created_at >= DATE_ADD(current_date, INTERVAL -90 DAY)
      UNION ALL
      select c.*, 'L120d' as base, 'cy' as period from demo_db.orders c where created_at >= DATE_ADD(current_date, INTERVAL -120 DAY)
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }



  measure: count_pending {
    type: count
    filters: {
      field: status
      value: "pending"
    }
  }

  measure: count_cancelled {
    type: count
    filters: {
      field: status
      value: "cancelled"
    }
  }

  measure: count_complete {
    type: count
    filters: {
      field: status
      value: "complete"
    }
  }

  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created_at {
    type: time
    sql: ${TABLE}.created_at ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: base {
    type: string
    sql: ${TABLE}.base ;;
    order_by_field: base_order
  }

  dimension: base_order {
    type: number
    hidden: yes
    sql: CASE WHEN ${base}='L60d' then 1
              WHEN ${base}='L90d' then 2
              WHEN ${base}='L120d' then 3
         END;;
  }

  dimension: period {
    type: string
    sql: ${TABLE}.period ;;
  }

  set: detail {
    fields: [
      id,
      created_at_time,
      user_id,
      status,
      base,
      period
    ]
  }
}
