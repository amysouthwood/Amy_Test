view: ndt_daily_agg {
  derived_table: {
    persist_for: "12 hours"
    explore_source: order_items {
      timezone: "America/Los_Angeles"
      column: order_created_date {}
      column: total_sale_price {}
      column: order_count {}
      column: total_gross_revenue {}
    }
  }
  dimension: order_created_date {
    type: date
  }
  dimension: total_sale_price {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: order_count {
    description: "distinct count of orders"
    type: number
  }
  dimension: total_gross_revenue {
    value_format: "$#,##0.00"
    type: number
  }
}
