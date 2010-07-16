class PagesController < ApplicationController
  def home
    @title = 'home'
  end

  def contact
    @title = 'Contact'
  end

  def about
    @title = 'About'
  end
  
end
