# ror_salesforce_integration

Salesforce Streaming API
Used
* Ruby 2.6.2
* Rails 6.0.3.1
* DB: Postgresql

## Setup
**Database**  
Change `config/database.yml` file as required  

**Environment Variables**

Create `.env` file in project root directory and add following valiables.

* USERNAME: User name of user who have access to read accounts and contacts records
* PASSWORD: Password of the user
* SECURITY_TOKEN: Security token of the user. Check doc for details.
* CLIENT_ID: **create a connected app** Consumer Key
* CLIENT_SECRET: **create a connected app** Consumer Secret
* ACCOUNT_PUSH_TOPIC_NAME: Topic name for subscribing accounts for realtime changes. **max_char:** 25
* CONTACT_PUSH_TOPIC_NAME: Topic name for subscribing contacts for realtime changes. **max_char:** 25
* REDIS_URL: redis server url

**Run** following commands from termain within project root directory
* `bundle install` 
* `rake db:migrate`


## ToDO
- [x] Saledforce Integration Setup 
- [ ] Views for Accounts
- [ ] Views for Contacts


Feel free to send PR and use this code base as starter project for your project with Salesforce.