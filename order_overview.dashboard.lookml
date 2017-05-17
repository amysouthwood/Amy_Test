- dashboard: order_overview
  title: Order Overview
  layout: newspaper
  elements:
  - name: Revenue past 30 days
    label: Revenue past 30 days
    model: red_ecommerce
    explore: order_items
    type: single_value
    fields:
    - order_items.total_gross_revenue
    filters:
      orders.created_date: 30 days
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    listen: {}
    row: 0
    col: 0
    width: 6
    height: 4
  - name: Number of New Users past 30 days
    label: Number of New Users past 30 days
    model: red_ecommerce
    explore: users
    type: single_value
    fields:
    - users.count
    filters:
      users.created_date: 30 days
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    show_view_names: true
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_ignored_fields: []
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    listen: {}
    row: 0
    col: 6
    width: 6
    height: 4
  - name: Gross Margin % past 30 days
    label: Gross Margin % past 30 days
    model: red_ecommerce
    explore: order_items
    type: single_value
    fields:
    - inventory_items.gross_margin_perc
    filters:
      inventory_items.sold_date: 30 days
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    listen: {}
    row: 0
    col: 12
    width: 6
    height: 4
  - name: Avg Customer Spend past 30 days
    label: Avg Customer Spend past 30 days
    model: red_ecommerce
    explore: order_items
    type: single_value
    fields:
    - users.avg_spend_per_user
    filters:
      orders.created_date: 30 days
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    listen: {}
    row: 0
    col: 18
    width: 6
    height: 4
  - name: Year over Year Revenue
    label: Year over Year Revenue
    model: red_ecommerce
    explore: order_items
    type: looker_column
    fields:
    - order_items.total_gross_revenue
    - orders.created_year
    fill_fields:
    - orders.created_year
    sorts:
    - orders.created_year desc
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    listen: {}
    row: 4
    col: 0
    width: 12
    height: 8
  - name: Revenue and Profit
    label: Revenue and Profit
    model: red_ecommerce
    explore: order_items
    type: looker_line
    fields:
    - order_items.total_gross_revenue
    - inventory_items.total_gross_margin
    - orders.created_month
    fill_fields:
    - orders.created_month
    filters:
      orders.created_date: 12 months
    sorts:
    - orders.created_month desc
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    show_null_points: true
    point_style: none
    interpolation: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    listen: {}
    row: 4
    col: 12
    width: 12
    height: 8
  - name: User Additions to date vs Prior Month
    label: User Additions to date vs Prior Month
    model: red_ecommerce
    explore: order_items
    type: looker_bar
    fields:
    - users.created_month
    - users.count
    filters:
      users.created_date: 2 months
    sorts:
    - users.created_month desc
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: prior_month
      label: Prior Month
      expression: offset(${users.count},1)
      value_format:
      value_format_name:
    query_timezone: America/Los_Angeles
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: ordinal
    y_axis_scale_mode: linear
    ordering: asc
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    value_labels: legend
    label_type: labPer
    show_null_points: true
    point_style: circle
    font_size: '12'
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    interpolation: linear
    hidden_fields:
    - prior_month
    series_colors:
      users.count: "#62bad4"
    series_types: {}
    hide_legend: false
    listen: {}
    row: 12
    col: 0
    width: 12
    height: 7
  - name: Demographics Analysis
    label: Demographics Analysis
    model: red_ecommerce
    explore: users
    type: looker_area
    fields:
    - users.age_tier
    - order_items.total_gross_revenue
    - users.gender
    pivots:
    - users.gender
    filters:
      users.age_tier: "-Below 15"
    sorts:
    - users.age_tier
    - users.gender
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    show_null_points: false
    point_style: none
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: positron
    map_position: fit_data
    map_scale_indicator: 'off'
    map_pannable: true
    map_zoomable: true
    map_marker_type: circle
    map_marker_icon_name: default
    map_marker_radius_mode: proportional_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_legend: true
    quantize_map_value_colors: false
    value_labels: legend
    label_type: labPer
    ordering: none
    show_null_labels: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_ignored_fields: []
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    listen: {}
    row: 12
    col: 12
    width: 12
    height: 7
  - name: Revenue by User Type over 90 days
    label: Revenue by User Type over 90 days
    model: red_ecommerce
    explore: users
    type: looker_pie
    fields:
    - users.is_new_users
    - order_items.total_gross_revenue
    fill_fields:
    - users.is_new_users
    filters:
      orders.created_date: 90 days
    sorts:
    - users.is_new_users desc
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    value_labels: labels
    label_type: labPer
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    series_labels:
      'Yes': New User
      'No': Existing User
    listen: {}
    row: 19
    col: 0
    width: 12
    height: 7
  - name: Average Spend per User by Revenue Source
    label: Average Spend per User by Revenue Source
    model: red_ecommerce
    explore: order_items
    type: looker_column
    fields:
    - users.avg_spend_per_user
    - users.traffic_source
    - users.is_new_users
    pivots:
    - users.is_new_users
    fill_fields:
    - users.is_new_users
    sorts:
    - users.is_new_users 0
    - users.traffic_source desc
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    stacking: normal
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_ignored_fields: []
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    listen: {}
    row: 19
    col: 12
    width: 12
    height: 7
  - name: Gross Margin by State
    label: Gross Margin by State
    model: red_ecommerce
    explore: order_items
    type: looker_map
    fields:
    - inventory_items.total_gross_margin
    - users.state
    sorts:
    - inventory_items.total_gross_margin desc
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: positron
    map_position: custom
    map_scale_indicator: 'off'
    map_pannable: true
    map_zoomable: true
    map_marker_type: circle
    map_marker_icon_name: default
    map_marker_radius_mode: proportional_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_view_names: true
    show_legend: true
    quantize_map_value_colors: false
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    map_latitude: 51.56341232867588
    map_longitude: -110.830078125
    map_zoom: 3
    listen: {}
    row: 26
    col: 0
    width: 12
    height: 7
  - name: Top Products
    label: Top Products
    model: red_ecommerce
    explore: order_items
    type: looker_column
    fields:
    - products.brand
    - inventory_items.gross_margin_perc
    - order_items.total_gross_revenue
    sorts:
    - inventory_items.gross_margin_perc desc
    limit: 10
    column_limit: 50
    dynamic_fields:
    - table_calculation: of_total_revenue
      label: "% of Total Revenue"
      expression: "${order_items.total_gross_revenue}/sum(${order_items.total_gross_revenue})"
      value_format:
      value_format_name: percent_1
    query_timezone: America/Los_Angeles
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_fields:
    - order_items.total_gross_revenue
    y_axes:
    - label: ''
      maxValue:
      minValue:
      orientation: left
      showLabels: true
      showValues: true
      tickDensity: default
      tickDensityCustom: 5
      type: linear
      unpinAxis: false
      valueFormat:
      series:
      - id: inventory_items.gross_margin_perc
        name: Inventory Items Gross Margin Perc
    - label:
      maxValue:
      minValue:
      orientation: right
      showLabels: true
      showValues: true
      tickDensity: default
      tickDensityCustom: 5
      type: linear
      unpinAxis: false
      valueFormat:
      series:
      - id: of_total_revenue
        name: "% of Total Revenue"
    listen:
      Brand: products.brand
    row: 26
    col: 12
    width: 12
    height: 7
  filters:
  - name: Brand
    title: Brand
    type: field_filter
    default_value: ''
    model: red_ecommerce
    explore: order_items
    field: products.brand
    listens_to_filters: []
    allow_multiple_values: true
