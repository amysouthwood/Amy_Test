include: "products.view"

view: brand_comparison {
  extends: [products]

# filter: brand_select {
#   suggest_dimension: brand
#   type:  string
# }
#
# filter: category_select {
#   suggest_dimension: category
#   type: string
# }

  dimension: all_brand_comparitor {
    description: "Compare a selected brand vs all other brands. Ignores category selection"
    sql: Case When {% condition brand %} brand {% endcondition %}
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
