 class JayneController < ApplicationController
   def uptime
     render json: MemeCommands.new(channel: params["channel"]).akm_blade_uptime, status: 200
   end
 end
