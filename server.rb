# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'sinatra'
require 'interface'
require 'usecase'
require 'domain'

get '/' do
  erb :index, locals: {result: nil, error: nil}
end

post '/' do
  return erb :index, locals: {result: nil, error: 'Data file is missed'}, status: 400 unless params[:file]

  file = params[:file][:tempfile]

  events = file.lines.map { |str| Interface.build_event_dto(str) }
  service = Usecase::ScoreCalculator.new

  customers = service.process(events)

  result = Interface.customers_scores_representation(customers)

  erb :index, locals: {result: result, error: nil}
rescue Domain::InvalidDataError => e
  erb :index, locals: {result: nil, error: e.message}, status: 400
end
