task :default do
  loop do
    ruby "experiments/015.rb" rescue nil
  end 
end

task :x, [:num] do |t, params|
  sh "git checkout #{params[:num]}"
  ruby "experiments/#{params[:num]}.rb"
  sh "git checkout master"
end