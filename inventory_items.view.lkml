view: inventory_items {
  sql_table_name: public.inventory_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: cost {
    hidden: yes
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension_group: created {
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

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension_group: sold {
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
    sql: ${TABLE}.sold_at ;;
  }


  measure: count {
    type: count
    drill_fields: [id, products.item_name, products.id, order_items.count]
  }

  measure: total_cost {
    type: sum
    sql:  ${cost} ;;
  }

  measure: avg_cost {
    type: average
    sql: ${cost} ;;
  }

  measure: total_gross_margin {
    type:  sum
    sql: ${order_items.sale_price} - ${cost} ;;
    drill_fields: [products.category, products.brand, total_gross_margin]
  }

  measure: avg_gross_margin {
    type:  average
    sql: ${order_items.sale_price} - ${cost} ;;
  }

  measure: gross_margin_perc {
    type:  number
    sql: ${total_gross_margin}/NULLIF(${order_items.total_gross_revenue},0) ;;
    value_format: "0.0%;-0.0%"
  }
}
