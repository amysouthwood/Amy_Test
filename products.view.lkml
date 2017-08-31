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
      label:  "{% if _user_attributes['secure_email'] == 'Yes' %} Google {% endif %}"
      url: "https://www.google.co.uk/#q={{ value }}"
    }

#     link: {
#       label: "website link"
#       url: "https://www.{{ brand_link._value }}.co.uk"
#     }

#     link: {
#       label: "Drilling tests"
#       url: "/dashboards/2?Brand={{ products.brand._value }}"  ## example syntax for dashboard
# #     url: "/dashboards/250?Brand={{ value }}" ## example syntax for dashboard
# #     url: "/looks/1207?f[products.brand]={{ value }}"  ## example syntax for look
# #     url: "/explore/Amy_test/user_lifetime_data?fields=user_lifetime_data.order_cnt,products.brand&f[user_lifetime_data.is_repeat_customer]=Yes&f[products.brand]={{ value }}"  ## example syntax for explore
#
#     }
# #    html: <a href="/looks/1207?&f[products.brand]={{ value }}">{{ value }}</a>  ;; ## example syntax for look
# #    html: <a href="/dashboards/250?Brand={{ value }}">{{ value }}</a> ;; ## example syntax for dashboard
# #    html: <a href="/explore/Amy_test/user_lifetime_data?fields=user_lifetime_data.order_cnt,products.brand&f[user_lifetime_data.is_repeat_customer]=Yes&f[products.brand]={{ value }}">{{ value }}</a> ;;  ## example syntax for explore

  }

  dimension: brand_link {
    type: string
    hidden: yes
    sql: replace(${brand},' ','') ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
    link: {
      label: "Dashboard drill"
      url: "/dashboards/2?Category={{ value | url_encode }}"
    }
    link: {
      label: "Look drill"
      url: "/looks/14?f[products.category]={{ value }}"
    }
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
    #hidden: yes
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

  measure: average_price {
    type: average
    sql: ${retail_price} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name, inventory_items.count]
  }

}
