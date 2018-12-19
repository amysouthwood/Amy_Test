view: test_derived {
  derived_table: {
    sql: (select order_items.user_id as "user_id"
        , users.gender as "gender"
        , users.created_at as "signup"
        , users.age as "age"
        , COUNT(DISTINCT order_items.order_id) as order_count
        , SUM(order_items.sale_price) AS total_revenue
        , MIN(NULLIF(order_items.created_at,0)) as first_order
        , MAX(NULLIF(order_items.created_at,0)) as last_order
        , COUNT(DISTINCT DATE_TRUNC('month', NULLIF(order_items.created_at,0))) as number_of_distinct_months_with_orders
      FROM order_items
      inner join users
      on users.id = order_items.user_id
      group by order_items.user_id, users.gender, users.age, users.created_at)
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension_group: signup {
    type: time
    sql: ${TABLE}.signup ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: order_count {
    type: number
    sql: ${TABLE}.order_count ;;
  }

  dimension: total_revenue {
    type: number
    sql: ${TABLE}.total_revenue ;;
  }

  dimension_group: first_order {
    type: time
    sql: ${TABLE}.first_order ;;
  }

  dimension_group: last_order {
    type: time
    sql: ${TABLE}.last_order ;;
  }

  dimension: number_of_distinct_months_with_orders {
    type: number
    sql: ${TABLE}.number_of_distinct_months_with_orders ;;
  }

  set: detail {
    fields: [
      user_id,
      gender,
      signup_time,
      age,
      order_count,
      total_revenue,
      first_order_time,
      last_order_time,
      number_of_distinct_months_with_orders
    ]
  }
}
