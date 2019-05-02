view: amy {
  derived_table: {
    sql: (SELECT 'a' AS payment, 'b' AS market, 'c' AS payment_type_mapped) UNION ALL
      (SELECT 'd' AS payment, 'e' AS market, 'f' AS payment_type_mapped) UNION ALL
      (SELECT 'g' AS payment, 'h' AS market, 'i' AS payment_type_mapped)
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: payment {
    type: string
    sql: ${TABLE}.payment ;;
  }

  dimension: market {
    type: string
    sql: ${TABLE}.market ;;
  }

  dimension: payment_type_mapped {
    type: string
    sql: ${TABLE}.payment_type_mapped ;;
  }

  set: detail {
    fields: [payment, market, payment_type_mapped]
  }
}
