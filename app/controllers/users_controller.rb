class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def find_user
    name = params[:name]
    response = RestClient.get('https://api.github.com/search/users?q='+name, headers={})
    objArray = JSON.parse(response.body)
    if objArray["total_count"] != 0
      @user = User.find_by(name: name)
      if @user
        @user.search_count += 1
        @user.save
        flash[:notice] = 'Kullanıcı var.'
        redirect_to users_path
      else
        @user = User.create(name: name, search_count: 1)
        flash[:notice] = 'Yeni arama sonucu sisteme eklendi.'
        redirect_to users_path
      end
    else
      flash[:notice] = 'Böyle bir kullanıcı yok'
      redirect_to users_path
    end
  end

  def all_users
    @users = User.all
  end

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :search_count)
    end
end
