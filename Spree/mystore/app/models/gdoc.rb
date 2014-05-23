require "rubygems"
require "google_drive"

class Gdoc < ActiveRecord::Base
	
	# Logs in.
	# You can also use OAuth. See document of
	# GoogleDrive.login_with_oauth for details.
	session = GoogleDrive.login("tallerdi.1.2014@gmail.com", "tdi12014")

	# First worksheet of
	# https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
	ws = session.spreadsheet_by_key("0As9H3pQDLg79dHRzMG5US21Tem4wRk05c2ZtVnkxbnc").worksheets[0]

	# Gets content of A2 cell.
	#p ws[2, 1]  #==> "hoge"

	# Changes content of cells.
	# Changes are not sent to the server until you call ws.save().
	#ws[2, 1] = "foo"
	#ws[2, 2] = "bar"
	#ws.save()

	# Dumps all cells.
	#for row in 1..ws.num_rows
	#  for col in 1..ws.num_cols
	#    p ws[row, col]
	#  end
	#end

	# Yet another way to do so.
	#p ws.rows  #==> [["fuga", ""], ["foo", "bar]]

	# Reloads the worksheet to get changes by other clients.
	ws.reload()

	def self.obtain_date
		# Logs in.
		# You can also use OAuth. See document of
		# GoogleDrive.login_with_oauth for details.
		session = GoogleDrive.login("tallerdi.1.2014@gmail.com", "tdi12014")

		# First worksheet of
		# https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
		ws = session.spreadsheet_by_key("0As9H3pQDLg79dHRzMG5US21Tem4wRk05c2ZtVnkxbnc").worksheets[0]

		return ws[2, 2]
	end

	def self.obtain_rows
		# Logs in.
		# You can also use OAuth. See document of
		# GoogleDrive.login_with_oauth for details.
		session = GoogleDrive.login("tallerdi.1.2014@gmail.com", "tdi12014")

		# First worksheet of
		# https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
		ws = session.spreadsheet_by_key("0As9H3pQDLg79dHRzMG5US21Tem4wRk05c2ZtVnkxbnc").worksheets[0]

		num = ws.rows.count
		inform = ws.rows
		
		return inform.drop(4)
	end

	def self.obtain_info
		@datee = Gdoc.obtain_date
	    @rows = Gdoc.obtain_rows

		@rows.each do |n|
			begin
				if n[3] == ''
					auxi = nil
				else
					auxi = n[3]
				end
					
				aux = Reservation.where(:date => Date.parse(@datee), :sku => n[0], :client => n[1], :amount => n[2], :used => auxi).first
				if aux == nil
					#Reservation.delete_all(:conditions => ['NOT date = ? AND sku = ? AND client = ? AND amount = ? AND used = ?', @datee, n[0], n[1], n[2], n[3] ])	
					Reservation.create(:date => @datee, :sku => n[0], :client => n[1], :amount => n[2], :used => n[3])
				end
			rescue
				#dosomething
			end
	    end
	    return 0
	end

	def self.return_reservation(sku, cliente_id)
		others_reservation_cant = 0
		aux = Reservation.find(:all,:select => "amount, used", :conditions => ['date >= ? AND sku = ? AND NOT client = ?', Date.current - 7.days, sku, cliente_id])
		if aux == nil
			return 0
		else
			aux.each do |reservation|
				others_reservation_cant += reservation[:amount] - reservation[:used]
			end
			return others_reservation_cant
		end

	end

	def self.use_reservation(sku, cliente_id, cant)
		aux = Reservation.find(:last,:select => "amount, used", :conditions => ['date >= ? AND sku = ? AND client = ?', Date.current - 7.days, sku, cliente_id])
		cant_disp = aux[:ammount].to_i - aux[:used].to_i 
		if cant.to_i < cant_disp
		Reservation.update(:last, :used => cant + aux[:used], :conditions => ['date >= ? AND sku = ? AND client = ?', Date.current - 7.days, sku, cliente_id])
		else
		#Reservation.delete_all(:conditions => ['client = ? AND sku = ?', cliente_id, sku ])	
		end	
	end
end
