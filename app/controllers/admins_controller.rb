require 'rubygems'
require 'google_chart'

class AdminsController < ApplicationController
  before_filter :authenticate_admin!
  # GET /admins
  # GET /admins.json
  def index
    @admins = Admin.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @admins }
    end
  end

  # GET /admins/1
  # GET /admins/1.json
  def show
    @admin = Admin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @admin }
    end
  end

  # GET /admins/new
  # GET /admins/new.json
  def new
    @admin = Admin.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @admin }
    end
  end

  # GET /admins/1/edit
  def edit
    @admin = Admin.find(params[:id])
  end

  # POST /admins
  # POST /admins.json
  def create
    @admin = Admin.new(params[:admin])

    respond_to do |format|
      if @admin.save
        format.html { redirect_to @admin, :notice => 'Admin was successfully created.' }
        format.json { render :json => @admin, :status => :created, :location => @admin }
      else
        format.html { render :action => "new" }
        format.json { render :json => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admins/1
  # PUT /admins/1.json
  def update
    @admin = Admin.find(params[:id])

    respond_to do |format|
      if @admin.update_attributes(params[:admin])
        format.html { redirect_to @admin, :notice => 'Admin was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/1
  # DELETE /admins/1.json
  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy

    respond_to do |format|
      format.html { redirect_to admins_url }
      format.json { head :no_content }
    end
  end

  def create_test
    @test = Test.new
    @levels = Level.all
    @partials = 'admins/tests/new'

    respond_to do |format|
      format.html { render :template => 'admins/index' }
      format.json { head :no_content }
    end

  end

  def add_test
    @test = Test.new(params[:test])
    @partials = 'admins/tests/view'

    @test.admin_id = current_admin.id

    if @test.save
      @tests = Test.all
      flash[:notice] = 'Test was successfully created.'
    else
      flash[:error] = 'Test could not be created.'
    end

    respond_to do |format|
      format.html { render :template => 'admins/index' }
      format.json { head :no_content }
    end
  end

  def show_question
    test_id = params[:test_id]
    @question = TestQuestion.new(:test_id => test_id)
    
    @partials = 'admins/tests/questions'

    respond_to do |format|
      format.html { render :template => 'admins/index' }
      format.json { head :no_content }
    end
  end
  
  def view_all_questions
    test_id = params[:test_id]
    @questions = TestQuestion.where(:test_id => test_id)
    
    @test = Test.find(test_id)
    @partials = 'admins/tests/view_questions'

    respond_to do |format|
      format.html { render :template => 'admins/index' }
      format.json { head :no_content }
    end
  end

  def save_question
    @question = TestQuestion.new(params[:test_question])
    # correct_choice starts with 0
    @question.correct_choice = @question.correct_choice
    puts "***@question.correct_choice*** " + @question.correct_choice.to_s
    
    @partials = 'admins/tests/view'
    
    if @question.save      
      flash[:notice] = 'Question was successfully saved.'
    else
      flash[:error] = 'Question could not be saved.'
    end

    @tests = Test.all
    respond_to do |format|
      format.html { render :template => 'admins/index' }
      format.json { head :no_content }
    end
  end

  def view_tests
    @tests = Test.all
    @partials = 'admins/tests/view'
    respond_to do |format|
      format.html { render :template => 'admins/index' }
      format.json { head :no_content }
    end
  end

  def view_reports
    @tests = Test.all
    @partials = 'admins/tests/view_reports'
    respond_to do |format|
      format.html { render :template => 'admins/index' }
      format.json { head :no_content }
    end
  end

  def view_survey
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
    @partials = 'admins/charts/view'
    respond_to do |format|
      format.html { render :template => 'admins/index' }
      format.json { head :no_content }
    end
  end

end
