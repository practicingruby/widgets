task :default do
  ruby "experiments/006.rb"
end

task :x, [:num] do |t, params|
  sh "git checkout #{params[:num]}"
  ruby "experiments/#{num}.rb"
  sh "git checkout master"
end