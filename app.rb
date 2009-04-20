# This file contains your application, it requires dependencies and necessary
# parts of the application.
#
# It will be required from either `config.ru` or `start.rb`

require 'rubygems'
require 'ramaze'

# Add the directory this file resides in to the load path, so you can run the
# app from any other working directory
$LOAD_PATH.unshift(__DIR__)

Ramaze.setup do
  gem 'sequel'
  gem 'haml'
  gem 'liquid'
end

# Initialize controllers and models
require 'model/init'
require 'controller/init'

module KamiParty
  def self.setup
    # create parts from proto

    if Part.count == 0
      templates = Dir[__DIR__('proto/*.liquid')]
      layout_template = templates.delete(__DIR__('proto/layout.liquid'))

      layout = Part.create(
        :name => 'layout',
        :template => File.read(layout_template))

      templates.each do |template|
        basename = File.basename(template, '.liquid')
        template = File.read(template)
        part = Part.create(
          :name => basename,
          :template => template,
          :layout => layout)
      end
    end
  end

  Ramaze.options.setup << self
end
