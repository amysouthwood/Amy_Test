
view: word {
  extends: [numbers16]
  dimension: name {
    sql: SPLIT_PART(${products.name},' ', ${num}::integer) ;;
  }
}

#explore: numbers16 {}
view: numbers16 {
  derived_table: {
    sql:
      SELECT
         row_number() OVER () num
      FROM
        (SELECT 1 n UNION SELECT 2 n ) t1,
        (SELECT 1 n UNION SELECT 2 n ) t2,
        (SELECT 1 n UNION SELECT 2 n ) t3,
        (SELECT 1 n UNION SELECT 2 n ) t4
        ;;
  }
  dimension: num {hidden: yes}
}
