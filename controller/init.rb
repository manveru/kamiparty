module KamiParty
  class Controller < Ramaze::Controller
    layout :default
    map_layouts '/'
    helper :xhtml, :localize
    engine :Haml

    private

    def language
      locale.language
    end
  end

  # Here go your requires for subclasses of Controller:
  require 'controller/admin'
  require 'controller/part'
  require 'controller/css'
end
