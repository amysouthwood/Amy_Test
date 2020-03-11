connection: "thelook_events_redshift"

include: "/customisation_example/*.view.lkml"                # include all views in the views/ folder in this project
include: "/customisation_example/customisation.dashboard.lookml"   # include a LookML dashboard
include: "/customisation_example/customisation_group_a.dashboard.lookml"   # include a LookML dashboard


# This is for Users 1,2,3

# Explores should be named the same to make lookml dashboard templating easier. Use the from clause to specify the view file source.
explore: orders {
  from: orders_group_a
# limits to set group of users/customers for whom the explore is relevant. This is optional as the access filter will apply the row level security.
  # sql_always_where: ${user_id} in (1,2,3) ;;
# applies row level security so that customers only see their data
  # access_filter: {
  #   field: user_id
  #   user_attribute: user_id
  #   }
}
