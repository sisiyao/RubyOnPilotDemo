CREATE TABLE tracks (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  track_num INTEGER,
  album_id INTEGER,

  FOREIGN KEY(album_id) REFERENCES album(id)
);

CREATE TABLE albums (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  image_url VARCHAR(255) NOT NULL,
  artist_id INTEGER,

  FOREIGN KEY(artist_id) REFERENCES artist(id)
);

CREATE TABLE artists (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  image_url VARCHAR(255) NOT NULL
);

INSERT INTO
  artists (id, name, image_url)
VALUES
  (1, "Frank Ocean", "http://imd.ulximg.com/image/300x300/artist/1392853723_dd7bf404602d4647b315404d9a76a123.jpg/d6a6a346065c968a46c283c8add1f979/1392853723_frank_ocean_86.jpg"),
  (2, "Alicia Keys", "http://www.earnthenecklace.com/wp-content/uploads/2016/05/Alicia-Keys-New-Song-300x300.jpg"),
  (3, "Beyonce", "http://mechanicaldummy.com/wp/wp-content/uploads/2013/04/beyonce-hm-0-300x300.jpg"),
  (4, "Adele", "https://a2-images.myspacecdn.com/images04/2/82ec0d12409546c1844f01600546354c/300x300.jpg"),
  (5, "Pharrell", "http://love.mymuti.com/wp-content/uploads/2014/05/pharrell-williams-300x300.png");

INSERT INTO
  albums (id, name, image_url, artist_id)
VALUES
  (1, "Channel Orange", "https://upload.wikimedia.org/wikipedia/en/thumb/2/28/Channel_ORANGE.jpg/220px-Channel_ORANGE.jpg",1),
  (2, "Blonde", "https://upload.wikimedia.org/wikipedia/en/thumb/a/a0/Blonde_-_Frank_Ocean.jpeg/220px-Blonde_-_Frank_Ocean.jpeg",1),
  (3, "The Element of Freedom", "https://upload.wikimedia.org/wikipedia/en/thumb/c/c8/Alicia_Keys_The_Element_of_Freedom.jpg/220px-Alicia_Keys_The_Element_of_Freedom.jpg", 2),
  (4, "Songs in A Minor", "https://upload.wikimedia.org/wikipedia/en/thumb/8/83/AliciaKeys-SongsInAMinor-music-album.jpg/220px-AliciaKeys-SongsInAMinor-music-album.jpg", 2),
  (5, "Lemonade", "https://upload.wikimedia.org/wikipedia/en/thumb/5/53/Beyonce_-_Lemonade_%28Official_Album_Cover%29.png/220px-Beyonce_-_Lemonade_%28Official_Album_Cover%29.png", 3),
  (6, "Beyonce", "https://upload.wikimedia.org/wikipedia/commons/thumb/2/21/Beyonc%C3%A9_-_Beyonc%C3%A9.svg/220px-Beyonc%C3%A9_-_Beyonc%C3%A9.svg.png",3);

INSERT INTO
  tracks (id, title, track_num, album_id)
VALUES
  (1, "Start", 1, 1),
  (2, "Thinkin Bout You", 2, 1),
  (3, "Fertilizer", 3, 1),
  (4, "Nikes", 1, 2),
  (5, "Ivy", 2, 2),
  (6, "Pink + White", 3, 2),
  (7, "The Element of Freedom", 1, 3),
  (8, "Love is Blind", 2, 3),
  (9, "Doesn't Mean Anything", 3, 3),
  (10, "Piano & I", 1, 4),
  (11, "Girlfriend", 2, 4),
  (12, "How Come You Don't Call Me", 3, 4),
  (13, "Pray You Catch Me", 1, 5),
  (14, "Hold Up", 2, 5),
  (15, "Don't Hurt Yourself", 3, 5),
  (16, "Pretty Hurts", 1, 6),
  (17, "Haunted", 2, 6),
  (18, "Drunk in Love", 3, 6);
