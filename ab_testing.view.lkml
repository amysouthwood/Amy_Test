include: "user_lifetime_data.view"


view: ab_testing {
 extends: [user_lifetime_data]

# Add any variables here for splitting your data into A and B groups (in this case gender and age)
  filter: a_b_gender {
    type: string
    suggest_dimension: users.gender
  }

  filter: a_b_age {}

  dimension: a_b {
  type: yesno
  sql: {% condition a_b_gender %} gender {% endcondition %}
  --AND {% condition a_b_age %} age {% endcondition %}
  ;;
  }

   measure: count_a {
   type: count
   filters: {
     field: a_b
     value: "yes"
     }
   }

   measure: count_b {
   type: count
   filters:{
     field: a_b
     value: "no"
     }
   }

# Put in the measures for your variable of interest (in this case, lifetime orders)
  measure: average_lifetime_orders_a {
  type: average
  sql: 1.0 * ${order_count} ;;
  value_format: "#.00"
  filters:{
    field: a_b
    value: "yes"
    }
  }

  measure: average_lifetime_orders_b {
  type: average
  sql: 1.0 * ${order_count};;
  value_format: "#.00"
  filters:{
    field: a_b
    value: "no"
    }
  }

  measure: stdev_lifetime_orders_a {
  type: number
  sql:
  1.0 * STDDEV(all CASE WHEN ${a_b} THEN ${order_count} ELSE NULL END) ;;
  value_format: "#.00"
  }


  measure: stdev_lifetime_orders_b {
  type: number
  sql:
  1.0 * STDDEV(all CASE WHEN NOT ${a_b} THEN ${order_count} ELSE NULL END) ;;
  value_format: "#.00"
  }

  measure: t_score {
  type: number
  sql:
  1.0 * (${average_lifetime_orders_a} - ${average_lifetime_orders_b}) /
  SQRT(
  (POWER(${stdev_lifetime_orders_a},2) / ${count_a}) + (POWER(${stdev_lifetime_orders_b},2) / ${count_b})
  ) ;;
  value_format: "#.00"
  }

  measure: significance {
  type: string
  sql: CASE
  WHEN (ABS(${t_score}) > 3.291) THEN '(7) .0005 sig. level'
  WHEN (ABS(${t_score}) > 3.091) THEN '(6) .001  sig. level'
  WHEN (ABS(${t_score}) > 2.576) THEN '(5) .005 sig. level'
  WHEN (ABS(${t_score}) > 2.326) THEN '(4) .01 sig. level'
  WHEN (ABS(${t_score}) > 1.960) THEN '(3) .025 sig. level'
  WHEN (ABS(${t_score}) > 1.645) THEN '(2) .05 sig. level'
  WHEN (ABS(${t_score}) > 1.282) THEN '(1) .1 sig. level'
  ELSE '(0) Insignificant'
  END;;
  }

  }
