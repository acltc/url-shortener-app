# Cheat Sheet for URL Shortener App:

## Create the New App

```
rails new url-shortener-app --skip-test-unit --database=mysql
```
## General Setup

### Go into newly created directory
```
cd url-shortener-app
```

### Create the DB
```
rake db:create
```

### Add Twitter Bootstrap via the gem
Add to the Gemfile:

```
gem 'bootstrap-sass'
```

Don't forget that whenever you add a new gem to the Gemfile, you must run the following in the terminal:

```
bundle
```

Next, make a new sheet in stylesheets called **style.css.scss** . This is the CSS that applies to the entire application.

Now, make another file in stylesheets called **_external.css.scss** and put inside that file:

```
@import “bootstrap”;
```

Next, add this line to **app/assets/javascripts/application.js** in order to activate the Bootstrap JavaScript functionality: (It should go right before the line about turbolinks.)

```
//= require bootstrap
```

### Temporarily Disabling "Strong Parameters" Security

*FOR NOW AND NOW ONLY* add this line to **config/application.rb** to disable an important security feature which we’ll learn about later.** DON’T DO THIS IN REAL LIFE!**

```
config.action_controller.permit_all_parameters = true
```

### RSpec

Add to Gemfile:

```
group :development, :test do
  gem 'rspec-rails', '~> 3.0.0'
end
```

And of course don't forget to

```
bundle
```

Then, run the following command inside the terminal:

```
rails generate rspec:install
```

Next, go inside the **.rspec** file found in the root of your project, and remove the following line:

```
—-warnings
```

Then, run this command inside your terminal:

```
bundle binstubs rspec-core
```


###Enabling Flash

Add the following just above the `<%= yield %>` inside your **app/views/layouts/application.html.erb**:

```
<% flash.each do |name, message| %>

  <%= content_tag :div, message, class: "alert alert-#{name}" %>

<% end %>
```


## Git

Once and only once per project, you must tell Git to track your whole folder:

```
git init
```

First step of saving anything in Git (think of it as adding your changes to the shopping cart):

```
git add .
```
The next step, called the commit, actually officially saves this new version. In this case, this happens to be your very first version.

```
git commit -m 'initial commit'
```

###Github
Create a new repo on Github with *the exact same name as your project*, in this case being **url-shortener-app**.

Next, as Github itself will tell you to do, run the following two commands from the terminal, one at a time:

```
git remote add origin git@github.com:acltc/url-shortener-app.git
git push -u origin master
```

##Optional Gems

###Quiet Assets (for making your rails server log easier to read)

Add to your Gemfile:

```
gem ‘quiet_assets'
```

and then run

```
bundle
```
from inside your terminal.

###Simple Form: (makes form creation much easier)

Add to your Gemfile:

```
gem ‘simple_form’
```
and then run in your terminal:

```
bundle
```
Next, run this in your terminal. (The --bootstrap option is only for projects using Twitter Boostrap, but we happen to be doing so.)

```
rails generate simple_form:install --bootstrap
```

##Devise

Add to your Gemfile:

```
gem ‘devise’
```

and then don't forget to

```
bundle
```
Then, run from the terminal:

```
rails generate devise:install
```

Next, add to your **config/environments/development.rb**:

```
config.action_mailer.default_url_options = { host: 'localhost:3000’ }
```
We will use Devise to create our User model. Run in the terminal:

```
rails generate devise User
```

This creates several things, but most importantly, it creates the User model and a corresponding migration file. Check the migration file (inside db/migrate), and add any additional columns that may be necessary in your app. For this particular app, we won't add anything extra.

Now that we have our first migration file, we must run in the terminal:

```
rake db:migrate
```

#####Optional

If you ever want to customize the devise forms, run from the terminal:

```
rails generate devise:views
```

Also, by default, the signout path (of /users/signout) must be accompanied by a DELETE HTTP verb. If you want to change it to GET, find the line inside your **config/initializers/devise.rb** where it says:

```
config.sign_out_via = :delete
```

and change it to:

```
config.sign_out_via = :get
```
I will be doing this for this app. I like having the ability to sign out by entering a URL inside the url bar in my browser.

#### Devise routes

I like having two different homepages, one for users who are signed in, and another for those who are not. You may not need this for your app, but we will for ours. We will have non-signed-in users have the Sign Up page as their homepage, and we'll have signed-in users have a home page where they can see all their links. The following code *goes below* where it says `devise_for :users`.

```
devise_scope :user do
   authenticated :user do
     root 'links#index', as: :authenticated_root
   end

   unauthenticated do
     root 'devise/registrations#new', as: :unauthenticated_root
   end
 end
```
######Ok! We've just completed the basic setup of our app. Now, let's start coding!


##Our first routes

In our **config/routes.rb**, add the following line. (This can go below all the devise/user stuff.)

```
resources :links
```
This line is actually a (common) shortcut for all seven of the RESTful routes for any resource. You can actually see all the routes if you run `rake routes` from your terminal. If you do run it, you'll see that the following routes now exist:


                   links GET    /links(.:format)               links#index
                         POST   /links(.:format)               links#create
                new_link GET    /links/new(.:format)           links#new
               edit_link GET    /links/:id/edit(.:format)      links#edit
                    link GET    /links/:id(.:format)           links#show
                         PATCH  /links/:id(.:format)           links#update
                         PUT    /links/:id(.:format)           links#update
                         DELETE /links/:id(.:format)           links#destroy                         

Ignore the (.:format) for now, and you should understand what’s going on. There are four columns. The leftmost column contains the "named routes", the second column contains the HTTP verbs, the third column contain the URL, and the rightmost column contains the controller and action that each route triggers.

##Our first controller
Next, let’s create a links controller. In the terminal:

```
rails g controller links
```

This controller can be found inside **app/controllers**.

Open up this new links_controller and let’s create our first action, the **index** action. Remember, the **index** action represents where you can view an overview-type list of *all* of a given resource.

##Our first view

Then, we need to create an equivalent view. Inside **app/views/links**, create a file called **index.html.erb**. You can put some placeholder HTML inside of it for now.

##Our first model
We need a Link model so that these links can be stored in the database! Inside your terminal:

```
rails generate model Link user_id:integer slug target_url
```
In the above line, **Link** is the name of the model. It is followed (optionally) by the attributes that we wish to give this model. The main attributes are **slug** and **target_url**. **Slug** is the actual link that visitor will click on (for example: acltc), and the **target_url** is the actual link that the visitor will be redirected to after clicking on that link. The **user_id** attribute will allow us to set up the association that one User will have many Links.

Inspect migration file, and if all looks good, run:

```
rake db:migrate
```
in the terminal.

##Associations

Next, let’s set up the associations between users and links:
Inside the User model (found in **app/models/user.rb**):

```
has_many :links
```

And in the Link model (**app/models/link.rb**):

```
belongs_to :user
```

Now, a user needs to be able to create a new link, so let’s create a page with a form so they can do so.
The route for this already exists (thanks to the `resources :links` inside the routes file), so let’s create the new action and view:

Inside the links_controller:

```
def new
  @link = Link.new
end
```

And inside the view (you'll need to create **app/views/links/new.html.erb**:)

    <h1>Create a new link</h1>
    
    <%= simple_form_for @link do |f| %>
      <%= f.input :slug %>
      <%= f.input :target_url %>
      <%= f.button :submit %>
    <% end %>


Now let’s implement the create action inside the links_controller:

```
def create
  @link = current_user.links.new(params[:link])

  if @link.save
    flash[:success] = "Link created successfully"
    redirect_to links_path
  else
    render 'new'
  end
end
```

This redirects to the index action, but we haven't implemented that yet, so let's do so now:

```
def index
  @links = current_user.links
end
```

And inside the corresponding view (you'll need to create a file called **app/views/links/index.html.erb**):

    <h1>Your links</h1>
    
    <table>
      <tr>
        <th>Slug</th>
        <th>Target URL</th>
        <th>Created At</th>
      </tr>
      <% @links.each do |link| %>
        <tr>
          <td><%= link.slug %></td>
          <td><%= link.target_url %></td>
          <td><%= link.created_at %></td>
        </tr>
      <% end %>
    <table>

###The main feature: Having links that a visitor clicks on redirect them to some other page


At the end of the routes file:

    get '/:slug' => 'links#redirect’
  

And in the links_controller:

```
def redirect
  @link = Link.find_by(:slug => params[:slug])

  redirect_to @link.target_url
end
```

##Validations

We actually didn't cover this yet, but there's some special view code that we'll need to display validation errors in view. Read more about that here:
<http://guides.rubyonrails.org/active_record_validations.html#displaying-validation-errors-in-views>

But to cut to the chase, just add the following above the form on the new page:

    <% if @post.errors.any? %>
      <div id="error_explanation">
        <h2><%= pluralize(@post.errors.count, "error") %> prohibited this post from being saved:</h2>
     
        <ul>
        <% @post.errors.full_messages.each do |msg| %>
          <li><%= msg %></li>
        <% end %>
        </ul>
      </div>
    <% end %>


Now, we want to validate that a link contains both a slug as well as a target_url. To do so, add the following the Link model (**app/models/link.rb**):

```
validates :slug, presence: true
validates :target_url, presence: true
```

##Another feature

Let's allow a user to just enter slug without http:// or  https://. That's annoying.

In the Link model:

```
def standardize_target_url!
  self.target_url.gsub!("http://", "")
  self.target_url.gsub!("https://", "")
end
```

Now inside our links controller:

```
def create
  @link = current_user.links.new(params[:link])
  @link.standardize_target_url!

  if @link.save
    flash[:success] = "Link created successfully"
    redirect_to links_path
  else
    render 'new'
  end
end

def redirect
  @link = Link.find_by(:slug => params[:slug])

  redirect_to "http://#{@link.target_url}"
end
```

##Specs! No code should go untested!

Inside the Links model spec (**spec/models/link_spec.rb**):

```
require 'rails_helper'

RSpec.describe Link, :type => :model do
  it 'should standardize target_url by removing http://' do
    link = Link.new(:slug => 'test', :target_url => 'http://example.com')
    link.standardize_target_url!

    expect(link.target_url).to eq('example.com')
  end

  it 'should standardize target_url by removing https://' do
    link = Link.new(:slug => 'test', :target_url => 'https://example.com')
    link.standardize_target_url!

    expect(link.target_url).to eq('example.com')
  end
end
```
##Next big feature

Let's track each link click!

We'll need a new resource (model) called Visit.

in our routes, add:

    resources :visits

And let’s create the model! In the terminal:

    rails g model Visit link_id:integer ip_address

and of course after checking the migration file:

    rake db:migrate


Now let’s set up the association between links and visits!

A link

    has_many :visits

And a visit

    belongs_to :link


Now that we have a new model called visits, we can actually consider a visitor clicking on a link as if they're creating a new visit! So we can really move the **redirect** action out of the links_controller and instead consider it a **create** action which we'll put in a new visits_controller, which we'll create right now:

    rails generate controller visits

Let’s move the redirect action there and call it create!

And now we'll also have to change the route to:

    get '/:slug' => 'visits#create’



And now implement this as follows:

```
def create
  @link = Link.find_by(:slug => params[:slug])

  @link.visits.create(:ip_address => request.remote_ip)

  redirect_to "https://#{@link.target_url}"
end
```

The **request.remote_ip** method is a special method available inside Rails controllers which allows us to see a user's IP address. Pretty cool!

Next, let’s set up a link show page so a user can see number of visits for that link.

Inside the links_controller:

```
def show
  @link = Link.find_by(:id => params[:id])
end
```

And in the view (which you'll have to create as **app/views/links/show.html.erb**):

    <h1>Link Stats for <%= @link.slug%></h1>
    <h3>Visits: <%= @link.visit_count %></h3>
  
Now, we just referred to a method called `visit_count` for Links. That method doesn't exist yet, so let's go ahead and create it in the Link model:

```
def visit_count
  self.visits.count
end
```
Of course, we'll need to test that!! So let's add a spec for it (again in **spec/models/link_spec.rb**):

```
it 'should return correct visit count' do
  link = Link.create(:slug => 'test', :target_url => 'https://example.com')
  5.times do
    link.visits.create
  end

  expect(link.visit_count).to eq(5)
end
```
##Next feature

Next, let’s render 404s if link doesn’t exist. There are different approaches for this, but let's just go with `raise ActionController::RoutingError.new('Not Found')`

Let's modify the create action in the visits_controller:

```
def create
  @link = Link.find_by(:slug => params[:slug])

  if @link
    @link.visits.create(:ip_address => request.remote_ip)
    redirect_to "http://#{@link.target_url}"
  else
    raise ActionController::RoutingError.new('Not Found')
  end
end
```

Next, let’s create edit and update actions for links, and use a partial to share a form between new and edit.

Inside the links_controller:

```
def edit
  @link = Link.find_by(:id => params[:id])
end

def update
  @link = Link.find_by(:id => params[:id])

  if @link.update(params[:link])
    @link.standardize_target_url!
    flash[:success] = "Link created successfully"
    redirect_to links_path
  else
    render 'edit'
  end
end
```

###View Partial
Instead of copying and pasting the new form into the edit view, let's create a view partial!

Create a new file inside **app/views/links**. Following the special filename syntax for view partials, it should begin with an underscore. We'll call it: **_form.html.erb**. Copy and paste the form inside of it. And now, replace the form inside **new.html.erb** with:

    <h1>Create a new link</h1>

    <%= render "form" %>

And create an **edit.html.erb** view that will be the same except for have slightly different text as it's `h1`.

Let's add links on the index page which will make the edit page, new page, and show pages easily accessible:

    <h1>Your links <small><%= link_to "Add New Link", new_link_path %></small></h1>

    <table class="table table-striped table-hover">
      <tr>
        <th>Slug</th>
        <th>Target URL</th>
        <th>Created At</th>
        <th>Actions</th>
      </tr>
      <% @links.each do |link| %>
        <tr>
          <td><%= link_to link.slug, link_path(link.id) %></td>
          <td><%= link_to link.target_url, link_path(link.id) %></td>
          <td><%= link_to link.created_at, link_path(link.id) %></td>
          <td><%= link_to "Edit", edit_link_path(link.id) %></td>
        </tr>
      <% end %>
    </table>


##Next feature: Destroying links

In the links_controller:

```
def destroy
  @link = Link.find_by(:id => params[:id])

  @link.destroy
  
  flash[:success] = "Link destroyed successfully"
  redirect_to links_path
end
```


##Authorization

Next, let’s make sure people can’t view/modify others’ links!

The final links_controller should appear as follows:

```
class LinksController < ApplicationController
  before_action :authenticate_user!

  def index
    @links = current_user.links
  end

  def show
    @link = current_user.links.find_by(:id => params[:id])

    unless @link
      flash[:warning] = "Link not found"
      redirect_to links_path
    end
  end

  def new
    @link = Link.new
  end

  def create
    @link = current_user.links.new(params[:link])
    @link.standardize_target_url!

    if @link.save
      flash[:success] = "Link created successfully"
      redirect_to links_path
    else
      render 'new'
    end
  end

  def edit
    @link = current_user.links.find_by(:id => params[:id])

    unless @link
      flash[:warning] = "Link not found"
      redirect_to links_path
    end
  end

  def update
    @link = current_user.links.find_by(:id => params[:id])

    if @link && @link.update(params[:link])
      @link.standardize_target_url!
      flash[:success] = "Link created successfully"
      redirect_to links_path
    else
      render 'edit'
    end
  end

  def destroy
    @link = current_user.links.find_by(:id => params[:id])

    if @link && @link.destroy
      flash[:success] = "Link destroyed successfully"
      redirect_to links_path
    else
      flash[:warning] = "Unsuccessful"
      redirect_to links_path
    end
  end

end
```

##Navbar

New version of **app/views/layouts/application.html.erb**:

    <!DOCTYPE html>
    <html>
    <head>
      <title>UrlShortenerApp</title>
      <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true %>
      <%= javascript_include_tag 'application', 'data-turbolinks-track' => true %>
      <%= csrf_meta_tags %>
    </head>
    <body>
      <nav class="navbar navbar-inverse" role="navigation">
        <div class="container-fluid" id="main-navbar">
          <!-- Brand and toggle get grouped for better mobile display -->
          <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
              <span class="sr-only">Toggle navigation</span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
            </button>
            <a id="logo" class="navbar-brand" href="/">url.co</a>
    
          </div>
    
          <!-- Collect the nav links, forms, and other content for toggling -->
          <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            
            <ul class="nav navbar-nav navbar-right">
              <li><a href="#">Link</a></li>
              <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown" id="options-nav">Options<b class="caret"></b></a>
                <ul class="dropdown-menu">
                  <% if current_user.nil? %>
                    <li><a href="/users/sign_up">Sign Up</a></li>
                    <li><a href="/users/sign_in">Sign In</a></li>
                  <% end %>
                  
                  <% if current_user %>
                    <li><a href="/users/edit">Edit Profile</a></li>
                    <li class="divider"></li>
                    <li><a href="/users/sign_out" id="sign_out_link">Sign Out</a></li>
                  <% end %>
                </ul>
              </li>
            </ul>
          </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
      </nav>
    
      <div class="container-fluid">
    
        <% flash.each do |name, message| %>
          <%= content_tag :div, message, class: "alert alert-#{name}" %>
        <% end %>
    
        <%= yield %>
      </div>
    
    </body>
    </html>

##Styling

Season to taste! The easist wholesale changes you can make is by adding a cool background image (check out <http://subtlepatterns.com>) and a new font (check out <http://cssfontstack.com>). Add the background image you've downloaded to **app/assets/images** and add to your **app/assets/stylesheets/style.css.scss** something along the following lines:

```
body {
  background-image: image-url("wood_pattern.png");
  font-family: Futura, "Trebuchet MS", Arial, sans-serif;
}
```








