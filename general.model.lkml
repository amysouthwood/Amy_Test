connection: "redlook"

include: "*.view.lkml"         # include all views in this project
include: "order_*.dashboard.lookml" # include all dashboards in this project
include: "base.model"

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }

explore: order_items_general {
  extends: [order_items_base]
}

############# Users Extended #############
explore: users_no_email {
  extends: [users]
  fields: [ALL_FIELDS*
    ,-users.avg_spend_per_user
    ,-users.count_users_returned
    ,-users.email]
}
