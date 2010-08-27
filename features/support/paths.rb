module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    when /the show page for (.+)/
      if $1 == "that tweet_scheme"
        scheme_path(model($1))
      else
        polymorphic_path(model($1))        
      end
    when /the edit page for (.+)/
      if $1 == "that tweet_scheme"
        edit_scheme_path(model($1))
      else
        edit_polymorphic_path(model($1))        
      end
    when /the new page for pawns/
      new_pawn_path
    when /the pawn index page/
      pawns_path

    when /the new page for schemes/
      new_scheme_path
    when /the scheme index page/
      schemes_path

    when /the new page for tweet_schemes/
      new_schemes_path
    when /the tweet_scheme index page/
      schemes_path

      
    when /the home\s?page/
      '/'
    when /the registration page/
     new_user_path

    when /the login page/
      login_path
    when /my dashboard page/
      '/'

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
