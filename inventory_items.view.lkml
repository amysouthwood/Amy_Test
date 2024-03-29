view: inventory_items {
  sql_table_name: public.inventory_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: cost {
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
      year,
      month_name
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: product_brand {
    type: string
    sql: ${TABLE}.product_brand ;;
  }

  dimension: product_category {
    type: string
    sql: ${TABLE}.product_category ;;
  }

  dimension: product_department {
    type: string
    sql: ${TABLE}.product_department ;;
  }

  dimension: product_distribution_center_id {
    type: number
    sql: ${TABLE}.product_distribution_center_id ;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_retail_price {
    type: number
    sql: ${TABLE}.product_retail_price ;;
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}.product_sku ;;
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
    value_format_name: usd
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

  set: excluded_list {
    fields: [id, users.id]
  }
}
