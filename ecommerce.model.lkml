connection: "thelook"

# include all the views
include: "*.view"

# include all the dashboards
#include: "*.dashboard"

datagroup: triggers_first {
  sql_trigger: select hour(current_timestamp) ;;
}

datagroup: triggers_after {
  sql_trigger: select max(id) from sandbox_scratch.smoke_signal where name = 'prod_signal' ;;
}

explore: smoke_signal {}



explore: order_items {
  description: "my order items info"
  from: order_items #required parameter to be able to extend
  view_name: order_items #required parameter to be able to extend
  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}


#extended explore example
explore: extend_order_items {
  extends: [order_items]
  join: users {
    type:  inner
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: one_to_one
  }
}


explore: products {
  conditionally_filter: {
    filters: {
      field: products.category
      value: "Accessories"
    }
    unless: [products.brand]
  }
}


explore: user_data {
  join: users {
    type: left_outer
    sql_on: ${user_data.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: users {
#   always_filter: {
#     filters: {
#       field: created_date
#       value: "30 days ago"
#
#     }
#   }
}
