view: parameters {

  parameter: start_date {
    type: unquoted
    allowed_value: {
      label: "created date"
      value: "order_items.created_at"
    }
  }

  parameter: end_date {
    type: unquoted
    allowed_value: {
      label: "returned date"
      value: "order_items.returned_at"
    }
  }

  dimension: is_30_days {
    type: yesno
    sql: datediff('day',{% parameter start_date %},{% parameter end_date %}) <=7 ;;
  }
}
