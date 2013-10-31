class SongsController < ApplicationController
	respond_to :js, :json, :html, :xml
	include ApplicationHelper

	def new
	end

	def create
		params[:song][:source_tags] = params[:song][:source_tags].split(',')
		params[:song][:sm_tags] = params[:song][:sm_tags].split(',')
		@items = params
		@song = Song.create(params[:song].except(:artist_id))
		if @song.save
			@song.update_column(:artist_id, params[:song][:artist_id])
			flash[:upload_created] = true
		end
	end

	def edit
	end

	def update
		@song = Song.find(params[:id])
		params[:song][:source_tags] = params[:song][:source_tags].split(',')
		params[:song][:sm_tags] = params[:song][:sm_tags].split(',')
		@song.update_attributes(params[:song])
		flash[:upload_updated] = true
	end

	def make_public
		@song_id = params[:song_id]
		@upload_source = params[:upload_source]
		@artist = Artist.find_by_id(params[:artist_id])
		if @upload_source == 'youtube'
			@client = new_yt_client(yt_auth_ids, @artist.youtube_token)
			@song = @client.my_video(@song_id)
			@client.video_update(@song_id, :title => @song.title, :description => @song.description, :category => @song.categories.first.term, :keywords => @song.keywords, :private => false)
		elsif @upload_source == 'soundcloud'
			@client = refresh_sc_client(@artist)
			@song = @client.get('/tracks/' + @song_id)
			@client.put(@song.uri, :track => {:sharing => 'public'})
		end
	end

	def request_playlist
		@items = params
		@user = User.find_by_id(params[:user_id])
		@station = params[:station]
		if (@user.fb_meta.keys.size == 0 && @user.user_meta.size == 0)
			@station == 'random'
		end
		update_song_history(@user, params[:played_songs])
		@history = @user.song_history
		@active_songs = Song.where(active: true)
		@playlist_size = 3
		@active_songs = filter_by_history(@user, @active_songs, @history, @playlist_size, @station)

		@active_ids = []
		@active_songs.each do |song|
			artist = Artist.find_by_id(song.artist_id)
			all_tags = song.sm_tags | song.source_tags
			@active_ids << {song_id: song.song_id, upload_source: song.upload_source, keywords: all_tags, song_url: song.song_url, artist_attrs: {artist_name: artist.artist_name, genre_tags: artist.genre_tags, website: artist.website, biography: artist.biography}, photo: artist.artist_photo.url(:thumb)}
		end

		respond_to do |format|
			format.json {render json: @active_ids}
			format.js
		end
	end

	def get_source_tags
		@song_id = params[:song_id]
		@source = params[:source]
		@artist = Artist.find(params[:artist_id])
		if @source == 'youtube'
			@client = new_yt_client(yt_auth_ids, @artist.youtube_token)
			if @artist.youtube_token[:expires_at] < Time.now.to_i
				@client = refresh_yt_client(@client)
			end
			@source_tags = @client.my_video(@song_id).keywords
		elsif @source == 'soundcloud'
			@client = refresh_sc_client(@artist)
			@track = @client.get('/tracks/' + @song_id)
			@source_tags = @track.genre.split() | @track.tag_list.split(' ')
			@source_tags.delete_if {|tag| tag.include? "soundcloud:source"}
		end
		@source_tags = @source_tags.nil? ? [] : @source_tags
	end

end