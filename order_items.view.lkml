view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    hidden: yes
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

  dimension: sale_price {
    hidden:  yes
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  measure: count {
    type: count
    drill_fields: [id, inventory_items.id, orders.id]
  }

  measure: total_sale_price{
    type:  sum
    sql:  ${sale_price} ;;
  }

  measure: cumulative_total_sale_price {
    type:  running_total
    sql: ${total_sale_price} ;;
  }

  measure:  avg_sale_price {
    type: average
    sql:  ${sale_price} ;;
  }


  measure: total_gross_revenue {
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: returned_date
      value: "NULL"
    }
  }

  dimension: is_returned {
    type: yesno
    sql: ${returned_date} is not NULL ;;
  }

  measure: count_returned {
    type:  count
    filters: {
      field: returned_date
      value: "-NULL"
    }
  }

#  measure: item_return_rate {
#    type: number
#    sql: 100*(${count_returned}/NULLIF(${count},0)) ;;
#    value_format: "0.000;0.000"
#  }
}
