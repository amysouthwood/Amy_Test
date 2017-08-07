view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
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
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
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
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: order_count {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: user_count {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: total_sale_price {
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [detail*]
#     link: {
#       label: "db test"
#       url: "/dashboards/2?Category={{ products.category._value }}"
#     }
  }


  dimension: is_30_days_new {
    type: yesno
    sql: ${order_created_raw} >= {% date_start start_date_filter %} ;;
  }

filter: start_date_filter{
  type: date
}

  dimension: is_30_days {
    type: yesno
    sql: ${order_created_raw} > DATEADD(day,-29,{% date_start start_date_filter %}) ;;
  }

dimension: is_prev_30_days {
  type: yesno
  sql: ${order_created_raw} <= DATEADD(day,-29,{% date_start start_date_filter %})
      AND ${order_created_raw} > DATEADD(day,-59,{% date_start start_date_filter %})
  ;;
}


  measure: 30_day_total_sale_price {
    type: sum
    value_format_name: usd
    sql: ${sale_price};;
    filters: {
      field: is_30_days
      value: "yes"
    }
}

  measure: Prev_30_day_total_sale_price_start {
    type: sum
    value_format_name: usd
    sql: ${sale_price};;
    filters: {
      field: is_prev_30_days
      value: "yes"
    }
  }
  dimension: reporting_period {
    sql: CASE
        WHEN datediff(day,${order_created_raw},current_date) < 30
        THEN 'Last 30 days'

        WHEN datediff(day,${order_created_raw},current_date) >= 30
        and datediff(day,${order_created_raw},current_date) < 60
        THEN 'Previous Last 30 days'

      END
       ;;
  }


  measure: average_sale_price {
    type: average
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [detail*]
  }

  measure: total_gross_revenue {
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: returned_date
      value: "NULL"
    }
  }

  measure: average_spend_per_user {
    type: number
    value_format_name: usd
    sql: 1.0 * ${total_sale_price} / NULLIF(${users.count},0) ;;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name,
      total_sale_price

    ]
  }
}
