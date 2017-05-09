connection: "redlook"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

############# Order Items Explore #################
explore: order_items {
  description: "Detailed order information"
  label: "Order Items"
  join: orders{
    type:  inner
    relationship: many_to_one
    sql_on: ${order_items.order_id} = ${orders.id} ;;
  }
  join: users {
    type:  inner
    relationship:  many_to_one
    sql_on: ${orders.user_id} =  ${users.id}  ;;
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

  join: product_facts {
    type: inner
    relationship: one_to_one
    sql_on: ${products.id} = ${product_facts.product_id} ;;
  }

}

############# User Lifetime Order Data #################
explore: user_lifetime_order {
  description: "User Lifetime Order"
  view_name: order_items
  from: order_items
  join: orders{
    type:  inner
    relationship: many_to_one
    sql_on: ${order_items.order_id} = ${orders.id} ;;
  }
  join: users {
    type:  inner
    relationship:  many_to_one
    sql_on: ${orders.user_id} =  ${users.id}  ;;
  }

  join:  user_lifetime_data {
    type: inner
    relationship:  one_to_one
    sql_on: ${user_lifetime_data.id}=${users.id} ;;
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

############# Brand Comparison #################
explore: compare_brands {
  description: "Compare Brands"
  label: "Compare Brands"
  conditionally_filter: {
    filters: {
      field: brand_comparison.category
      value: "Accessories"
    }
    unless: [brand_comparison.brand]
  }
  view_name: order_items
  from: order_items
  join: orders{
    type:  inner
    relationship: many_to_one
    sql_on: ${order_items.order_id} = ${orders.id} ;;
  }

  join: inventory_items {
    type: inner
    relationship: many_to_one
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
  }

  join: brand_comparison {
    type:inner
    relationship: many_to_one
    sql_on: ${inventory_items.product_id} = ${brand_comparison.id} ;;
  }
}
