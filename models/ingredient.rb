class Ingredient
    attr_reader :name, :recipe_id

	def initialize(args={})
      @id = args[:id]
      @name = args[:name]
      @recipe_id = args[:recipe_id]
	end

	def self.access_db
      begin
        connection = PG.connect(dbname: 'systems_check_recipes')
        yield(connection)
      ensure
      	connection.close
      end
	end

	def self.ingredients_query
      query = "SELECT * FROM ingredients"
	end

	def self.all
      ingredients = []
      query_results = access_db {|conn| conn.exec(ingredients_query)}
      query_results.each do |row|
        ingredients << Ingredient.new(:id => row["id"],
        	:name => row["name"],
        	:recipe_id => row["recipe_id"]) 
      end
      ingredients
	end

end
