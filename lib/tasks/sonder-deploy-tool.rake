namespace :sondermind do
  desc 'When application is getting build for deployment this is used to build the elastic beanstalk config for the environment'


  task :build_eb_config => :environment do
    build_app_name = ENV["BUILD_APP"]
    config = YAML.load(File.new("deploy/deploy_config.yml").read)
    config = config["environments"][build_app_name.to_s]

    eb_config = YAML.load(File.new("deploy/environments/#{build_app_name}/eb-config.yml").read)

    # Add More files if needed
    eb_files = eb_config["files"] || {}
    eb_config["files"] = eb_files
    if config["files"].present?
      config["files"].each_pair do |file_name, value|
        eb_files[file_name] = {
            "owner" => value["owner"],
            "group" =>  value["group"],
            "mode" => value["mode"],
            "content" => File.new("deploy/environments/#{build_app_name}/files/#{value["content"]}").read
        }
      end
    end

    # Add extra container commands
    eb_container_commands = eb_config["container_commands"]  || {}
    eb_config["container_commands"] = eb_container_commands
    if config["container_commands"].present?
      config["container_commands"].each_pair do |name, value|
        eb_container_commands[name] = {
            "command" => value["command"],
            "ignoreErrors" => value["ignoreErrors"],
            "leader_only" => value["leader_only"]
        }
      end
    end

    # Add Extra Options Settings
    eb_option_settings = eb_config["option_settings"] ||  []
    eb_config["option_settings"] = eb_option_settings
    if config["option_settings"].present?
      config["option_settings"].each do |option|
        eb_option_settings << option
      end
    end

    # FileUtils::mkdir_p '.elasticbeanstalk'
    #
    # deploy_config = {
    #     "global" => {
    #         "application_name" => config["eb_application"],
    #         "default_ec2_keyname" => config["default_ec2_keyname"],
    #         "default_region" => config['default_region']
    #     }
    # }

    # File.open('.elasticbeanstalk/config.yml', 'w') {|f|
    #   f.write deploy_config.to_yaml
    # }

    FileUtils::mkdir_p '.ebextensions'

    File.open('.ebextensions/00deploy.config', 'w') {|f|
      f.write eb_config.to_yaml
    }



  end



end

