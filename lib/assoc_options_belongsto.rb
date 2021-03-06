class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    defaults = {
      foreign_key: "#{name}_id".to_sym,
      primary_key: :id,
      class_name: name.to_s.camelcase
    }.merge(options)

    @foreign_key = defaults[:foreign_key]
    @primary_key = defaults[:primary_key]
    @class_name = defaults[:class_name]
  end
end
