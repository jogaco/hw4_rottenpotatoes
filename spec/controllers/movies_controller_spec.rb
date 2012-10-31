require_relative '../spec_helper'
require_relative '../../app/controllers/application_controller'
require_relative '../../app/controllers/movies_controller'

describe MoviesController do
  describe 'Find Movies With Same Director and the movie director is known' do
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

  describe 'Find Movies With Same Director and the movie director is unknown' do
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