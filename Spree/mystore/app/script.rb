


	  #puts "Orange2"
	  @r=" "
	  File.open('laprueba2.txt', 'r+') do |f2|  
	  # use "\n" for two lines of text  
	  while line = f2.gets  
    	f2.puts line 
    	 
  	  end  
	  
	  @aux="b"#Time.now.strftime('%Y%m%d%H%M%S%L')#Time.now.utc.iso8601.gsub('-', '').gsub(':', '') 
	  f2.puts @aux
	  

	
	#puts "Apple2"
end