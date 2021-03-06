require "rubygems"
require "google_drive"

class Gdoc < ActiveRecord::Base
	
	# Logs in.
	# You can also use OAuth. See document of
	# GoogleDrive.login_with_oauth for details.
	session = GoogleDrive.login("tallerdi.1.2014@gmail.com", "tdi12014")

	# First worksheet of
	# https://docs.google.com/spreadsheet/ccc?key=0As9H3pQDLg79dHRzMG5US21Tem4wRk05c2ZtVnkxbnc
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
		# https://docs.google.com/spreadsheet/ccc?key=0As9H3pQDLg79dHRzMG5US21Tem4wRk05c2ZtVnkxbnc
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
					
				aux = Reservation.where(:date => Date.parse(@datee), :sku => n[0], :client => n[1], :amount => n[2]).last
				if aux == nil
					aux = Reservation.where(['date >= ? AND sku = ? AND client = ?', Date.current - 7.days, n[0], n[1] ]).select("used").last
					if aux == nil
						#Reservation.delete_all(['sku = ? AND client = ?', n[0], n[1] ])
						Reservation.create(:date => Date.parse(@datee), :sku => n[0], :client => n[1], :amount => n[2], :used => '0')
						
					else
						Reservation.where(['sku = ? AND client = ?', sku, cliente_id]).update_all(:date => Date.parse(@datee), :sku => n[0], :client => n[1], :amount => n[2], :used => aux[:used])
					end
				end
			rescue
				#dosomething
			end
	    end
	    return 0
	end

	def self.return_reservation(sku, cliente_id)
		others_reservation_cant = 0
		aux = Reservation.where(['sku = ? AND date >= ? AND NOT client = ?', sku, Date.current - 7.days, cliente_id]).select("amount, used")
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
		aux = Reservation.where(['date >= ? AND sku = ? AND client = ?', Date.current - 7.days, sku, cliente_id]).select("amount, used").last
		if aux != nil
			cant_disp = aux[:amount].to_i - aux[:used].to_i 
			if cant.to_i < cant_disp
			used_aux = cant.to_i + aux[:used].to_i
			Reservation.where(['date >= ? AND sku = ? AND client = ?', Date.current - 7.days, sku, cliente_id]).update_all(:used => used_aux)
			else
			Reservation.where(['date >= ? AND sku = ? AND client = ?', Date.current - 7.days, sku, cliente_id]).update_all(:used => aux[:amount])
			end
		else
			return 0
		end	
	end
end
