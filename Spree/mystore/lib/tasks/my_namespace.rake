namespace :my_namespace do
  desc "TODO"
  task my_task1: :environment do
  end

  desc "TODO"
  task my_task5: :environment do
  	exec("java -cp bin:/home/administrator/commandsapp/src/commons-lang-2.6.jar:/home/administrator/commandsapp/src/commons-logging-1.1.3.jar:/home/administrator/commandsapp/src/jackcess-2.0.2.jar:/home/administrator/commandsapp/src/opencsv-2.3.jar principal.main" )
  end

  desc "TODO"
  task my_task10: :environment do
  end

  desc "TODO"
  task my_task60: :environment do
  end

  desc "TODO"
  task my_taskDia: :environment do
  end

  desc "TODO"
  task my_taskMes: :environment do
  end

end
