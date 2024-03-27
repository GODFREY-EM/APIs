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
