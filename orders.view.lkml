view: orders {
  sql_table_name: public.orders ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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
      year,
      hour_of_day
    ]
    sql: ${TABLE}.created_at ;;
  }



  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.last_name, users.first_name, users.id, order_items.count]
  }

  measure:  formatted_count {
    type: count
    html: {% if value < 5000 %}
          <p style="color: white; background-color: darkred; margin: 0; text-align:center">{{ rendered_value }}</p>
          {% else %}
          <p style="color: white; background-color: darkgreen; margin: 0; text-align:center">{{ rendered_value }}</p>
          {% endif %}

    ;;
  }

}
