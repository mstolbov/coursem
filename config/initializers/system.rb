Dry::Rails.container do
  config.component_dirs.add "app/operations"
  # config.component_dirs.add "lib" do |dir|
  #   dir.namespaces.add "my_super_cool_app", key: nil
  # end
end
