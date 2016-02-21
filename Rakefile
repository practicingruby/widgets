task :default do
  ruby "experiments/009.rb"
end

task :x, [:num] do |t, params|
  sh "git checkout #{params[:num]}"
  ruby "experiments/#{params[:num]}.rb"
  sh "git checkout master"
end