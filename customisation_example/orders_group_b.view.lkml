include: "/customisation_example/orders_base.view.lkml"

view: orders_group_b {
  extends: [orders_base]

# This measure is specific to group a and do not exist in the base view
  measure: user_count {
    description: "distinct count of users"
    type: count_distinct
    sql: ${user_id} ;;
  }

# This is a measure that exists in the base view but we are applying group b specific formatting
  measure: total_sale_price {
    value_format_name: gbp
  }
}
