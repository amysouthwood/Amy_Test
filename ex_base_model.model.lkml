connection: "thelook"

include: "order_items.view.lkml"                       # include all views in this project
include: "inventory_items.view.lkml"                       # include all views in this project
include: "orders.view.lkml"                       # include all views in this project
include: "products.view.lkml"                       # include all views in this project
include: "users.view.lkml"                       # include all views in this project

# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

############## ACCESS GRANTS ############

access_grant: marketing_specific {
  user_attribute: department
  allowed_values: ["marketing"]
}

access_grant: sales_specific {
  user_attribute: department
  allowed_values: ["sales"]
}

############# EXPLORES #################
explore: order_items {
  from: order_items #required parameter to be able to extend
  view_name: order_items #required parameter to be able to extend
  extension: required
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

explore: users {
  from: users #required parameter to be able to extend
  view_name: users #required parameter to be able to extend
  extension: required
}
