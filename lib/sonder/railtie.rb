module Chewy
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/chewy.rake'
    end
  end
end
