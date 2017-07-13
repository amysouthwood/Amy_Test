view: user_lifetime_data {

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
#     datagroup_trigger: user_facts_etl
#     sql_trigger_value: Select CURRENT_DATE ;; ### still valid but old way
#     sortkeys: ["user_id"]
#     distribution_style: all
  }



  measure: count {
    hidden:  yes
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: gender {
    hidden: yes
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: age {
    hidden: yes
    type: string
    sql: ${TABLE}.age ;;
  }


  dimension_group: signup {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      quarter,
      year,
      day_of_week_index
    ]
    sql: ${TABLE}.signup ;;
  }

  dimension: order_count {
    hidden: yes
    type: number
    sql: ${TABLE}.order_count ;;
  }


  measure: order_cnt {
    type: sum
    sql: ${order_count} ;;
  }

  measure: week_order_cnt {
    type: sum
    sql: ${order_count} ;;
    filters: {
      field: signup_day_of_week_index
      value: "<=4"
    }
  }

  dimension: order_count_tier {
    type: tier
    tiers: [1,2,5,9]
    style: integer
    sql: ${order_count} ;;
  }

#   measure: order_count_tier_measure {
#     type: number
#     sql: CASE WHEN ${order_cnt} < 10 then 0
#         When ${order_cnt} < 100 then 1
#         When ${order_cnt} < 500 then 2
#         else 3
#         end;;
#   }



  dimension: weekday_tier {
    type: tier
    tiers: [4]
    style: integer
    sql: ${signup_day_of_week_index} ;;
  }

  measure: avg_order_count {
    type: average
    sql: ${order_count} ;;
  }

  dimension: total_revenue {
    hidden: yes
    type: number
    sql: ${TABLE}.total_revenue ;;
  }

  dimension: total_revenue_first_purchase {
    type: number
    sql: Case when {order_user_sequence.is_first_purchase} then ${total_revenue} end ;;
  }

  measure: total_rev {
    type: sum
    sql: ${total_revenue} ;;
  }

  dimension: total_revenue_tier {
    description: "Revenue seperated into tiers "
    type: tier
    tiers: [5,20,50,100,500,1000]
    style: relational
    sql: ${total_revenue} ;;
  }

  measure: avg_revenue {
    type: average
    sql:  ${total_revenue} ;;
  }

  dimension_group: first_order {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.first_order ;;
  }


  dimension_group: last_order {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_order ;;
  }

  dimension: days_since_last_purchase {
    #hidden: yes
    type: number
    sql: DATEDIFF(day,${last_order_date},CURRENT_DATE) ;;
  }


  dimension:  is_active {
    type: yesno
    sql: ${days_since_last_purchase} < 90;;
  }

  measure: avg_days_since_last_purchase {
    type: average
    sql: ${days_since_last_purchase} ;;
  }

  dimension: is_repeat_customer {
    type: yesno
    sql: ${order_count} >1 ;;
  }

  ### Cohort Analysis dimensions ###
  dimension: days_since_signup {
    type: number
    sql: DATEDIFF(day,${signup_date},CURRENT_DATE) ;;
  }

  dimension: months_since_signup {
    type: number
    sql: DATEDIFF(month,${signup_date},CURRENT_DATE) ;;
  }

  measure: average_days_since_signup {
    type: average
    sql: ${days_since_signup} ;;
  }

  measure: average_months_since_signup {
    type: average
    sql: ${months_since_signup} ;;
  }

  set: detail {
    fields: [
      id,
      order_count,
      total_revenue,
      first_order_time,
      last_order_time,
      days_since_last_purchase
    ]
  }
}
