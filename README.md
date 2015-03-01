# Cheat Sheet for URL Shortener App:

## Create the New App

```
rails new url-shortener-app --skip-test-unit -d mysql
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
@import "bootstrap-sprockets";
@import "bootstrap";
```

Next, add this line to **app/assets/javascripts/application.js** in order to activate the Bootstrap JavaScript functionality: (It should go right before the line about turbolinks.)

```
//= require bootstrap-sprockets
```

###Enabling Flash

Add the following just above the `<%= yield %>` inside your **app/views/layouts/application.html.erb**:

```
<% flash.each do |name, message| %>
  <div class="alert alert-<%= name %> alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
    <%= message %>
  </div>
<% end %>
```


## Git

Once and only once per project, you must tell Git to track your whole folder:

```
git init
```

First step of saving anything in Git (think of it as adding your changes to the shopping cart):

```
git add --all
```
The next step, called the commit, actually officially saves this new version. In this case, this happens to be your very first version.

```
git commit -m 'initial commit'
```

###Github
Create a new repo on Github with *the exact same name as your project*, in this case being **url-shortener-app**.

Next, as Github itself will tell you to do, run the following two commands from the terminal, one at a time:

```
git remote add origin git@github.com:your-username/url-shortener-app.git
git push -u origin master
```

##Optional Gems

###Quiet Assets (for making your rails server log easier to read)

Add to your Gemfile:

```
gem 'quiet_assets'
```

and then run

```
bundle
```
from inside your terminal.

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
config.action_mailer.default_url_options = { host: 'localhost:3000' }
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

##Creating Git commits on a regular basis

It's always a good idea to be constantly committing to Git and pushing to Github. While there's no hard rule for this, it's generally a good idea to make a new Git commit after each feature you create, even if the feature is not very big. The whole idea of Git is that you save every version of your code, and it's only effective if have you have significant versions to save, as opposed to dumping all of your changes in one commit. To create a new Git commit, you'll use the same two steps as before, `add` and `commit`, as follows:

```
git add --all
git commit -m 'installed quiet_assets and devise'
```

Obviously, you'll choose your own commit messages as appropriate for what you've just worked on. Then, don't forget to push the latest changes to Github:

```
git push
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

Ignore the (.:format) for now, and you should understand what’s going on. There are four columns. The leftmost column contains the "named routes" (which we will learn about), the second column contains the HTTP verbs, the third column contain the URL, and the rightmost column contains the controller and action that each route triggers.

##Our first controller
Next, let’s create a links controller.

Open up this new links_controller and let’s create our first action, the **index** action. Remember, the **index** action represents where you can view an overview-type list of *all* of a given resource.

##Our first view

Then, we need to create an equivalent view. You can put some placeholder HTML inside of it for now.

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

Next, let’s set up the associations between users and links: One User has many Links. Do this in the models.

Now, a user needs to be able to create a new link, so let’s create a page with a form so they can do so.
The route for this already exists (thanks to the `resources :links` inside the routes file), so let’s create the new action and view.


Now let’s implement the create action inside the links_controller.


This redirects to the index action, but we haven't implemented that yet, so let's do so now as well.

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


Hint: You'll need a brand new route and controller action for this!

##Validations

Let's add to our form view the ability to display validation error messsages. You can read more about that here:
<http://guides.rubyonrails.org/active_record_validations.html#displaying-validation-errors-in-views>

But to cut to the chase, just add the following above the form on the new page:

    <% if @link.errors.any? %>
      <div id="error_explanation">
        <h2><%= pluralize(@link.errors.count, "error") %> prohibited this post from being saved:</h2>
     
        <ul>
        <% @link.errors.full_messages.each do |msg| %>
          <li><%= msg %></li>
        <% end %>
        </ul>
      </div>
    <% end %>


Now, we want to validate that a link contains both a slug as well as a target_url. To do so, add the appropriate "presence" validations to the Link model.

##Another feature

Let's allow a user to just enter slug without http:// or  https://. That's annoying.

In the Link model:

```
def standardize_target_url!
  self.target_url.gsub!("http://", "")
  self.target_url.gsub!("https://", "")
end
```

This method will be called from the links_controller when a new Link is created.

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

A link has many visits.

Now that we have a new model called visits, we can actually consider a visitor clicking on a link as if they're creating a new visit! So we can really move our redirect action out of the links_controller and instead consider it a **create** action which we'll put in a new visits_controller, which we'll create right now as well.

You'll also have to update that route accordingly.

Now, in when a visit is "created", you'll create it. That is, you'll create a brand new Visit in the database each time a link is visited. You can grab the visitor's IP address with a special method available in Rails controllers:

    request.remote_ip

The **request.remote_ip** method is a special method available inside Rails controllers which allows us to see a user's IP address. Pretty cool!

Next, set up a link show page so a user can see number of visits for that link.

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

##Next feature

Next, let’s render 404s if link doesn’t exist. There are different approaches for this, but you can go with `raise ActionController::RoutingError.new('Not Found')`

##Next feature

Next, let’s create edit and update actions for links.

Now add links on the index page which will make the edit page, new page, and show pages easily accessible.

##Next feature: Destroying links

Allow a user to delete links.

##Authorization

Next, let’s make sure people can’t view/modify others’ links!


##Add a Navbar

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




