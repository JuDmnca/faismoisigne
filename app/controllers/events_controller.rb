class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @categories = Event.categories
    @events = Event.all
    @events = @events.send(params[:category]) if params.has_key? :category
    @past_events = @events.past.pastorder
    @future_events = @events.future
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    user_signed_in? ? @event = Event.new
                    : redirect_to(new_user_session_path)
  end

  # GET /events/1/edit
  def edit
    redirect_to events_path if current_user != @event.user
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.user = current_user
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Votre événement a été créé avec succès.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    if current_user.id == @event.user_id
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Votre événement a été modifié avec succès.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Votre événement a été supprimé avec succès.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:nom, :start_at, :lieu, :description, :ville, :category)
    end
end
