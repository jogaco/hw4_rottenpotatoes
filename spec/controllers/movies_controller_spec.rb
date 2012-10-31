require 'spec_helper'
require_relative '../../app/controllers/application_controller'
require_relative '../../app/controllers/movies_controller'

describe MoviesController do
  describe 'Find Movies With Same Director' do

    context 'the movie director is known' do
      before :each do
        @movie = FactoryGirl.build(:movie, :title => 'Star Wars 2', :director => 'George Lucas', :id => 1)
        @fake_results = [mock('Movie'), mock('Movie')]
      end
  
      it 'should call the model method that performs Find Movies With Director and return a list of movies' do
        @movie.should_receive(:find_with_same_director)
        Movie.stub(:find).and_return(@movie);
        get 'same_director', { :id => @movie.id }
      end
  
      it 'should select the Find Movies with Same Director template for rendering' do
        Movie.stub(:find).and_return(@movie);
        @movie.stub(:find_with_same_director).and_return(@fake_results)
        get 'same_director', { :id => @movie.id }
        response.should render_template('same_director')
      end
  
      it 'should make the Find Movies with Same Director results available to that template' do
        Movie.stub(:find).and_return(@movie);
        @movie.stub(:find_with_same_director).and_return(@fake_results)
        get 'same_director', { :id => @movie.id }
        assigns(:movies).should == @fake_results
      end
    end

    context 'the movie director is NOT known' do
 
      before :each do
        @movie_nodirector = FactoryGirl.build(:movie, :title => 'Pinocchio', :id => 2)
        @fake_empty_results = []
      end
    
      it 'should result in an empty list of Find Movies with Same Director' do
        Movie.stub(:find).and_return(@movie_nodirector);
        @movie_nodirector.stub(:find_with_same_director).and_return(@fake_empty_results)
        get 'same_director', { :id => @movie_nodirector.id }
        assigns(:movies).should == []
      end

      it 'should redirect to the Home Page' do
        Movie.stub(:find).and_return(@movie_nodirector);
        @movie_nodirector.stub(:find_with_same_director).and_return(@fake_empty_results)
        get 'same_director', { :id => @movie_nodirector.id }
        response.should redirect_to movies_path
      end

      it 'should display a notice that the film has no director' do
        Movie.stub(:find).and_return(@movie_nodirector);
        @movie_nodirector.stub(:find_with_same_director).and_return(@fake_empty_results)
        get 'same_director', { :id => @movie_nodirector.id }
        flash[:notice].should_not be_nil
        flash[:notice].should include @movie_nodirector.title
      end
    end
  end

  describe 'New Movie should show a blank form to enter movie info' do
    it 'should open the movie Form' do
      get 'new'
      response.should render_template('new')   
    end
  end

  describe 'Edit Movie should show a form to edit the movie info' do
    before :each do
      @movie = FactoryGirl.build(:movie, :title => 'Star Wars 2', :director => 'George Lucas', :id => 1)
    end
  
    it 'should open the movie Form' do
      Movie.stub(:find).and_return(@movie);
      get 'edit', { :id => 1 }
      response.should render_template('edit')   
    end

    it 'should save the movie when saving the form' do
      Movie.stub(:find).and_return(@movie);
      @movie.stub(:update_attributes).and_return(@movie);
      post 'update',{ :id => 4, :method => :put, :title => 'Planeta Simios' }
      response.should redirect_to movie_path(@movie)
    end

  end

  describe 'Find All Movies matching only certain MPAA ratings' do
    it 'should call the model method that performs Find Movies with ratings and return a list of movies' do
       @movie = FactoryGirl.build(:movie, :title => 'Star Wars 2', :director => 'George Lucas', :id => 1)
       get 'index', { 'ratings[PG]'.to_sym => '1' }
    end    

    it 'should keep the selected ratings in the parameters when I order by title and redirect' do
       @movie = FactoryGirl.build(:movie, :title => 'Star Wars 2', :director => 'George Lucas', :id => 1)
       get 'index', { :ratings => [{'ratings[PG]' => '1'}], :sort => 'title' }
       response.should redirect_to movies_path(:ratings => [{'ratings[PG]' => '1'}], :sort => 'title')
    end    
    
  end

end