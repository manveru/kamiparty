module CSM
  class CSS < Ramaze::Controller
    map '/css'
    provide(:css, :engine => :Sass)
  end
end
