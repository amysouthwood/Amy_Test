connection: "thelook_events_redshift"

include: "*.view.lkml"         # include all views in this project
#include: "order_*.dashboard.lookml"  # include all dashboards in this project


########### Datagroups ##############
datagroup: default {
  max_cache_age: "1 hour"
}

datagroup: default_2 {
  max_cache_age: "12 hours"
}

datagroup: user_facts_etl {
  sql_trigger: SELECT max(ID) FROM etl_jobs ;;
  max_cache_age: "24 hours"
}

## model level caching ##
 persist_with: default

# if the brand_select filter only field is in the query then apply filter to the product_category based on the value of the brand_select
# otheriwse do not filter
explore: products {
  sql_always_where:
    1=1 {% if products.brand_select._is_filtered %}
  and ${products.category} in (select ${products.category} from ${products.SQL_TABLE_NAME} as products where {% condition products.brand_select %} ${products.brand} {% endcondition %})
  {%endif%}
  ;;

  }

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
  persist_with: default_2
#   persist_for: "6 hours"  #### still valid but old way
  description: "User Lifetime Order"
#   access_filter: {
#     field: products.brand
#     user_attribute: "brand"
#   }
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
 # sql_always_where: ${inventory_items.product_name} = {% parameter brand_comparison.brand_select %} ;;
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
