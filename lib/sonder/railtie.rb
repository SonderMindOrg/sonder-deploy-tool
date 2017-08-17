module Chewy
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/sonder-deploy-tool.rake'
    end
  end
end
