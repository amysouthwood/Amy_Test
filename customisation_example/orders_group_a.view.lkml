include: "/customisation_example/orders_base.view.lkml"

view: orders_group_a {
  extends: [orders_base]

# These measures are specific to group a and do not exist in the base view
  measure: total_gross_revenue {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: eur
    filters: {
      field: returned_date
      value: "NULL"
    }
  }

  measure: average_sale_price {
    type: average
    value_format_name: eur
    sql: ${sale_price} ;;
  }

# This is a measure that exists in the base view but we are applying group a specific formatting
  measure: total_sale_price {
    value_format_name: eur
  }

}
