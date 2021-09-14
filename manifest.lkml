project_name: "amy_s_sandbox"

# # Use local_dependency: To enable referencing of another project
# # on this instance with include: statements
#
# local_dependency: {
#   project: "name_of_other_project"
# }

constant: excluded_fields {
  value: "-inventory_items.id, -users.id"
}
