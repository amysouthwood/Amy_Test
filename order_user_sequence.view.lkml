view: order_user_sequence {
  derived_table: {
    sql: select user_id
      , order_id as orders_id
      , created_at
      , ROW_NUMBER() Over (Partition by user_id Order by created_at) as sequence_num
      , LAG(created_at) Over( Partition by user_id Order by created_at) as prev_created_at
      , LEAD (created_at) Over( Partition by user_id Order by created_at) as next_created_at
      from order_items
      group by 1,2,3
 ;;
  }


  measure: count {
    hidden:  yes
    type: count
    drill_fields: [detail*]
  }

  measure: average_seq_num {
    type: average
    sql: ${sequence_num} ;;
  }

  dimension: user_id {
    hidden: no
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: orders_id {
    hidden: no
    primary_key: yes
    type: number
    sql: ${TABLE}.orders_id ;;
  }

  dimension_group: created_at {
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

  dimension: sequence_num {
    type: number
    sql: ${TABLE}.sequence_num ;;
  }

  dimension: is_first_order {
    type: yesno
    sql: ${sequence_num} = 1 ;;
  }

  dimension_group: prev_created_at {
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
    sql: ${TABLE}.prev_created_at ;;
  }

  dimension: has_subsequent_order {
    type: yesno
    sql: ${next_created_at_date} is not null ;;
  }

  dimension_group: next_created_at {
    type: time    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.next_created_at ;;
  }

  dimension: days_between_orders {
    type: number
    sql: DATEDIFF(day,${prev_created_at_date},${created_at_date}) ;;
  }


  measure: average_days_between_orders {
    type: average
    sql:  ${days_between_orders} ;;
  }

  dimension: is_first_purchase {
    type: yesno
    sql: ${sequence_num} = 1 ;;
  }

  measure: total_sequence_num {
    hidden: yes
    type: sum
    sql: ${sequence_num};;
  }

  measure: has_lifetime_subsequent_order {
    type: yesno
    sql: ${total_sequence_num} > 1;;
  }

  measure: 60_day_repeat_purchase_count {
    type: count_distinct
    sql: CASE WHEN ${days_between_orders} < 60 THEN ${user_id} END ;;
  }

  measure: user_count {
    type: count_distinct
    sql: ${user_id} ;;
  }

#### Can only be 100% or 0% at the user level, because a user can't have a repeat purchase rate of
#### 50%, they either repeat a purchase in 60 days or not. So it'd have to be at the overall/total
#### aggregation level across ALL users. It probably makes more sense to get this measure against Product Brand
#### or Category.
  measure: 60_day_repeat_purchase_rate {
    type: number
    sql:  1.0 * ${60_day_repeat_purchase_count}/NULLIF(${user_count},0) ;;
    value_format: "#.0000,-#.0000"
  }

  set: detail {
    fields: [user_id, orders_id, created_at_time, sequence_num]
  }
}
