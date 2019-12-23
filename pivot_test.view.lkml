view: pivot_test_1 {
  derived_table: {
    sql: SELECT *,
    case when category = 'Active' then 1
         when category = 'Tops & tees' then 2
         when category = 'Outerwear & Coats' then 3
         when category = 'Jumpsuits & Rompers' then 4
         else 5 end as
        cat_num_1,
        case when category = 'Active' then 5
         when category = 'Tops & tees' then 4
         when category = 'Outerwear & Coats' then 3
         when category = 'Jumpsuits & Rompers' then 2
         else 1 end as
        cat_num_2
FROM demo_db.products where brand = 'adidas' ;;
  }
}

view: pivot_test {
  derived_table: {
    sql: SELECT id,
          cat_num_1 as severity,
          count(brand) as value_1,
          null as value_2
      FROM ${pivot_test_1.SQL_TABLE_NAME}
      Group by 1,2

      UNION ALL

      SELECT id,
          cat_num_2 as severity,
          null as value_1,
          count(brand) as value_2
      FROM ${pivot_test_1.SQL_TABLE_NAME}
      Group by 1,2
       ;;
  }

  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: primary_key {
    type:  string
    sql: concat(${id}, '-',${value_1}, '-',${value_2}) ;;
    hidden: yes
  }

  dimension: severity {
    type: number
    sql: ${TABLE}.severity ;;
  }

  dimension: value_1 {
    type: number
    sql: ${TABLE}.value_1 ;;
  }

  measure: total_count_1 {
    type: sum
    sql: ${value_1} ;;
  }

  dimension: value_2 {
    type: number
    sql: ${TABLE}.value_2 ;;
  }

  measure: total_count_2 {
    type: sum
    sql: ${value_2} ;;
  }

}
