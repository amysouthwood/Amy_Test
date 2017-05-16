connection: "redlook"

include: "*.view.lkml"         # include all views in this project
include: "-redshift_*.dashboard.lookml"  # include all dashboards in this project

############# Order Items Explore #################
explore: order_items {
  description: "Detailed order information"
  label: "Order Items"
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

############# User Lifetime Order Data #################
explore: user_lifetime_order {
  description: "User Lifetime Order"
  view_name: order_items
  from: order_items
  join: users {
    type:  inner
    relationship:  many_to_one
    sql_on: ${order_items.user_id} =  ${users.id}  ;;
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
  fields: [-order_items.average_spend_per_user]
  conditionally_filter: {
    filters: {
      field: brand_comparison.category
      value: "Accessories"
    }
    unless: [brand_comparison.brand]
  }
  view_name: order_items
  from: order_items

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
