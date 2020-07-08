view: order_items_simple {
  sql_table_name: public.order_items ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    hidden: yes
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
    hidden: yes
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
    hidden: yes
    type: number
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    hidden: yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    hidden: yes
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

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
    hidden: yes
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
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  measure: count_order_items {
    type: count
    drill_fields: [id]
  }

  measure: order_count {
    description: "distinct count of orders"
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: user_count {
    description: "distinct count of users"
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: total_sale_price {
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
  }

# Filtered PoP measures

  measure: current_period_sales {
    view_label: "_POP"
    type: sum
    value_format_name: usd
    sql: ${sale_price};;
    filters: {
      field: dates.period_filtered_measures
      value: "this"
    }
  }

  measure: previous_period_sales {
    view_label: "_POP"
    type: sum
    value_format_name: usd
    sql: ${sale_price};;
    filters: {
      field: dates.period_filtered_measures
      value: "last"
    }
  }

  measure: sales_pop_change {
    view_label: "_POP"
    label: "Total sales period-over-period % change"
    type: number
    sql: (1.0 * ${current_period_sales} / NULLIF(${previous_period_sales} ,0)) - 1 ;;
    value_format_name: percent_2
  }

}
