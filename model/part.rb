module KamiParty
  class Part < Sequel::Model
    set_schema do
      primary_key :id

      varchar :name, :unique => true
      varchar :language, :default => 'en'
      varchar :syntax, :default => 'liquid'
      text :template, :default => ''

      foreign_key :layout_id
    end

    many_to_one :layout, :class => 'KamiParty::Part'

    create_table unless table_exists?

    validates do
      format_of :name, :with => %r!\A[a-zA-Z0-9_/-]+\z!
      length_of :name, :within => 1..255
    end

    # Setup Liquid

    # Be aware, Liquid allows a maximum of 100 nested templates, that should be
    # enough, but is it safe?
    def self.read_template_file(path)
      part = Part[:name => path, :syntax => 'liquid']
      part ? part.template : "Liquid error: cannot find include for %p" % path
    end

    Liquid::Template.file_system = self

    def dataset.to_liquid; self; end
    liquid_methods :id, :name, :language, :syntax, :template, :href_edit, :href

    # Utility methods

    def self.syntaxes
      %w[liquid markdown]
    end

    def self.layouts_hash
      hash = Ramaze::Dictionary['-', '-']

      filter(:layout_id => nil).select(:name, :id).each do |layout|
        hash[layout.name] = layout.id
      end

      hash
    end

    def engine
      case syntax
      when 'liquid'  ; Ramaze::View.get('Liquid')
      when 'markdown'; Ramaze::View.get('Maruku')
      else             Ramaze::View.get('Liquid')
      end
    end

    def update_from(request)
      self.name, self.template, self.syntax, self.try_layout =
        request[:name, :template, :syntax, :layout_id]
    end

    # Exposed methods

    def href
      Parts.r(Ramaze::Helper::CGI.u(name)).to_s
    end

    def href_edit
      Admin.r(:edit, id).to_s
    end

    # A layout is a part that has no layout
    def layout?
      layout_id == nil
    end

    # This makes it simple to use a default value for layouts
    def layout_fid
      layout_id || '-'
    end

    def try_layout=(id)
      if id == '-'
        self.layout = nil
      elsif layout_part = Part[id.to_i]
        if layout_part == self
          raise ArgumentError, "A Part cannot be the layout of itself"
        else
          self.layout = layout_part
        end
      else
        raise ArgumentError, "Invalid layout_id"
      end
    end
  end
end
