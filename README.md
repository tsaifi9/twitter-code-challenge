## README

[heroku hosted application](https://stackcommerce-twitter-app.herokuapp.com/)

### Design Rationale
1. Twitter API is placed within WebServices module as this module (WebServices) could be used in the future to handle other external facing services. Keeping it within this module also creates a logical structure in case we want to create a healthcheck job which will just iterate on all the classes within the WebServices module and call a method that will determine whether the service is up or not.

2. Twitter API credentials are exposed. This was a conscious decision as the account associated with it has no value AND the api credentials were set to be read-only (i.e., no modifications can be made).

3. Postgres production database credentials are not exposed and are stored as environment variables on the given production node. This was done using rails secrets.

4. React.js was chosen as the front-end js framework as we wanted to dynamically display the user's tweets. This can be easily handled with states.

### Local Environment Setup Instructions

```
git clone git@github.com:tsaifi9/twitter-code-challenge.git
cd twitter-code-challenge/
bundle
```
1. set up the pg user

```
su - postgres
psql
create role stackcommerce with createdb login password 'password1'; 
\q
exit
rake db:reset
```

2. install phantomjs **v2.0.0** for poltergeist

3. run ``rake`` for specs 

