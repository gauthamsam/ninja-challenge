class StudentsController < ApplicationController
  before_filter :authenticate_student!
  # GET /students
  # GET /students.json
  def index
    @students = Student.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @students }
    end
  end

  # GET /students/1
  # GET /students/1.json
  def show
    @student = Student.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @student }
    end
  end

  # GET /students/new
  # GET /students/new.json
  def new
    @student = Student.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @student }
    end
  end

  # GET /students/1/edit
  def edit
    @student = Student.find(params[:id])
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(params[:student])

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, :notice => 'Student was successfully created.' }
        format.json { render :json => @student, :status => :created, :location => @student }
      else
        format.html { render :action => "new" }
        format.json { render :json => @student.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /students/1
  # PUT /students/1.json
  def update
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:student])
        format.html { redirect_to @student, :notice => 'Student was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @student.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student = Student.find(params[:id])
    @student.destroy

    respond_to do |format|
      format.html { redirect_to students_url }
      format.json { head :no_content }
    end
  end

  # Get all the tests that this student can take
  def view_tests
    @tests = Test.where(:level_id => current_student.level_id)
    #@tests = Kaminari.paginate_array(tests_array).page(params[:page])
    @partials = 'students/tests/view'
    respond_to do |format|
      format.html { render :template => 'students/index' }
      format.json { head :no_content }
    end
  end

  def take_test
    test_id = params[:test_id]
    @test = Test.find(test_id)
    @student_test = StudentTest.where(:student_id => current_student.id, :test_id => test_id.to_i, :submitted => true)

    # If the student has already submitted the test, he should go to the reports page.
    if @student_test.exists?
      redirect_to '/students/view_report?test_id=' + test_id
      return
    end
    template_file = 'students/tests/take_test'
    questions_array = TestQuestion.where(:test_id => test_id)
    @questions = Kaminari.paginate_array(questions_array).page(params[:page])

    respond_to do |format|
      format.html { render :template => template_file }
      format.json { head :no_content }
    end

  end

  def view_report
    test_id = params[:test_id]
    @test = Test.find(test_id)
    @questions = TestQuestion.where(:test_id => test_id)
    @student_test = StudentTest.where(:test_id => test_id, :student_id => current_student.id)

    @student_test_question = StudentTestQuestion.where(:test_id => test_id, :student_id => current_student.id)
    template_file = 'students/tests/view_report'
    respond_to do |format|
      format.html { render :template => template_file }
      format.json { head :no_content }
    end
  end

  def submit_test
    test_id = params[:test_id]
    @test = Test.find(test_id)

    @questions = TestQuestion.where(:test_id => test_id)

    total_score = 0

    # Insert into student_test_questions table
    @questions.each do |question|
      @student_test_question = StudentTestQuestion.new
      @student_test_question.student_id = current_student.id
      @student_test_question.test_id = test_id
      @student_test_question.question_id = question.id
      @student_test_question.student_choice = params[question.id.to_s].to_i

      # Answer choice 0 refers to unanswered.
      #if !@student_test_question.student_choice
      #  @student_test_question.student_choice = 0
      #end
      # If the student's answer choice matches with the correct answer choice, his/her score for the question is the question's score. Otherwise it's 0.
      @student_test_question.student_score = (@student_test_question.student_choice == question.correct_choice) ? question.score : 0
      total_score += @student_test_question.student_score
      @student_test_question.save
    end

    # Insert into student_tests table
    @student_test = StudentTest.new
    @student_test.student_id = current_student.id
    @student_test.test_id = test_id
    @student_test.student_score = total_score
    @student_test.submitted = true

    @student_test.save

    redirect_to :action => 'view_report', :test_id => test_id
  #respond_to do |format|
  #  format.html { render :template => 'students/tests/post_submit' }
  #  format.json { head :no_content }
  #end

  end

end
