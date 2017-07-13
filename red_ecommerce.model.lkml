connection: "redlook"

include: "*.view.lkml"         # include all views in this project
include: "order_*.dashboard.lookml"  # include all dashboards in this project


########### Datagroups ##############
datagroup: default {
  max_cache_age: "1 hour"
}

datagroup: user_facts_etl {
  sql_trigger: SELECT max(ID) FROM etl_jobs ;;
}

datagroup: user_facts_1 {
  sql_trigger: SELECT max(user_id) FROM ${user_facts_pdt_1.SQL_TABLE_NAME} ;;
}

datagroup: user_facts_2 {
  sql_trigger: SELECT max(user_id) FROM ${user_facts_pdt_2.SQL_TABLE_NAME} ;;
}

## model level caching ##
persist_with: default

############# Order Items Explore #################
explore: order_items {
#  sql_always_where: ${order_created_date} >= '2017-01-01';;
#  sql_always_having: ${total_sale_price} > 100 ;;
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

#   always_filter: {
#     filters: {
#       field: products.category
#       value: "Accessories"
#     }
#   }
#   conditionally_filter: {
#     filters: {
#       field: products.category
#       value: "Accessories"
#     }
#     unless: [products.brand]
#   }

}

############# User Lifetime Order Data #################
explore: user_lifetime_order {
#  persist_with: user_facts_2
#   persist_for: "6 hours"  #### still valid but old way
  description: "User Lifetime Order"
  access_filter: {
    field: products.brand
    user_attribute: "brand"
  }
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

  join: order_user_sequence {
    type: inner
    relationship: one_to_one
    sql_on: ${order_user_sequence.user_id}= ${user_lifetime_data.id} ;;
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
  fields: [ALL_FIELDS*,-order_items.average_spend_per_user]
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



############## AB Testing ########################
explore: ab_testing {
  fields: [ALL_FIELDS*
          ,-users.avg_spend_per_user
          ,-users.count_users_returned]
  join: users {
    type: inner
    sql_on: ${ab_testing.id} = ${users.id} ;;
    relationship: one_to_one
  }
}


############## Parsing Strings ##################
explore: products_string {
  from: products
  view_name: products
  join: word {
    type: cross
    relationship: one_to_many
    sql_where: ${word.name} <> '';;
  }
  join: word2 {
    from: word
    type: cross
    relationship: one_to_many
    sql_where: ${word2.name} <> '' AND ${word.name} <> ${word2.name} ;;
  }
}

explore: users {
  from: users #required parameter to be able to extend
  view_name: users #required parameter to be able to extend
  extension: required
}
