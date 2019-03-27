

include: "order_items.view.lkml"                       # include all views in this project
include: "inventory_items.view.lkml"                       # include all views in this project
include: "orders.view.lkml"                       # include all views in this project
include: "products.view.lkml"                       # include all views in this project
include: "users.view.lkml"                       # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard
include: "ex_base_model.model"

############## ACCESS GRANTS ############

access_grant: marketing_specific {
  user_attribute: department
  allowed_values: ["marketing"]
}

access_grant: sales_specific {
  user_attribute: department
  allowed_values: ["sales"]
}

############ EXPLORES ###########

explore: order_items_general {
  extends: [order_items]
  group_label: "ECOMMERCE GENERAL"
}


explore: users_no_email {
  extends: [users]
  fields: [ALL_FIELDS*
    ,-users.email]
  group_label: "ECOMMERCE GENERAL"
}
