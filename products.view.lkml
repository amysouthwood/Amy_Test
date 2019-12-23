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

# documentation:
  # _filters and custom drill:https://help.looker.com/hc/en-us/articles/360001288228-Custom-Drilling-Using-HTML-and-Link
  # liquid defnition: https://docs.looker.com/reference/liquid-variables
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
      label: "Drill to User Dashboard"
      url: "/dashboards/1?Category={{ value | url_encode }}"
    }
    link: {
      label: "Drill to Top Brands look"
      url: "/looks/2?f[products.category]={{ value }}"
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

# Allows you to select a brand with out adding the brand as a regular filter and affecting the where clause
  filter: brand_select {
    description: "use this for comparitor fields only"
    suggest_dimension: brand
    type: string
  }

# If the brand value in the brand dimension matches the brand value in the brand_select then concatenate a space else display brand values
  dimension: category_comparitor {
    description: "Compare a selected brand vs other brands in the category"
    sql: Case When {% condition brand_select %} brand {% endcondition %}
            THEN concat('  ',${brand})
            ELSE ${brand}
            END;;
    html: {% if value contains '  ' %}
          <p style="color: black; background-color: lightblue">{{ rendered_value }}</p>
          {% else %} {{ rendered_value }}
          {% endif %}
                  ;;
  }

# If the brand value in the brand dimension matches the brand value in the brand_select then concatenate a space else group the other brands into "All other brands"
# Add drill_field to allow users to click on "All other brands" to drill to the brands that make up that grouping
  dimension: category_comparitor_2 {
    description: "Compare a selected brand vs other brands in the category"
    sql: Case When {% condition brand_select %} brand {% endcondition %}
            THEN concat('  ',${brand})
            ELSE ${category}
            END;;
    html:
    <a href="#drillmenu" target="_self">
    {% if value contains '  ' %}
    <p style="background-color: lightblue">{{ rendered_value }}</p>
    {% else %} {{ rendered_value }}
    {% endif %}
    </a>
    ;;
    drill_fields: [brand, count]
  }

}
