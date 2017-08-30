connection: "redlook"

include: "*.view.lkml"         # include all views in this project
include: "order_*.dashboard.lookml"  # include all dashboards in this project


############# Order Items Explore #################
explore: order_items_base {
  from: order_items #required parameter to be able to extend
  view_name: order_items #required parameter to be able to extend
 extension: required
#  sql_always_where: ${order_created_date} >= '2017-01-01';;
#  sql_always_having: ${total_sale_price} > 100 ;;
description: "Detailed order information"

join: users {
  type:  inner
  relationship:  many_to_one
  sql_on: ${order_items.user_id} =  ${users.id}  ;;
}

join: inventory_items {
  type: inner
  relationship: many_to_one
  sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
}

join: products {
  type:inner
  relationship: many_to_one
  sql_on: ${inventory_items.product_id} = ${products.id} ;;
}
}

explore: users {
  from: users #required parameter to be able to extend
  view_name: users #required parameter to be able to extend
  extension: required
}
