# URL Shortener App

You will be creating a brand new Rails app that serves as a URL Shortener service. You're probably familiar with other such services such as bit.ly, but now you'll be creating your own! If you're not at all familiar with URL Shortening, check out [article](https://en.wikipedia.org/wiki/URL_shortening), but at its core, a URL Shortening solves the following problem: Imagine you have a url that you want to easily distribute (examples: on a physical paper flyer, or on Twitter) but the url is crazy long, as some urls tend to be. A URL Shortening service allows you to create a shortened url (e.g. http://mydomain.com/abcde) that when people visits it, they will be redirected to the real, longer url. This way you can simply distribute the short url, but people will end up at the right place. Another advantage of distributing shortened urls is that you can track how many people visited each one. This can be useful for marketing purposes. Imagine you have an advertisement on two different billboards, and you use a different shortened url on each. Now you can see how many people visited each url, and therefore learn which billboard is more effective.

Anyway, you'll be building this very service - where a user can sign up and have the ability to create shortened urls. The one thing is that instead of these shortened urls starting with http://bit.ly/... they'll start with localhost:3000//... or whatever domain you get if you deploy this app to Heroku. If you were to create this for real, you'd acquire a very short domain name so that your complete urls remain short.

This repo contains a somewhat old version of a completed version of this app (e.g. it uses mysql instead of postgresql). The idea is that it's here as a reference if you get stuck, but you'd try to build this on your own without looking at the source code here.

This guide uses Devise - a gem that integrates authentication for you. Follow the gem's instruction's here to install: https://github.com/plataformatec/devise/ or you can try integrating authentication without the gem (though the example app provided will differ then).

Below is a guide that will help guide you through the building of this app. Note that in some steps, the guide will walk you through some of the nitty gritty details, but in most steps, it will just tell you what to build without even giving hints.

# Guide

## Create the New App

```
rails new url-shortener-app --skip-test-unit -d postgresql
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

We're leaving out the instructions on how to do this since they change so frequently anyway with the gem's constant updates.

### Enabling Flash

Add the following just above the `<%= yield %>` inside your **app/views/layouts/application.html.erb**:

```
<% flash.each do |name, message| %>
  <div class="alert alert-<%= name %> alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
    <%= message %>
  </div>
<% end %>
```


##Git

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

In some apps you may find that you need two different homepages, one for users who are signed in, and another for those who are not. This app is one such case. We will have non-signed-in users have the Sign Up page as their homepage, and we'll have signed-in users have a home page where they can see all their links. The following code *goes below* the `devise_for :users` line in your routes.rb.

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
git commit -m 'your commit message'
```

Obviously, you'll choose your own commit messages as appropriate for what you've just worked on. Then, don't forget to push the latest changes to Github:

```
git push origin master
```

######Ok! We've just completed the basic setup of our app. Now, let's start coding!

##Links

Our primary resource in this app is the notion of a Link. This represents the shortened urls that a user can create and distribute. Thus, we'll have a Link model and Links controller.

##Our first routes

In our **config/routes.rb**, add a route for a links index page.

##Our first controller
Next, create a links controller.

Open up this new links_controller and let’s create our first action, the **index** action. Remember, the **index** action represents where you can view an overview-type list of *all* of a given resource. For now, just leave the body of the action empty, since we don't yet have our Link model.

##Our first view

Then, we need to create an equivalent view. You can put some placeholder HTML inside of it for now.

##Our first model
We need a Link model so that these links can be stored in the database! Inside your terminal:

```
rails generate model Link user_id:integer slug target_url
```
In the above line, **Link** is the name of the model. It is followed (optionally) by the attributes that we wish to give this model. The main attributes are **slug** and **target_url**. **Slug** is the section of the url that follows the domain name. For example, in http://bit.ly/abcde - the slug is abcde. The **target_url** is the actual url that the visitor will be redirected to after clicking on that link. The **user_id** attribute will allow us to set up the association that one User will have many Links.

Inspect migration file, and if all looks good, run:

```
rake db:migrate
```
in the terminal.

##Implementing the index action

Fill in the missing code for the index action in the Links controller.

And inside the corresponding view (you'll need to create a file called **app/views/links/index.html.erb**), add the following:

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

##Associations

1. Next, set up the associations between users and links: One User has many Links. This code belongs in the model.

2. Now, a user needs to be able to create a new link, so create a page with a form so they can do so. Don't forget the additional routes you'll need for this! (new and create)

3. Now, implement the create action inside the links_controller. You'll want to save the link to the database and redirect to the index action. Note that we have not created a show action as of yet.

###The main feature

The main feature of a url shortener is that if one visits such a url, they'll be redirected to another url. You will be implementing this feature right now.

Suggestion: For this feature, create a visits controller and use the create action. Essentially, we're viewing this as follows: Every time a visitor visits a shortened link - they've just "created" a visit.

Hint: Take advantage of wildcard url segments to make this feature work!

##Validations

Add to our form view the ability to display validation error messsages. You can read more about that here:
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

Allow a user to just enter slug without http:// or  https://. That's annoying.

In the Link model:

```
def standardize_target_url!
  target_url.gsub!("http://", "")
  target_url.gsub!("https://", "")
end
```

This method will be called from the links_controller when a new Link is created.

##Next big feature

Track each link click!

We'll need a new resource (model) called Visit.

And let’s create the model! In the terminal:

    rails g model Visit link_id:integer ip_address

and of course after checking the migration file:

    rake db:migrate

Now, set up the association between links and visits so that a link has many visits.

Let's save each visit in the database each time a link is visited - including the ip address of visitor. 

How do we grab the ip address, you ask?

Well here's how: 

The **request.remote_ip** method is a special method available inside Rails controllers which allows us to see a user's IP address. Pretty cool!

Yet another feature: Set up a link show page so a user can see number of visits for that link.

And in the view (which you'll have to create as **app/views/links/show.html.erb**):

    <h1>Link Stats for <%= @link.slug%></h1>
    <h3>Visits: <%= @link.visit_count %></h3>
  
Now, we just referred to a method called `visit_count` for Links. That method doesn't exist yet, so let's go ahead and create it in the Link model:

```
def visit_count
  visits.count
end
```

##Next feature

Next, render 404s if link doesn’t exist. There are different approaches for this, but you can go with `raise ActionController::RoutingError.new('Not Found')`

##Next feature

Next, create edit and update actions for links.

Now add links on the index page which will make the edit page, new page, and show pages easily accessible.

##Next feature: Destroying links

Allow a user to delete links.

##Authorization

Next, make sure people can’t view/modify others’ links!


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




