require 'sqlite3'

class Song
  attr_accessor :id, :name, :album

  def initialize(attributes)
    @id = attributes[:id]
    @name = attributes[:name]
    @album = attributes[:album]
  end

  def self.create_table
    DB.execute <<-SQL
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
      )
    SQL
  end

  def save
    if self.id
      self.update
    else
      DB.execute("INSERT INTO songs (name, album) VALUES (?, ?)", self.name, self.album)
      @id = DB.last_insert_row_id
    end
    self
  end

  def update
    DB.execute("UPDATE songs SET name = ?, album = ? WHERE id = ?", self.name, self.album, self.id)
  end

  def self.create(attributes)
    song = Song.new(attributes)
    song.save
    song
  end

  def self.new_from_db(row)
    Song.new(id: row[0], name: row[1], album: row[2])
  end

  def self.all
    DB.execute("SELECT * FROM songs").map do |row|
      Song.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    row = DB.execute("SELECT * FROM songs WHERE name = ?", name).first
    Song.new_from_db(row) if row
  end
end

# set up the database connection
DB = SQLite3::Database.new(":memory:")

# run the tests
RSpec.describe Song do
  # ...
end
