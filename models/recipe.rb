class Recipe
	attr_reader :id, :name, :instructions, :description
	
	def initialize(args={})
    @id = args[:id]
    @name = args[:name]
    @instructions = args[:instructions] || "This recipe doesn't have any instructions."
    @description = args[:description] || "This recipe doesn't have a description."
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
      	:instructions => row["instructions"], 
      	:description => row["description"])
    end
    recipes
	end

	def self.find(id)
    Recipe.all.each do |recipe|
      return recipe if id == recipe.id
    end
	end

  def ingredients
    ingredients = []
    Ingredient.all.each do |ingredient|
      if ingredient.recipe_id == self.id
        ingredients << ingredient
      end
    end
      ingredients
  end
end
