view: products {
  sql_table_name: public.products ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: cost {
    type: number
    value_format_name: usd
    sql: ${TABLE}.cost ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
    drill_fields: [category, name]
    link: {
      label: "Google link"
      url: "https://www.google.co.uk/#q={{ order_items.user_id._value }}"
    }
    link: {
      label: "website link"
      url: "https://www.{{ brand_link._value }}.co.uk"
    }
    link: {
      label: "Drilling tests"
      url: "https://sandbox.dev.looker.com/dashboards/269?Brand={{ products.brand._value }}" #working for dashboard
#      url: "https://sandbox.dev.looker.com/dashboards/269?Brand={{ value }}" #working for dashboard
#       url: "/looks/1207?f[products.brand]={{ value }}"  #working for look
#      url: "/explore/Amy_test/user_lifetime_data?fields=user_lifetime_data.order_cnt,products.brand&f[user_lifetime_data.is_repeat_customer]=Yes&f[products.brand]={{ value }}"  #working for explore

    }
#     html: <a href="/looks/1207?&f[products.brand]={{ value }}">{{ value }}</a>  ;; # working for look
#    html: <a href="/dashboards/250?Brand={{ value }}">{{ value }}</a> ;; #working for dashboard
#    html: <a href="/explore/Amy_test/user_lifetime_data?fields=user_lifetime_data.order_cnt,products.brand&f[user_lifetime_data.is_repeat_customer]=Yes&f[products.brand]={{ value }}">{{ value }}</a> ;;  #working for explore


  }

  dimension: brand_link {
    type: string
    hidden: yes
    sql: replace(${brand},' ','') ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension:  name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: retail_price {
    hidden: yes
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: distribution_center_id {
    type: string
    sql: ${TABLE}.distribution_center_id ;;
    hidden: yes
  }

  measure: count {
    type: count
    drill_fields: [id, name, inventory_items.count]
  }

}
