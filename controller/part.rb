module KamiParty
  class Parts < Ramaze::Controller
    map '/'
    layout :layout
    engine :Liquid
    helper :localize

    def index(*name)
      @location = name.any? ? name.join('/') : 'home'
      @part = Part[:name => @location, :language => language]

      render_partial(:show) do |action|
        action.engine = @part.engine
      end
    end

    def layout(*name)
      return '{{ content }}' unless @part and layout_part = @part.layout
      action.engine = layout_part.engine

      return layout_part.template
    end

    def show
      @part.template
    end

    private

    def language
      locale.language
    end
  end
end
