connection: "redlook"

include: "users.view.lkml"         # include all views in this project
include: "order_*.dashboard.lookml"  # include all dashboards in this project
include: "red_ecommerce.model"

############# Users Extended #############
explore: users_no_email {
  extends: [users]
  fields: [ALL_FIELDS*
    ,-users.avg_spend_per_user
    ,-users.count_users_returned
    ,-users.email]
}
