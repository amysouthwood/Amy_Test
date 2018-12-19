

include: "*.view.lkml"                       # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard
include: "ex_base_model.model"

explore: order_items_general {
  extends: [order_items]
}

############# Users Extended #############
explore: users_no_email {
  extends: [users]
  fields: [ALL_FIELDS*
    ,-users.email]
}
