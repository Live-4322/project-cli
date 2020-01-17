require 'spec_helper'

RSpec.describe NowPlaying::Movie do
  context 'Class Methods' do
    # If you delete the fixtures or VCR generates new cassettes these tests
    # will have to be updated based on current values from:
    # http://imdb.com/movies-in-theaters
    around(:each) do |example|
      VCR.use_cassette("now-playing") do
        example.run
      end
    end
    let(:movies){NowPlaying::Movie.all}

    describe '.all' do
      it 'returns an array of movies' do
        expect(movies).to be_an(Array)
        expect(movies.first).to be_a(NowPlaying::Movie)
      end

      it 'correctly scrapes names and urls for the movies' do
        expect(movies.first.name).to eq("Bad Boys For Life (2020)")
        expect(movies.first.url).to eq("http://imdb.com/movies-in-theaters")
      end
    end

    describe '.find' do
      it 'returns the movie based on position in @@all' do
        expect(NowPlaying::Movie.find(1)).to eq(movies[0])
      end
    end

    describe '.find_by_name' do
      it 'returns the movie based on the name' do
        expect(NowPlaying::Movie.find_by_name("Bad Boys For Life")).to eq(movies[0])
      end
    end
  end

  context 'Instance Methods' do
    subject{NowPlaying::Movie.new("Bad Boys For Life (2020)", "https://www.imdb.com/title/tt1502397/?ref_=inth_ov_tt")}

    describe '#name' do
      it 'has a name' do
        expect(subject.name).to eq("Bad Boys For Life (2020)")
      end
    end

    describe '#url' do
      it 'has a url' do
        expect(subject.url).to eq("https://www.imdb.com/title/tt1502397/?ref_=inth_ov_tt")
      end
    end

    describe '#stars' do
      it 'has stars based on scraping the main URL' do
        VCR.use_cassette("movie") do
          expect(subject.stars).to eq(" Will Smith, Alexander Ludwig, Vanessa Hudgens, Michael Bay")
        end
      end
    end

    describe '#summary' do
      it 'has a summary based on scraping the plotsummary URL' do
        VCR.use_cassette("plotsummary") do
          expect(subject.summary).to eq("The Bad Boys Mike Lowrey and Marcus Burnett are back together for one last ride in the highly anticipated Bad Boys for Life.")
        end
      end
    end
  end
end