include: "products.view"

view: brand_comparison {
  extends: [products]

# filter: brand_filter_1 {
#   suggest_dimension: brand
# #  suggestions: ["Calvin Klein","Allegra K"]
#   type:  string
# }
#
# filter: brand_filter_2 {
#     suggest_dimension: brand
#     type:  string
#   }
#
# dimension: brand_version {
#   type: string
#   sql: CASE WHEN {% condition brand_filter_1 %} brand {% endcondition %} THEN 'Brand_1'
#        WHEN {% condition brand_filter_2 %} brand {% endcondition %} THEN 'Brand_2'
#       END;;
# }

### proves why templated filters are necessary #####
#   dimension: brand_version_2 {
#     type: string
#     sql: CASE WHEN  ${brand_filter_1} = ${brand} THEN 'Brand_1'
#       END;;
#   }


filter: brand_select {
  suggest_dimension: brand
  type: string
}

filter: category_select {
  suggest_dimension: category
  type: string
}


  dimension: all_brand_comparitor {
    description: "Compare a selected brand vs all other brands. Ignores category selection"
    sql: Case When {% condition brand_select %} brand {% endcondition %}
               THEN ${brand}
               Else 'All other brands'
               End;;
  }

  dimension: brand_comparitor {
    description: "Compare a selected brand vs other brands in the category vs all other brands"
    sql: Case When {% condition brand %} brand {% endcondition %}
            THEN ${brand}
            WHEN {% condition category %} category {% endcondition %}
            THEN ${category}
            ELSE 'All other brands'
            END;;
  }


}
