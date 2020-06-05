// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();

// Take the text parameter passed to this HTTP endpoint and insert it into the
// Realtime Database under the path /messages/:pushId/original
exports.addMessage = functions.https.onRequest(async (req, res) => {
  // Grab the text parameter.
  const original = req.query.text;
  // Push the new message into the Realtime Database using the Firebase Admin SDK.
  const snapshot = await admin.database().ref('/ready_queue').once('value', (snapshot) => {
    for (let category in snapshot.val()) {
      for (let period in snapshot.val()[category]) {
        const list = [];
        for (let key in snapshot.val()[category][period])
          list.push(snapshot.val()[category][period][key]);
        for (let i=0;i<list.length-1;i++) {
          admin.database().ref('/users').child(list[i]).update({ "slave": list[i+1], "user_state": 3 });
        }
        admin.database().ref('/users').child(list[list.length-1]).update({ "slave": list[0], "user_state": 3 });
      }
    }
    res.json(snapshot.val());
  });
});
