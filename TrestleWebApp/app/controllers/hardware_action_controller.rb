class HardwareActionController < ApplicationController
  def getPending
	@station = Station.find_by_identifier(params[:station_identifier])
		if !@station.nil?
			@action = @station.hardware_action.find_by_pending(true, :limit=>1)
			if !@action.nil?
				@action.pending = false
				@action.save
				render :json => { :response => 'ok', :action => @action.hardware_id}
			else
				render :json => { :response => 'ok', :action => "-1"}
			end
		else
			render :json => {:response => 'fail', :message => 'Couldn\'t find Station'}
		end
  end

  #/hardware_action/performAction.json {station_identifier: STATION1, identifier: ACTION1}
  def performAction
  	@station = Station.find_by_identifier(params[:station_identifier])
  	if !@station.nil?
  		@action = @station.hardware_action.find_by_identifier(params[:identifier], :limit => 1)
  		if !@action.nil?
  			@action.pending = true
  			if @action.save
  				render :json => { :response => 'ok', :action => @action}
  			else
  				render :json => {:response => 'fail', :message => 'Couldn\'t save Action'}
  			end
  		else
			render :json => {:response => 'fail', :message => 'Couldn\'t save Action'}
		end
  	else
		render :json => {:response => 'fail', :message => 'Couldn\'t find Station'}
  	end
  			

  end


  def forcePending
  	@hardware_action = HardwareAction.find(params[:hardware_action])
  	puts @hardware_action.pending
  	@hardware_action.pending = true;
  	if(@hardware_action.save)
  		puts @hardware_action.pending
  		redirect_to @hardware_action.station
  	else
  		log.debug("ERROR")

  	end
  end


  def add
  	@station = Station.find_by_identifier(params[:station_identifier])
		if !@station.nil?
			@action = @station.hardware_action.find_by_identifier(params[:identifier])
			if @action.nil?
				#handle the case where this already exists gracefully?
				@action = @station.hardware_action.create
			end
			@action.name = params[:name]
			@action.description = params[:description]
			@action.identifier = params[:identifier]
			@action.hardware_id = params[:hardware_id]
			@action.pending = false
			if @action.save
				render :json => { :response => 'ok', :status => :ok}
			else
				render :json => { :response => 'fail', :message => 'Couldn\'t create Action'}
			end
		else
			render :json => {:response => 'fail', :message => 'Couldn\'t find Station'}
		end
  end
end
