connection: "thelook"

# include all the views
include: "*.view"

# include all the dashboards
#include: "*.dashboard"

############## DATAGROUPS ################
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

############## ACCESS GRANTS ############

access_grant: marketing_specific {
  user_attribute: department
  allowed_values: ["marketing"]
}

access_grant: sales_specific {
  user_attribute: department
  allowed_values: ["sales"]
}

############# EXPLORES ##################

explore: smoke_signal {
  hidden: yes
}

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
    required_access_grants: [marketing_specific]
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: products {
  view_name: products
  from: products
  join: pivot_test {
    type: inner
    sql_on: ${products.id} = ${pivot_test.id} ;;
    relationship: one_to_many
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

# explore: events {}


################ EXTENDED EXPLORES ################
explore: extend_products {
  extends: [products]
  conditionally_filter: {
    filters: {
      field: products.category
      value: "Accessories"
    }
    unless: [products.brand]
  }
}

############# ACCESS GRANTS EXPLORES #############
explore: marketing_users {
  view_name: users
   required_access_grants: [marketing_specific]
}

explore: sales_users {
  view_name: users
  required_access_grants: [sales_specific]
}
