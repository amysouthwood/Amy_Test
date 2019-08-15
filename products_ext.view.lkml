include: "products.view"

view: products_ext {
extends: [products]

measure: total_sales {
  type: sum
  sql: ${retail_price} ;;
}
}
