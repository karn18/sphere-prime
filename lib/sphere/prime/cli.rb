require 'thor'

module Sphere
  module Prime
    class Cli < Thor
      include Thor::Actions

      # class_option :verbose, type: :boolean

      attr_reader :framework

      FRAMEWORKS = {
        ruby: %w[.rubocop.yml],
        javascript: %w[.eslintrc]
      }.freeze

      def self.exit_on_failure?
        true
      end

      def self.source_root
        File.dirname(__FILE__)
      end

      desc "init [destination]...", "Initialize with essential config files"
      long_desc <<~DESC
        usage: init DESTINATION --framwork ruby

        framework:
        \x5- ruby: It will generate .rubocop.yml
        \x5- javascript: It will generate .estintrc
      DESC
      option :framework, type: :string, required: true, aliases: '-f'
      def init(*project_paths)
        # puts "framework: #{options[:framework]}" if options[:framework]
        @framework = options[:framework]&.to_sym || :all

        project_paths ||= Dir.pwd
        project_paths.each do |path|
          create_files(path)
        end
      end

      private

      def init_files
        FRAMEWORKS[framework]
      end

      def create_files(path)
        init_files.each do |file|
          copy_file File.join(self.class.source_root, 'templates', file), File.join(path, file)
        end
      end
    end
  end
end
