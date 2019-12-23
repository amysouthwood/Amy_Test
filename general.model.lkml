

include: "*.view.lkml"         # include all views in this project
#include: "order_*.dashboard.lookml" # include all dashboards in this project
include: "base.model"

explore: products {}

explore: order_items_general {
  extends: [order_items_base]
  group_label: "RED ECOMMERCE GENERAL"
}

############# Users Extended #############
explore: users_no_email {
  extends: [users]
  fields: [ALL_FIELDS*
    ,-users.avg_spend_per_user
    ,-users.count_users_returned
    ,-users.email]
  group_label: "RED ECOMMERCE GENERAL"
}
