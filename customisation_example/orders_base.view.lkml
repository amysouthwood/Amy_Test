# This view contains all the fiels that are the same/exist between customers.
# Fields that are exactly the same between customers will be left as is
# Fields that exist between customers but definition are changed will be modified in the extended views

view: orders_base {
  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: order_created {
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
    sql: ${TABLE}.created_at ;;
  }


  dimension_group: delivered {
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
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    hidden: yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
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
    sql: ${TABLE}.returned_at ;;
  }

  dimension: is_returned {
    type: yesno
    sql: ${returned_date} is not NULL ;;
  }

  dimension: sale_price {
    type: number
    hidden: yes
    sql: ${TABLE}.sale_price ;;
  }


  dimension_group: shipped {
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
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
  }

  measure: order_count {
    description: "distinct count of orders"
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
  }

}
