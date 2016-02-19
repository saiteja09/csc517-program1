# CSC 517 Program 1 - Class Portal

This application is an example Ruby on Rails app deployed to [Heroku](https://ewhorton-portal.herokuapp.com).
You can view the [requirements](https://docs.google.com/document/d/1xmeH4MAlUs6QfPoC4J4bsMKYWkawDZrsZDFM7S1G8ag/edit) in google docs.

## Recommended Build Environment
It is recommended to use rbenv and ruby-build to install a non-system version of ruby. A package manager like homebrew can be used for installation
```
brew isntall rbenv ruby-build
rbenv install 2.3.0
```
See [rbenv](https://github.com/rbenv/rbenv#installation) for configuration instructions.

## PostgreSQL
Portal requires an installation of Postgres and hooks up with Heroku Postgres on deployment. Install the latest version of Postgres and create the development and test databases.
```
$ psql
# create database portal_development;
# create database portal_test;
```

## RubyMine
Development through RubyMine is recommended. To start the Rails server use Run > Development: portal.

## User Authentication
For more information on user authentication see the Code Academy [tutorial](https://www.codecademy.com/learn/rails-auth). Auth for this app was based on tutorial content.

## Setup and Configuration
Portal comes with a seed file for initial database values. Migrate and populate the database with
```
rake db:migrate
rake db:seed
```

The default admin account cannot be deleted. Authentication information is
```
user: admin@portal.net
pass: 3YP)g14*
```

## Usage
### Account Creation
Admins and Instructors must request an account be created by an existing site Admin. Students may sign up for an account by navigating to the site and requesting to create one. 

### Profile Editing
Users may edit their profile by logging in and selecting the dropdown menu in the top right. The log out link is also located in the user dropdown.

### Additional
Users of different types have access to different links in the navigation bar. Jump in and explore.