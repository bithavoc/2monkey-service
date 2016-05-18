class VaultsController < AuthenticatedServiceController
  #skip_before_filter :validate_auth, :only => [:check]
  # before_action :set_vault, only: [:show, :edit, :update, :destroy]

  # GET /vaults/{vault_name}
  def show
    vault_check unless @current_vault

    unless @current_vault
      return render status: :not_found, json: {vault: simple_error("Not found")}
    end

    render status: :ok, json: @current_vault
  end

  # POST /vaults
  # POST /vaults.json
  def create
    @current_vault = Vault.new(vault_params)

    respond_to do |format|
      if @current_vault.save
        format.html { redirect_to @current_vault, notice: 'Vault was successfully created.' }
        format.json { render :show, status: :created, location: @current_vault }
      else
        format.html { render :new }
        format.json { render json: @current_vault.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vaults/1
  # PATCH/PUT /vaults/1.json
  def update
    respond_to do |format|
      if @current_vault.update(vault_params)
        format.html { redirect_to @current_vault, notice: 'Vault was successfully updated.' }
        format.json { render :show, status: :ok, location: @current_vault }
      else
        format.html { render :edit }
        format.json { render json: @current_vault.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vaults/1
  # DELETE /vaults/1.json
  def destroy
    @current_vault.destroy
    respond_to do |format|
      format.html { redirect_to vaults_url, notice: 'Vault was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  # def set_vault
  #   if params[]
  #   end
  #   @current_vault = Vault.where(name: params[:id]).first
  # end

  # Never trust parameters from the scary internet, only allow the white list through.
  def vault_params
    params.require(:vault).permit(:name, :password)
  end

  def vault_by_name
    @current_vault = Vault.where(name: params[:id]).first
  end

  def vault_check
    @current_vault = vault_by_name unless password_request
  end
end
