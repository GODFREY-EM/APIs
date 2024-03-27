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