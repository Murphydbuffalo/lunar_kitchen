class Recipe
	attr_reader :id, :name, :directions, :prep_time, :cook_time, :servings
	
	def initialize(args={})
      @id = args[:id]
      @name = args[:name]
      @directions = args[:directions] 
      @prep_time = args[:prep_time]  
      @cook_time = args[:cook_time] 
      @servings = args[:servings] 
      @category_id = args[:category_id]
	end

	def self.access_db
      begin
        connection = PG.connect(dbname: 'systems_check_recipes')
        yield(connection)
      ensure
      	connection.close
      end
	end

	def self.recipes_query
      query = "SELECT * FROM recipes"
	end

	def self.all
      recipes = []
      query_results = access_db {|conn| conn.exec(recipes_query)}
      query_results.each do |row|
        recipes << Recipe.new(:id => row["id"],
        	:name => row["name"], 
        	:directions => row["directions"], 
        	:servings => row["servings"], 
        	:prep_time => row["prep_time_in_minutes"],
        	:cook_time => row["cooking_time_in_minutes"])
      end
      recipes
	end


end
