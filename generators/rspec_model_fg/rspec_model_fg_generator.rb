require 'rails_generator/generators/components/model/model_generator'
require File.dirname(__FILE__) + '/rspec_default_values'

class RspecModelFgGenerator < ModelGenerator

  def manifest

    record do |m|
      # Check for class naming collisions.
      m.class_collisions class_path, class_name

      # Model, spec, and factory directories.
      m.directory File.join('app/models', class_path)
      m.directory File.join('spec/models', class_path)

      unless options[:skip_factory]
        m.directory File.join('spec/factories', class_path)
      end

      # Model class, spec and factories.
      m.template 'model:model.rb',      File.join('app/models', class_path, "#{file_name}.rb")
      m.template 'model_spec.rb',       File.join('spec/models', class_path, "#{file_name}_spec.rb")

      unless options[:skip_factory]
        m.template 'factories.rb',  File.join('spec/factories', "#{file_name}.rb")
      end

      unless options[:skip_migration]
        m.migration_template 'model:migration.rb', 'db/migrate', :assigns => {
          :migration_name => "Create#{class_name.pluralize.gsub(/::/, '')}"
        }, :migration_file_name => "create_#{file_path.gsub(/\//, '_').pluralize}"
      end

    end
  end

end

module Rails
  module Generator
    class GeneratedAttribute
      def default_for_factory
        @default ||= case type
          when :int, :integer               then "1"
          when :float                       then "1.5"
          when :decimal                     then "9.99"
          when :datetime, :timestamp, :time then "Time.now"
          when :date                        then "Date.today"
          when :string, :text               then "\"value for #{@name}\""
          when :boolean                     then "false"
          when :belongs_to, :references     then "1"
          else
            ""
        end
      end
    end
  end
end
