module Services
  class GenerateCustomStyle
    attr_reader :company, :body, :env, :filename, :scss_file

    def initialize(company_id)
      company = Company.find(company_id)
      @company = company
      @filename = "#{company.id}_company"
      @scss_file = File.new(scss_file_path, 'w')
      @body = ERB.new(File.read(template_file_path)).result(binding)
      @env = Rails.application.assets
    end

    def compile
      find_or_create_scss

      begin
        scss_file.write generate_css
        scss_file.flush
        @company.update(css: scss_file)
      ensure
        scss_file.close
        File.delete(scss_file)
      end
    end

    private

    def template_file_path
      @template_file_path ||= File.join(Rails.root, 'app', 'assets', 'stylesheets', '_template.scss.erb')
    end

    def scss_tmpfile_path
      @scss_file_path ||= File.join(Rails.root, 'tmp', 'generate_css')
      FileUtils.mkdir_p(@scss_file_path) unless File.exists?(@scss_file_path)
      @scss_file_path
    end

    def scss_file_path
      @scss_file_path ||= File.join(scss_tmpfile_path, "#{filename}.scss.css")
    end

    def find_or_create_scss
      File.open(scss_file_path, 'w') { |f| f.write(body) }
    end

    def generate_css
      SassC::Engine.new(asset_source, {
        syntax: :scss,
        cache: false,
        read_cache: false,
        style: :compressed
      }).render
    end

    def asset_source
      env = Sprockets::Railtie.build_environment Rails.application
      if env.find_asset(filename)
        env.find_asset(filename).source
      else
        uri = Sprockets::URIUtils.build_asset_uri(scss_file.path, type: "text/css")
        asset = Sprockets::UnloadedAsset.new(uri, env)
        env.load(asset.uri).source
      end
    end
  end
end