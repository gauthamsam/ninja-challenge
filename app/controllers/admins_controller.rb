require 'rubygems'
require 'google_chart'

class AdminsController < ApplicationController
  before_filter :authenticate_admin!
  # GET /admins
  # GET /admins.json
  def index
    respond_to do |format|
      format.html # index.html.erb      
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
      @tests = Test.where(:admin_id => current_admin.id)
      flash[:notice] = 'Test was successfully created.'
      Test.expire_test_cache(current_admin.id)
    else
      flash[:error] = 'Test could not be created.'
    end

    redirect_to :action => 'view_tests'

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

    #questions_array = TestQuestion.where(:test_id => test_id)
    questions_array = TestQuestion.all_cached(test_id)
    @questions = Kaminari.paginate_array(questions_array).page(params[:page])

    @test = Test.find(test_id)
    @partials = 'admins/tests/view_questions'

    respond_to do |format|
      format.html { render :template => 'admins/index' }
      format.json { head :no_content }
    end
  end

  def save_question
    @question = TestQuestion.new(params[:test_question])
    @partials = 'admins/tests/view'

    if @question.save
      flash[:notice] = 'Question was successfully saved.'
      TestQuestion.expire_test_question_cache(@question.test_id)
    else
      flash[:error] = 'Question could not be saved.'
    end

    respond_to do |format|
      format.html { redirect_to '/admins/view_tests' }
      format.json { head :no_content }
    end
  end

  def view_tests
    #@tests = Test.where(:admin_id => current_admin.id)
    @tests = Test.all_cached(current_admin.id)
    #@tests = Kaminari.paginate_array(tests_array).page(params[:page])
    @partials = 'admins/tests/view'

    respond_to do |format|
      format.html { render :template => 'admins/index' }
      format.json { head :no_content }
    end
  end

  #
  # view_reports method display all the tests and their respective links for tests reports
  #

  def view_reports
    @tests = Test.all_cached(current_admin.id)
    #@tests = Kaminari.paginate_array(test_array).page(params[:page])
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

  #
  # view_report method displays report of a specific test
  #
  # 1. mysql> select student_score,count(*) from student_tests group by student_score;
  # 2.
  # 3
  #select * from student_tests;
  #+----+------------+---------+---------------+-----------+---------------------+---------------------+
  #| id | student_id | test_id | student_score | submitted | created_at          | updated_at          |
  #+----+------------+---------+---------------+-----------+---------------------+---------------------+
  #|  1 |          2 |       1 |             3 |         1 | 2012-11-12 22:08:58 | 2012-11-12 22:08:58 |
  #|  2 |          3 |       1 |             0 |         1 | 2012-11-12 22:11:17 | 2012-11-12 22:11:17 |
  #|  3 |          4 |       1 |             3 |         1 | 2012-11-12 22:16:14 | 2012-11-12 22:16:14 |
  #+----+------------+---------+---------------+-----------+---------------------+---------------------+

  def view_report
    test_id = params[:test_id]
    @test = Test.find(test_id)
    @student_test_table = StudentTest.where(:test_id => test_id).select('student_id, student_score')
    i = 0
    bar_1_data = []
    names_array = []
    stud_max = []
    max_in_a_score = 0
    while i <= @test.max_score do
      bar_1_data.append(0)
      names_array.append(i.to_s)
      i = i + 1
    end

    i = 1
    
    first_level = 0
    second_level = 0
    third_level = 0
    fourth_level = 0

    percentage_score = []
    
    @student_test_table.each do |x|
      marks = x.student_score.to_i
      if marks < (0.3 * @test.max_score)
        first_level += 1

      elsif (marks > (0.3 * @test.max_score)) && (marks < (0.5 * @test.max_score))
        second_level += 1

      elsif (marks > (0.5 * @test.max_score)) && (marks < (0.8 * @test.max_score))
        third_level += 1
      else
        fourth_level += 1

      end
      
      bar_1_data[x.student_score.to_i] += 1
      if bar_1_data[x.student_score.to_i] > max_in_a_score
      max_in_a_score =  bar_1_data[x.student_score.to_i]
      end
      i = i + 1
      
    end
    
    perentage_score.append(first_level)
    perentage_score.append(first_level + second_level)
    perentage_score.append(first_level + second_level + third_level)
    perentage_score.append(first_level + second_level + third_level + fourth_level)

    puts "first_level " + first_level.to_s
    i = 0;
    while i <= max_in_a_score do
      stud_max.append(i)
      i = i + 1
    end

    
    total_students = first_level + second_level + third_level + fourth_level
    
    
    color_1 = 'd53711'
    color_2 = '0000ff'

    GoogleChart::BarChart.new("800x300", "Students' Performance", :vertical, false) do |bc|
      bc.data "No. Students", bar_1_data, color_1
      #bc.data "SecondResultBar", bar_2_data, color_2
      bc.axis :y, :labels => stud_max
      bc.axis :x, :range => names_array
      bc.show_legend = true
      #bc.stacked = true
      bc.data_encoding = :extended
      bc.shape_marker :circle, :data_set_index => 0, :data_point_index => -1, :pixel_size => 10
      @bar_chart = bc.to_url
    end
    
    
    GoogleChart::PieChart.new('320x200', "Marks Distribution", false) do |pc|
      pc.data "< 30%", 25#(first_level / total_students * 100)
      pc.data "30 - 50%", 32#(second_level / total_students * 100)
      pc.data "51 - 80%", 40#(third_level / total_students * 100)
      pc.data "> 80%", 3#(fourth_level / total_students * 100)
      @pie_chart = pc.to_url
    end

    
    lc = GoogleChart::LineChart.new("400x200", "Cumulative Graph", false)
    lc.data "Student percentage", [1, 5, 7, 10, 12, 15, 20], '00ff00'
    lc.axis :y, :range => [0, @test.max_score], :font_size => 10, :alignment => :center
    lc.axis :x, :range => [2, 3, 10, 25, 30, 45, 100], :font_size => 10
    lc.show_legend = true
    lc.shape_marker :circle, :color => '0000ff', :data_set_index => 0, :data_point_index => -1, :pixel_size => 10
    @line_chart = lc.to_url

    @partials = 'admins/tests/view_report'
    respond_to do |format|
      format.html { render :template => 'admins/index' }
      format.pdf do
        pdf = ReportsPdf.new(@test, [@bar_chart, @pie_chart])
        send_data pdf.render
      end
      format.json { head :no_content }
    end

  end

end
