# implementation from https://github.com/rails/rails/pull/16919


# activerecord/lib/active_record/connection_adapters/postgresql/oid/interval.rb

require "active_support/duration"

module ActiveRecord
  module ConnectionAdapters
    module PostgreSQL
      module OID # :nodoc:
        class Interval < Type::Value # :nodoc:
          def type
            :interval
          end

          def cast_value(value)
            case value
              when ::ActiveSupport::Duration
                value
              when ::String
                begin
                  ::ActiveSupport::Duration.parse(value)
                rescue ::ActiveSupport::Duration::ISO8601Parser::ParsingError
                  nil
                end
              else
                super
            end
          end

          def serialize(value)
            case value
              when ::ActiveSupport::Duration
                value.iso8601(precision: self.precision)
              when ::Numeric
                # Sometimes operations on Times returns just float number of seconds so we need to handle that.
                # Example: Time.current - (Time.current + 1.hour) # => -3600.000001776 (Float)
                value.seconds.iso8601(precision: self.precision)
              else
                super
            end
          end
        end
      end
    end
  end
end


# activerecord/lib/active_record/connection_adapters/postgresql/schema_definitions.rb

module ActiveRecord
  module ConnectionAdapters
    module PostgreSQL
      module SchemaDefinitions
        def interval(name, options = {})
          column(name, :interval, options)
        end
      end
    end
  end
end


# activerecord/lib/active_record/connection_adapters/postgresql/schema_statements.rb

require 'active_record/connection_adapters/postgresql/schema_statements'

module SchemaStatementsWithInterval
  def type_to_sql(type, limit: nil, precision: nil, scale: nil, array: nil, **)
    case type.to_s
      when 'interval'
        case precision
          when nil;  "interval"
          when 0..6; "interval(#{precision})"
          else raise(ActiveRecordError, "No interval type has precision of #{precision}. The allowed range of precision is from 0 to 6")
        end
      else
        super
    end
  end
end

ActiveRecord::ConnectionAdapters::PostgreSQL::SchemaStatements.send(:prepend, SchemaStatementsWithInterval)


# activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb

require 'active_record/connection_adapters/postgresql_adapter'

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES[:interval] = { name: 'interval'}

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.class_eval do

  alias_method :initialize_type_map_without_interval, :initialize_type_map
  define_method :initialize_type_map do |m = type_map|
    initialize_type_map_without_interval(m)
    m.register_type 'interval' do |_, _, sql_type|
      precision = extract_precision(sql_type)
      ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::OID::Interval.new(precision: precision)
    end
  end

  alias_method :configure_connection_without_interval, :configure_connection
  define_method :configure_connection do
    configure_connection_without_interval
    execute('SET intervalstyle = iso_8601', 'SCHEMA')
  end

  ActiveRecord::Type.register(:interval, ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::OID::Interval, adapter: :postgresql)
end
