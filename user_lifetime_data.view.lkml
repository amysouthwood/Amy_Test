view: user_lifetime_data {
  #correct derived table
#   derived_table: {
#     sql: with agg as (select users.id as "user_id"
#       , count(distinct orders.id) as "order_count"
#       , sum(order_items.sale_price) as "total_revenue"
#       , min(orders.created_at) as "first_order"
#       , max(orders.created_at) as "last_order"
#       from users
#       inner join orders
#       on users.id = orders.user_id
#       inner join order_items
#       on orders.id = order_items.order_id
#       group by users.id)
#
#       Select * from agg
#       left join orders
#       on agg.user_id = orders.user_id
#       left join order_items
#       on orders.id  = order_items.order_id
#       left join inventory_items
#       on order_items.inventory_item_id = inventory_items.id
#       left join products
#       on inventory_items.product_id = products.id
#        ;;
#     sql_trigger_value: Select CURRENT_DATE ;;
#     sortkeys: ["user_id"]
#     distribution_style: all
#   }

  derived_table: {
    sql: (select users.id as "user_id"
      , users.created_at as "signup"
      , count(distinct orders.id) as "order_count"
      , sum(order_items.sale_price) as "total_revenue"
      , min(orders.created_at) as "first_order"
      , max(orders.created_at) as "last_order"
      from users
      inner join orders
      on users.id = orders.user_id
      inner join order_items
      on orders.id = order_items.order_id
      group by users.id, users.created_at)
       ;;
    sql_trigger_value: Select CURRENT_DATE ;;
    sortkeys: ["user_id"]
    distribution_style: all
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
