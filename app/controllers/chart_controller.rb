require 'rubygems'
require 'google_chart'

class ChartController < ApplicationController
  before_filter :authenticate_admin!
  def index
    GoogleChart::PieChart.new('320x200', "Things I Like To Eat", false) do |pc|
      pc.data "Broccoli", 30
      pc.data "Pizza", 20
      pc.data "PB&J", 40
      pc.data "Turnips", 10
      @pie_data = pc.to_url
      construct_barchart

    #puts pc.to_url
    end
  end

  private
  def construct_barchart
    bar_1_data = [3,1,7, 10, 5]
    #bar_2_data = [200,800,50]
    color_1 = 'c53711'
    color_2 = '0000ff'
    names_array = ["November 1, 1 - 2pm","November 1, 3 - 4pm","November 2, 1 - 2pm", "November 4, 1 - 2pm", "November 4, 4 - 5pm"]
    GoogleChart::BarChart.new("700x300", "", :horizontal, false) do |bc|
      bc.data "FirstResultBar", bar_1_data, color_1
      #bc.data "SecondResultBar", bar_2_data, color_2
      bc.axis :y, :labels => names_array, :font_size => 15
      bc.axis :x, :range => [0,50]
      bc.show_legend = false
      #bc.stacked = true
      bc.data_encoding = :extended
      bc.shape_marker :circle, :color => '0000ff', :data_set_index => 0, :data_point_index => -1, :pixel_size => 10
      @bar_chart = bc.to_url
    end
    
  end
end
