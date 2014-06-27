namespace :my_namespace do
  desc "TODO"
  task my_task1: :environment do
  end

  desc "TODO"
  task my_task5: :environment do
  	exec("java -cp bin:/home/administrator/commandsapp/src/commons-lang-2.6.jar:/home/administrator/commandsapp/src/commons-logging-1.1.3.jar:/home/administrator/commandsapp/src/jackcess-2.0.2.jar:/home/administrator/commandsapp/src/opencsv-2.3.jar principal.main")
    end

  desc "TODO"
  task my_task3: :environment do
    puts "\nInicio"
    puts DateTime.now
    puts Rabbitmpq.leerReposicion
    puts "1"
    puts Rabbitmpq.leerOferta
    puts "2"
    puts Offer.publicarTwitter
    puts "3"
    puts Offer.cambiarPrecio
    puts "4"
    #Reposicion.reponer
    puts "Termino"
    puts "M1"
    Gdoc.obtain_info
    puts "M2"
  end

  desc "TODO"
  task my_task10: :environment do
    puts "\nInicio"
    puts DateTime.now
    puts Schedule.new_orders
    puts "Ordenes Revisadas y Actualizadas"
    #puts Schedule.main
    puts "Ordenes procesadas"
  end

  desc "TODO"
  task my_task60: :environment do
    puts "\nInicio"
    puts DateTime.now
    #puts Schedule.delivery
    puts "Ordenes despachadas"
    puts Stock.vaciarAlmacenRecepcion
    puts "Almacen Recepcion vaciada"
  end

  desc "TODO"
  task my_taskDia: :environment do
    puts "\nInicio"
    puts DateTime.now
    puts Schedule.new_product
    puts "Productos revisados"
    puts Schedule.new_reservations
    puts "Reservas revisadas"
    puts Schedule.new_pricing
    puts "Precios revisados"
  end

  desc "TODO"
  task my_taskMes: :environment do
  end

  #desc "TODO"
  #task my_taskReset: :environment do
  #  Schedule.new_product
  #  puts "Productos revisados"
  #  Schedule.new_reservations
  #  puts "Reservas revisadas"
  #  Schedule.new_pricing
  #  puts "Precios revisados"
  #  Schedule.new_orders
  #  puts "Ordenes Revisadas y Actualizadas"
  #end
end