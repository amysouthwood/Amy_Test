connection: "thelook"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project
include: "ecommerce.model"

explore: extend_order_items_2 {
  extends: [order_items]
  }
