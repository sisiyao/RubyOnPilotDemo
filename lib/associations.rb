require 'active_support/inflector'
require_relative './assoc_options'
require_relative './assoc_options_belongsto'
require_relative './assoc_options_hasmany'

module Associations
  def belongs_to(name, options = {})
    assoc_options[name] = BelongsToOptions.new(name, options)

    define_method(name) do
      self.class.assoc_options[name].model_class
        .where(self.class.assoc_options[name].primary_key =>
          send(self.class.assoc_options[name].foreign_key))
        .first
    end
  end

  def has_many(name, options = {})
    assoc_options[name] = HasManyOptions.new(name, self.name, options)

    define_method(name) do
      self.class.assoc_options[name].model_class
        .where(self.class.assoc_options[name].foreign_key => send(self.class.assoc_options[name].primary_key))
    end
  end

  def assoc_options
    @assoc_options ||= {}
    @assoc_options
  end

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]
      source_table = source_options.table_name
      through_table = through_options.table_name

      results = DBConnection.execute(<<-SQL)
        SELECT #{source_table}.*
        FROM #{through_table}
        JOIN #{source_table}
        ON #{through_table}.#{source_options.foreign_key}
          = #{source_table}.#{source_options.primary_key}
        WHERE #{through_table}.#{through_options.primary_key}
          = #{send(through_options.foreign_key)}
      SQL

      source_options.model_class.parse_all(results).first
    end
  end

  def has_many_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]
      source_table = source_options.table_name
      through_table = through_options.table_name

      if through_options.class == HasManyOptions && source_options.class == HasManyOptions
        results = DBConnection.execute(<<-SQL)
          SELECT #{source_table}.*
          FROM #{through_table}
          JOIN #{source_table}
          ON #{through_table}.#{source_options.primary_key}
            = #{source_table}.#{source_options.foreign_key}
          WHERE #{through_table}.#{through_options.foreign_key}
            = #{send(through_options.primary_key)}
        SQL
      elsif through_options.class == BelongsToOptions && source_options.class == HasManyOptions
        results = DBConnection.execute(<<-SQL)
          SELECT #{source_table}.*
          FROM #{through_table}
          JOIN #{source_table}
          ON #{through_table}.#{source_options.primary_key}
            = #{source_table}.#{source_options.foreign_key}
          WHERE #{source_table}.#{source_options.foreign_key}
            = #{send(through_options.foreign_key)}
        SQL
      elsif through_options.class == HasManyOptions && source_options.class == BelongsToOptions
        results = DBConnection.execute(<<-SQL)
          SELECT #{source_table}.*
          FROM #{through_table}
          JOIN #{source_table}
          ON #{through_table}.#{source_options.foreign_key}
            = #{source_table}.#{source_options.primary_key}
          WHERE #{through_table}.#{through_options.foreign_key}
            = #{send(through_options.primary_key)}
        SQL
      end

      source_options.model_class.parse_all(results)
    end
  end
end
