# frozen_string_literal: true

module Api
  module V1
    class PortsController < ApplicationController
      require 'csv'
      def index
        ports = Port.where(name: "#{params[:name]}").or(Port.where(code: "#{params[:code]}").or(Port.where(city: "#{params[:city]}").or(Port.where(oceaninsightscode: "#{params[:oceaninsightscode]}").or(Port.where(latitude:"#{params[:latitude]}").or(Port.where(longitude: "#{params[:longitude]}").or(Port.where(bigschedules: "#{params[:bigschedules]}").or(Port.where(createdat: "#{params[:createdat]}").or(Port.where(updatedat: "#{params[:updatedat]}").or(Port.where(porttype: "#{params[:porttype]}").or(Port.where(hubport: "#{params[:hubport]}").or(Port.where(oceaninsights: "#{params[:oceaninsights]}"))))))))))))
        if ports == []
          ports = Port.all
        end
        render json: { status: 'SUCCESS', message: 'Loaded Ports', data: ports }, status: :ok
     end

      def show
        ports = Port.find(params[:id])
        render json: { status: 'SUCCESS', message: 'Your result', data: ports }, status: :ok
      end

      def create
        file = ports_params[:port].tempfile.path
        CSV.foreach(file) do |row|
          id, name, code, city, ocean_insights_code, latitude, longitude, bigschedules, created_at, updated_at, port_type, hub_port, ocean_insights = row
          @ports = Port.create(name: name,
                               code: code,
                               city: city,
                               oceaninsightscode: ocean_insights_code,
                               latitude: latitude,
                               longitude: longitude,
                               bigschedules: bigschedules,
                               createdat: created_at,
                               updatedat: updated_at,
                               porttype: port_type,
                               hubport: hub_port,
                               oceaninsights: ocean_insights)
        end
        render json: { status: 'SUCCESS', message: 'Saved csv', data: @ports }, status: :ok
      end

      private

      def ports_params
        params.permit(:name,
                      :code,
                      :city,
                      :oceaninsightscode,
                      :latitude,
                      :longitude,
                      :bigschedules,
                      :createdat,
                      :updatedat,
                      :porttype,
                      :hubport,
                      :oceaninsights,
                      :port)
      end
    end
  end
end
