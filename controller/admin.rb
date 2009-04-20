module KamiParty
  class Admin < Controller
    map '/admin'
    layout :admin
    helper :form

    def index
      @parts = Part.filter(:language => language)
    end

    def edit(part_id)
      @part = Part[part_id]
      part_form_context "Part updated"
    end

    def new
      @part = Part.new
      part_form_context "Part updated"
    end

    private

    def part_form_context(success_message)
      @layouts = Part.layouts_hash
      @syntaxes = Part.syntaxes

      return unless request.post?

      @part.update_from(request)

      if @part.valid? and @part.save
        flash[:good] = success_message
        redirect @part.href_edit
      else
        form_errors_from_model(@part)
      end
    end
  end
end
