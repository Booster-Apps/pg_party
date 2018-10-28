# frozen_string_literal: true

ActiveRecord::Schema.define do
  execute("CREATE SCHEMA e9651f34")

  enable_extension "uuid-ossp"
  enable_extension "pgcrypto"

  create_range_partition :bigint_date_ranges, partition_key: ->{ "(created_at::date)" } do |t|
    t.timestamps null: false
  end

  create_range_partition_of \
    :bigint_date_ranges,
    name: :bigint_date_ranges_a,
    partition_key: ->{ "(created_at::date)" },
    start_range: Date.today,
    end_range: Date.tomorrow

  create_table_like :bigint_date_ranges_a, :bigint_date_ranges_b

  attach_range_partition \
    :bigint_date_ranges,
    :bigint_date_ranges_b,
    start_range: Date.tomorrow,
    end_range: Date.tomorrow + 1

  create_range_partition :bigint_month_ranges, partition_key: ->{ "EXTRACT(YEAR FROM created_at), EXTRACT(MONTH FROM created_at)" } do |t|
    t.timestamps null: false
  end

  create_range_partition_of \
    :bigint_month_ranges,
    name: :bigint_month_ranges_a,
    partition_key: ->{ "EXTRACT(YEAR FROM created_at), EXTRACT(MONTH FROM created_at)" },
    start_range: [Date.today.year, Date.today.month],
    end_range: [(Date.today + 1.month).year, (Date.today + 1.month).month]

  create_table_like :bigint_month_ranges_a, :bigint_month_ranges_b

  attach_range_partition \
    :bigint_month_ranges,
    :bigint_month_ranges_b,
    start_range: [(Date.today + 1.month).year, (Date.today + 1.month).month],
    end_range: [(Date.today + 2.months).year, (Date.today + 2.months).month]

  create_range_partition :bigint_custom_id_int_ranges, primary_key: :some_id, partition_key: :some_int do |t|
    t.integer :some_int, null: false
  end

  create_range_partition_of \
    :bigint_custom_id_int_ranges,
    name: :bigint_custom_id_int_ranges_a,
    primary_key: :some_id,
    partition_key: :some_int,
    start_range: 0,
    end_range: 10

  create_table_like :bigint_custom_id_int_ranges_a, :bigint_custom_id_int_ranges_b

  attach_range_partition \
    :bigint_custom_id_int_ranges,
    :bigint_custom_id_int_ranges_b,
    start_range: 10,
    end_range: 20

  create_range_partition :uuid_string_ranges, id: :uuid, partition_key: :some_string do |t|
    t.text :some_string, null: false
  end

  create_range_partition_of \
    :uuid_string_ranges,
    name: :uuid_string_ranges_a,
    partition_key: :some_string,
    start_range: "a",
    end_range: "l"

  create_table_like :uuid_string_ranges_a, :uuid_string_ranges_b

  attach_range_partition \
    :uuid_string_ranges,
    :uuid_string_ranges_b,
    start_range: "l",
    end_range: "z"

  create_list_partition :bigint_boolean_lists, partition_key: :some_bool do |t|
    t.boolean :some_bool, default: true, null: false
  end

  create_list_partition_of \
    :bigint_boolean_lists,
    name: :bigint_boolean_lists_a,
    partition_key: :some_bool,
    values: true

  create_table_like :bigint_boolean_lists_a, :bigint_boolean_lists_b

  attach_list_partition \
    :bigint_boolean_lists,
    :bigint_boolean_lists_b,
    values: false

  create_list_partition :bigint_custom_id_int_lists, primary_key: :some_id, partition_key: :some_int do |t|
    t.integer :some_int, null: false
  end

  create_list_partition_of \
    :bigint_custom_id_int_lists,
    name: :bigint_custom_id_int_lists_a,
    primary_key: :some_id,
    partition_key: :some_int,
    values: [1, 2]

  create_table_like :bigint_custom_id_int_lists_a, :bigint_custom_id_int_lists_b

  attach_list_partition \
    :bigint_custom_id_int_lists,
    :bigint_custom_id_int_lists_b,
    values: [3, 4]

  create_list_partition :uuid_string_lists, id: :uuid, partition_key: :some_string do |t|
    t.text :some_string, null: false
  end

  create_list_partition_of \
    :uuid_string_lists,
    name: :uuid_string_lists_a,
    partiton_key: :some_string,
    values: ["a", "b"]

  create_table_like :uuid_string_lists_a, :uuid_string_lists_b

  attach_list_partition \
    :uuid_string_lists,
    :uuid_string_lists_b,
    values: ["c", "d"]
end
