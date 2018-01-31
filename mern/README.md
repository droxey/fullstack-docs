# MERN Cheat Sheet

## Deployment
### Heroku: Deploying MongoDB
1. In your project directory, run the following command to add the `mongolab` dependency to your Heroku app: 
```bash
heroku addons:create mongolab
```
1. In your `server.js` file, amend your code to fit the following snippet:
```js
// If deployed, use the deployed database.
// Otherwise use the local mongoTasks database
const MONGODB_URI = process.env.MONGODB_URI || "mongodb://localhost/mongoTasks";

// Set mongoose to use  built in JavaScript ES6 Promises
// instead of the default callback mechanism.
mongoose.Promise = Promise;

// Connect to Mongo!
mongoose.connect(MONGODB_URI, {
  useMongoClient: true
});
