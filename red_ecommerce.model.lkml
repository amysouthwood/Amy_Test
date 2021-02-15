connection: "thelook_events_redshift"

include: "*.view.lkml"         # include all views in this project
#include: "order_*.dashboard.lookml"  # include all dashboards in this project

# aggregate_awareness: yes




########### Access Grants ############
access_grant: marketing_specific {
  user_attribute: department
  allowed_values: ["marketing"]
}

access_grant: sales_specific {
  user_attribute: department
  allowed_values: ["sales"]
}


########### Datagroups ##############
datagroup: default {
  sql_trigger: select current_date ;;
  max_cache_age: "1 hour"
}

datagroup: default_2 {
  max_cache_age: "12 hours"
}

datagroup: user_facts_etl {
  sql_trigger: SELECT max(ID) FROM etl_jobs ;;
  max_cache_age: "24 hours"
}

datagroup: triggers_first {
  sql_trigger: select current_date ;;
}

# for testing purposes only
datagroup: triggers_after {
  sql_trigger: select max(trigger_at) from sandbox_scratch.smoke_signal where name = 'prod_signal' ;;
}

datagroup: triggers_after_tues_to_sunday {
  sql_trigger: Select CASE WHEN dayname(max(trigger_at)) = 'Monday' THEN  'Sunday'
                      WHEN dayname(max(trigger_at)) = 'Tuesday' THEN  'Tuesday'
                      WHEN dayname(max(trigger_at)) = 'Wednesday' THEN  'Wednesday'
                      WHEN dayname(max(trigger_at)) = 'Thursday' THEN  'Thursday'
                      WHEN dayname(max(trigger_at)) = 'Friday' THEN  'Friday'
                      WHEN dayname(max(trigger_at)) = 'Saturday' THEN  'Saturday'
                      WHEN dayname(max(trigger_at)) = 'Sunday' THEN  'Sunday'
                      END
               From sandbox_scratch.smoke_signal
               where name = 'prod_signal';;
}

datagroup: triggers_after_monday {
  sql_trigger: Select  week(max(trigger_at),1)
               From sandbox_scratch.smoke_signal
               where name = 'prod_signal';;
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

#  sql_always_where: ${order_created_date} >= '2017-01-01';;
#  sql_always_having: ${total_sale_price} > 100 ;;
explore: order_items {
  description: "Detailed order information"
  label: "Order Items"
  aggregate_table: rollup__order_created_date {
    query: {
      dimensions: [
        order_created_date]
      measures: [total_gross_revenue, total_sale_price]
      timezone: "America/Los_Angeles"
    }

    materialization: {
      datagroup_trigger: default
    }
  }

  aggregate_table: rollup__order_created_date__products_category {
    query: {
      dimensions: [order_created_date, products.category]
      measures: [total_gross_revenue, total_sale_price]
      timezone: "America/Los_Angeles"
    }

    materialization: {
      datagroup_trigger: default
    }
  }
  sql_always_having: {% if order_items.apply_having_filter._is_filtered %}
                        {% if order_items.apply_having_filter._parameter_value == "'yes'" %}
                          ${average_sale_price} > 0 OR ${total_gross_revenue} > 0
                        {% else %}
                          1=1
                        {% endif %}
                    {% else %}
                    1=1
                    {% endif %}
  ;;


#   access_filter: {
#     field: products.brand
#     user_attribute: brand
#   }
#   sql_always_where:
#       {% if order_items.returned_date._in_query or order_items.returned_year._in_query %}
#         ${returned_date} IS NOT NULL
#       {% elsif order_items.delivered_date._in_query or order_items.delivered_year._in_query %}
#         ${delivered_date} IS NOT NULL
#       {% else %}
#         1=1
#       {% endif %} ;;
  join: users {
#     required_access_grants: [marketing_specific]
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
  join: parameters {}

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



############# ACCESS GRANTS EXPLORES #############
explore: marketing_users {
  view_name: users
  required_access_grants: [marketing_specific]
  fields: [ALL_FIELDS*,-users.avg_spend_per_user
    ,-users.count_users_returned]
  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
}

explore: sales_users {
  view_name: users
  required_access_grants: [sales_specific]
  fields: [ALL_FIELDS*,-users.avg_spend_per_user
    ,-users.count_users_returned]
  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
}

##################
explore: agg_products_test {
  view_name: products
  join: agg_test {
    type: left_outer
    relationship: many_to_one
    sql_on: {% if agg_test.dimension_select._parameter_value == 'products.brand' %} ${products.brand} = ${agg_test.dimension}
            {% elsif agg_test.dimension_select._parameter_value == 'products.category' %} ${products.category} = ${agg_test.dimension}
            {% endif %}
     ;;

  }
}

########################
# example PoP with refinements

explore: period_over_period {
  view_name: order_items_simple
  join: dates {
    type: left_outer
    sql_on: ${order_items_simple.created_raw} = ${dates.date_raw} ;;
    relationship: many_to_one
  }
}
