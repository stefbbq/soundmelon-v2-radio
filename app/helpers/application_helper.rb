module ApplicationHelper

	def yt_auth_ids
		# Return a hash that initializes youtube authentication relevant parameters 
		ids = {client_id: ENV["YOUTUBE_APP_ID"],
					 client_secret: ENV["YOUTUBE_SECRET"],
					 redirect_uri: ENV["HOST_ADDR"] + '/yt_oauth_callback',
					 yt_scope: 'https://gdata.youtube.com',
					 dev_key: ENV["YOUTUBE_DEV_KEY"]
					}
		return ids
	end

	def sc_auth_ids
		ids = {client_id: ENV["SOUNDCLOUD_APP_ID"],
					 client_secret: ENV["SOUNDCLOUD_SECRET"],
					 redirect_uri: ENV["HOST_ADDR"] + '/sc_oauth_callback'}
	end

	def yt_oauth_setup
		# Return a Faraday object for Google-Youtube
		conn = Faraday.new(:url => 'https://accounts.google.com',:ssl => {:verify => false}) do |faraday|
		 faraday.request  :url_encoded
		 faraday.response :logger
		 faraday.adapter  Faraday.default_adapter
		end
		return conn
	end

	def obtain_yt_token(conn, client_token, ids)
		# Return Faraday attribute containing the youtube authentication token
		result = conn.post '/o/oauth2/token', {code: client_token,
																					client_id: ids[:client_id],
																					 client_secret: ids[:client_secret],
																					 redirect_uri: ids[:redirect_uri],
																					 grant_type: 'authorization_code'}
		
		return result
	end

	def new_yt_client(yt_ids, yt_tokens)
		# Initialize and return a new youtube_it client
		client = YouTubeIt::OAuth2Client.new(client_access_token: yt_tokens[:access_token],
																					client_refresh_token: yt_tokens[:refresh_token],
																					client_id: yt_ids[:client_id],
																					client_secret: yt_ids[:client_secret],
																					dev_key: yt_ids[:dev_key],
																					client_token_expires_at: yt_tokens[:expires_at])
		return client
	end

	def refresh_yt_client(yt_client)
		yt_tokens = current_artist.youtube_token
		yt_client.refresh_access_token!
		yt_tokens[:access_token] = yt_client.access_token.token
		yt_tokens[:expires_at] = yt_client.access_token.expires_at
		current_artist.update_attributes(youtube_token: yt_tokens)
		return yt_client
	end

	def refresh_sc_client(artist)
		sc_ids = sc_auth_ids
		sc_tokens = artist.soundcloud_token
		sc_client = Soundcloud.new(client_id: sc_ids[:client_id], client_secret: sc_ids[:client_secret], refresh_token: sc_tokens[:refresh_token])
		artist.update_attributes(soundcloud_token: sc_client.options.except(:on_exchange_token))
		artist.save
		return sc_client
	end

	def echonest_init
		wrap = Echonest
		wrap.configure do |config|
				config.api_key = ENV['ECHONEST_API_KEY']
				config.consumer_key = ENV['ECHONEST_CONSUMER_KEY']
				config.shared_secret = ENV['ECHONEST_SHARED_SECRET']
		end
		return wrap
	end

	def update_count_hash(my_hash, key)
		if my_hash.has_key?(key)
			my_hash[key] += 1
		else
			my_hash[key] = 1
		end
		return my_hash
	end

	def user_scored_songs(user, songs)
		#Return an array of arrays of song,score pairs
		#sorted by descending match given a User and an
		#array of active Song songs 
		songs = songs.shuffle
		scored_songs = []
		k = 0
		user_meta = user.user_meta
		fb_meta = user.fb_meta
		songs.each do |song|
			all_tags = song.sm_tags | song.source_tags
			scored_songs << [song, score_song(user_meta, fb_meta, all_tags)]
		end
		scored_songs = scored_songs.sort_by {|song,score| score}
		return scored_songs
	end

	def random_playlist(songs, n)
		#Return an array of n (int) random Song songs
		return songs.shuffle[0..(n-1)]
	end

	def score_song(user_meta, fb_meta, song_tags, alpha=0.5)
		#Return a song score given a hash of user meta data
		#and an array of tags for the song
		fbm_score = fb_meta.nil? ? 1 : get_fbm_score(fb_meta, song_tags)
		um_score = user_meta.nil? ? 1 : get_um_score(user_meta, song_tags)
		agg_score = alpha*fbm_score + (1-alpha)*um_score
	end

	def get_fbm_score(fb_meta, song_tags)
		score = 0.0
		song_tags.each do |tag|
			score += fb_meta[tag] if !fb_meta.keys.index(tag).nil? 
		end
		return score/fb_meta.values.sum
	end

	def get_um_score(user_meta, song_tags)
		score = 0.0
		song_tags.each do |tag|
			score += 1 if !user_meta.index(tag).nil?
		end
		return score/user_meta.size
	end

	def update_song_history(user, played_songs)
		#Update user song_history hash with played_songs list
		if user.song_history.nil?
			user.song_history = {}
		end
		history = user.song_history
		if !played_songs.nil?
			played_songs.keys.each do |song|
				song_id = played_songs[song]['song_id']
				if history.has_key?(song_id)
					history[song_id]['plays'] += 1
				else
					history[song_id] = {}
					history[song_id]['plays'] = 1
				end
				history[song_id]['last_played'] = Time.now.to_i
			end
		end
		user.song_history = history
		user.save
	end

	def filter_by_history(user, songs, history, n, station)
		#Return an array of Song songs given an array of 
		#Song and user song history history
		black_list = []
		history.keys.each do |song_id|
			last_played = history[song_id]['last_played']
			if Time.now.to_i - last_played < 3600
				black_list << songs.select {|song| song.song_id == song_id}[0]
			end
		end
		white_list = songs - black_list
		if station == 'user-meta'
			scored_songs = user_scored_songs(user, white_list)
			filtered_songs = random_weighted_sample_no_replacement(scored_songs, [n,white_list.size].min)
			filtered_songs = filtered_songs.map {|song,weight| song}
		elsif station == 'random'
			filtered_songs = random_playlist(white_list, n)
		end
		return filtered_songs
	end

	def validate_email(email)
		email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]{2,4}+\z/i
		return !email.match(email_regex).nil?
	end

	def get_artist_tags(artist_id)
		#Return an array of arrays [genre,frequency] sorted by desc frequency
		@artist = Artist.find(artist_id)
		@songs = @artist.song
		@genre_tags = {}
		@songs.each do |song|
			all_tags = song.sm_tags | song.source_tags
			all_tags.each do |tag|
				if @genre_tags[tag].nil?
					@genre_tags[tag] = 1
				else
					@genre_tags[tag] += 1
				end
			end
		end
		return @genre_tags.sort_by {|k,v| v}.reverse
	end

end
