view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }


  dimension: age_tier {
    type: tier
    tiers: [15,25,35,50,65]
    style: integer
    sql: ${age} ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }



  dimension: email {
    type: string
    sql: CASE WHEN '{{_user_attributes["secure_email"]}}' = 'Yes'
        THEN ${TABLE}.email
        ELSE
        Null
        END;;
    link: {
      label: "test"
      url: "https://localhost:9999/dashboards/1"
    }
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }


  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: full_name {
    type:  string
    sql:  ${first_name} || ' ' || ${last_name} ;;
    link: {
      label: "Google link"
      url: "https://www.google.co.uk/#q={{ order_items.user_id._value }}"
    }
  }


  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
    map_layer_name: us_states
  }

  dimension: traffic_source {
    type:  string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    hidden:  yes
    type: number
    sql: ${TABLE}.zip ;;
  }

  dimension: zipcode {
    type:  zipcode
    sql:  ${zip} ;;
  }

  dimension: is_new_users {
    type: yesno
    sql: DATEDIFF(day,${created_date},CURRENT_DATE)<= 90;;
  }

  measure: count_new_users {
    type: count
    filters: {
      field: is_new_users
      value: "yes"
    }
  }


  dimension: formatted_gender {
    sql: ${TABLE}.gender;;
    html:
    {% if value == 'Female' %}
    <p style="color: black; background-color: lightblue; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value == 'Male' %}
    <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% else %}
    <p style="color: black; background-color: orange; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% endif %} ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure:formatted_count{
    type:count
    html:
    {% if value > 10000 %}
    <font color="darkgreen">{{ rendered_value }}</font>
    {% endif %};;
  }

  measure:  count_users_returned {
    type: count
    filters: {
      field: order_items.is_returned
      value: "Yes"
    }
  }

#  measure: perc_user_returns {
#    type: number
#    sql: ${count_users_returned}/NULLIF(${count},0) ;;
#  }

  measure: avg_spend_per_user {
    type: number
    sql: ${order_items.total_sale_price}/NULLIF(${count},0) ;;
    value_format_name: usd
    drill_fields: [age_tier,gender,avg_spend_per_user]
  }


  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      last_name,
      first_name,
      events.count,
      orders.count,
      user_data.count
    ]
  }
}
