# APIs
What you need to know about API and how to build one

What you need to know about Web Services and how to build one



An API, or an application programing interface, is a collection of code-based directives that facilitate communication and data exchange between different software modules. Web Services have a long history and now serve as fundamental components of contemporary applications. Whether you're making a purchase through an online store, requesting transportation from a ride-sharing platform, or placing an order from a restaurant delivery service, you're utilizing web services. Web service development is thus an essential skill for individuals entering the technology field.

Here, we'll guide you through the process of constructing a basic RESTful APIs, emphasizing both design and implementation.

STEPS TO BUILD THE API:

Step 1: Design the Web Service
The initial phase in crafting the API involves gaining a clear understanding of its intended functionality. Each API serves a distinct purpose, whether facilitating bi-directional video streaming or managing authentication procedures. Hence, it's imperative to delineate the API's use case and scope prior to selecting an architecture, protocol, and programming language.

Subsequently, one must delineate the essential resources, their required data formats and structures, interrelationships, and the permissible methods accessible through their respective endpoints. For more intricate APIs intended for production environments, factors such as authentication and encryption need to be addressed to uphold data integrity and security.

Creating a visual representation, such as a diagram, can aid in conceptualizing the API's resources and their relationships. For instance, envisioning a scenario where a pet daycare business aims to develop an API for tracking pets and their owners, a diagram could be constructed to illustrate these relationships effectively.


Step 2: Implement the Web Service
Executing the API entails utilizing diverse programming languages, architectures, and protocols. While REST remains widely adopted, alternatives such as Webhooks, GraphQL, SOAP, and gRPC also enjoy popularity. Furthermore, APIs can be implemented across various programming languages, including but not limited to Node.js, Python, Java, and Ruby. To illustrate, for the purpose of this demonstration, we'll employ Ruby on Rails to establish a straightforward REST API for the pet tracking application outlined earlier.

Why have we opted for Ruby on Rails?

Ruby on Rails, commonly referred to as "Rails," presents an advantageous framework for initiating API development, particularly for newcomers, as it abstracts numerous intricacies associated with typical API construction tasks, such as routing and database interaction. Its inclusion of a command line utility, rails generate (or rails g), facilitates the automatic generation of essential API components. Consequently, Rails stands as a suitable choice for developers across all skill levels and accommodates a broad spectrum of applications and API implementations.

Prior to delving into code composition, let's acquaint ourselves with several key Rails concepts:

- Models: Corresponding to database tables or collections, models enforce business rules, validate data, and execute database operations. Each resource within the API corresponds to a model.
- Migrations: Rails migrations offer a method for managing alterations to the database schema, enabling developers to modify tables, columns, and indexes sans direct SQL scripting.
- Controllers: Responsible for orchestrating data flow between clients and the database, controllers receive user input, interact with models for data retrieval or manipulation, and, in full-stack Rails applications, update views for result presentation. Notably, this tutorial focuses solely on API development, hence the view aspect is irrelevant.
- Routes: Rails routes establish mappings between URLs and actions within controllers. Upon receiving a request, the routing mechanism directs it to an appropriate controller action based on the URL path and HTTP method (e.g., GET, POST, PATCH, DELETE).

Creating an API

Having finalized the design phase as outlined earlier, it's now imperative to proceed with the implementation of your API. Prior to commencing, ensure that Ruby, Rails, and SQLite are installed on your local machine. For detailed guidance regarding these prerequisites, refer to the Rails documentation through this link *https://guides.rubyonrails.org/getting_started.html#creating-a-new-rails-project*. therefore 

Step 1: Create a new Rails application by using the rails new command from your command line:

rails new pet_tracker --api

note: minimal amount of middleware:
"Middleware" refers to extra tools or features that the program can use. By using the "--api" flag, you're telling the program to only use the most basic set of these tools.

Step 2: Navigate to the App's Folder: First, use the cd command (which stands for "change directory") to enter the directory named pet_tracker_app. Think of this directory as a folder containing all the building blocks for the pet tracker app To create the models, run the following commands:

rails g model Owner name:string email:string

rails g model Pet name:string species:string breed:string age:float owner_id:integer

Whenever you run those model creation commands, a special field called "id" gets automatically added to each model. Think of this "id" field as a unique label assigned to every pet and owner in your database.

Step 3: Create tables in the database for pets and owners by running a migration with the following command:

rails db:migrate

Step 4: Open and edit the routes.rb file to looks like 

Rails.application.routes.draw do
    get '/pets', to: 'pets#index'
    post '/pets', to: 'pets#create'
    get '/pets/:id', to: 'pets#show'
    patch '/pets/:id', to: 'pets#update'
    delete '/pets/:id', to: 'pets#destroy'
  
    get '/owners', to: 'owners#index'
    post '/owners', to: 'owners#create'
    get '/owners/:id', to: 'owners#show'
    get '/owners/:id/pets', to: 'owners#pets'
    patch '/owners/:id', to: 'owners#update'
    delete '/owners/:id', to: 'owners#destroy'
end

Code as a Traffic Director: The code you're looking at serves as a map for how different requests should be handled within the app. It's like a traffic director, guiding different actions to their appropriate destinations.


 Step 5: Generate the controllers for your Pet and Owner models by running the following commands:

rails generate controller Pets index create show update destroy --skip-routes

rails generate controller Owners index create show update destroy --skip-routes

These commands create controller files in the /app/controller folder. We’ve included the --skip-routes flag because we’ve created our routes manually.


Step 6: Filling in the Blanks - Writing the Controller Code

The previous step laid the groundwork by creating outlines for each controller action (like placeholders).  Now, it's your turn to write the actual code that brings these actions to life, so open the pets_controller.rb and edit it to looks like 

class PetsController < ApplicationController
  def index
    @pets = Pet.all
    render json: @pets
  end

  def create
    @pet = Pet.new(pet_params)
    
    if @pet.save
      render json: @pet, status: :created
    else
      render json: {error: 'Pet creation failed'}, status: :unprocessable_entity
    end
  end

  def show
    @pet = Pet.find(params[:id])

    if @pet
      render json: @pet, status: :ok
    else
      render json: { error: 'Pet not found' }, status: :not_found
    end
  end

  def update
    @pet = Pet.find(params[:id])

    if @pet.update(pet_params)
      render json: @pet, status: :ok
    else
      render json: { error: 'Pet update failed' }, status: :unprocessable_entity
    end
  end

  def destroy
    @pet = Pet.find(params[:id])

    if @pet.destroy
      render json: { message: 'Pet successfully deleted' }, status: :ok
    else
      render json: { error: 'Pet deletion failed' }, status: :internal_server_error
    end
  end

  private

  def pet_params
    params.permit(:name, :species, :breed, :age, :owner_id)
  end

end



therefore, Simple Words for Powerful Actions: The code uses methods like .all, .find, .new, and .destroy
. These methods might seem cryptic, but they represent common actions related to your data:

    .all - This retrieves all entries from the database for a specific model (like fetching a complete list of pets).
    .find - This targets a particular entry based on its unique identifier (like finding a specific pet using its ID).
    .new - This creates a new entry but doesn't save it yet (like creating a new pet record but not adding it to the database permanently).
    .destroy - This removes an existing entry from the database (like deleting a pet from the system).

The Owners controller will follow a similar pattern:

class OwnersController < ApplicationController
  def index
    @owners = Owner.all
    render json: @owners
  end

  def create
    @owner = Owner.new(owner_params)

    if @owner.save
      render json: @owner, status: :created
    else
      render json: {error: 'Owner creation failed'}, status: :unprocessable_entity
    end
  end

  def show
    @owner = owner.find(params[:id])

    if @owner
      render json: @owner, status: :ok
    else
      render json: { error: 'Owner not found' }, status: :not_found
    end
  end

  def pets
    @pets = Owner.find(params[:id]).pets

    if @pets
      render json: @pets
    else 
      render json: { error: 'Pets not found'}, status: :not_found
    end
  end

  def update
    @owner = Owner.find(params[:id])

    if @owner.update(owner_params)
      render json: @owner
    else
      render json: { error: 'Owner update failed' }, status: :unprocessable_entity
    end
  end

  def destroy
    @owner = Owner.find(params[:id])

    if @owner.destroy
      render json: { message: 'Owner successfully deleted' }, status: :ok
    else
      render json: { error: 'Owner deletion failed' }, status: :internal_server_error
    end
  end

  private

  def owner_params
    params.permit(:name, :email)
  end

end


As we mentioned earlier, the Owners controller has a custom pets action that uses the .find method to look up the specified owner and return all of their associated pets.


Step 7: It’s now time to start a server that will run your API locally! To do so, simply run:

rails server. Your API will now be running on http://localhost:3000/. Open the link through your browser 


Step 3: Putting Your API to the Test

Congratulations! You've built your API, but before unleashing it to the world, let's make sure it works as planned.  It's time for some testing!
