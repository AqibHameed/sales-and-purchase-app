namespace :update_existing_notes do
  desc "Updare existing notes to update stone_id and deec_no"
  task :update_notes => :environment do
		Note.where("stone_id is NULL").find_in_batches(batch_size: 100) do |notes|
			notes.each do |note|
			  unless note.key.blank?
			    puts note.key
			    description = note.key.split("#").first
			    carat = note.key.split("#").last
			   	stone = Stone.where("carat = ? and description like ?", carat, description).try(:first)
			   	if stone
			   		note.update_attributes(:stone_id => stone.try(:id), :deec_no => stone.try(:deec_no))
			   	end	   	
			  end
			end
		end
  end
end

