include: "order_items_simple.view.lkml"


view: +order_items_simple {

  measure: total_revenue {
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    filters: [status: "Complete",returned_date: "NULL"]
  }
}
