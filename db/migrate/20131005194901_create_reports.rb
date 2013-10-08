class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
			t.string :title #Report flag (e.g. not_song, copyrighted, etc.)
			t.string :content #Report comments
			t.references :user #User.id who reported
			t.string :reportable_type #ArtistUpload for now
			t.string :reportable_id #ArtistUpload.song_id for now
      t.timestamps
    end
  end
end
