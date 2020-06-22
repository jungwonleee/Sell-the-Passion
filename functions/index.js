// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const moment = require('moment');

admin.initializeApp();
const fcm = admin.messaging();

// Take the text parameter passed to this HTTP endpoint and insert it into the
// Realtime Database under the path /messages/:pushId/original
exports.matching = functions.https.onRequest(async (req, res) => {
  // Grab the text parameter.
  const original = req.query.text;
  // Push the new message into the Realtime Database using the Firebase Admin SDK.
  const snapshot = await admin.database().ref('/ready_queue').once('value', async (snapshot) => {
    for (let category in snapshot.val()) {
      for (let period in snapshot.val()[category]) {
        const list = [];
        for (let key in snapshot.val()[category][period]) {
          list.push(snapshot.val()[category][period][key]);
        }
        console.log(list)
        for (let i=0;i<list.length;i++) {
          await admin
            .database()
            .ref('/users')
            .child(list[i]["0"])
            .update({ "slave": list[(i+1)%list.length]["0"], "user_state": 3 });

          await admin
            .database()
            .ref('/users')
            .child(list[i]["0"])
            .child("notification")
            .push()
            .update({ 
              title: list.length==1?
                "매칭에 실패하였습니다":
                "매칭이 완료되었습니다",
              body: list.length==1?
                "매칭을 취소할지, 다시 신청할지 결정해주세요.":
                "내일부터 목표관리 탭과 후원관리 탭이 활성화됩니다.",
              type: "0"
            });

          await admin
            .database()
            .ref('/users')
            .child(list[i]["0"])
            .child("goal")
            .update({ "start_date": moment().add(1, 'days').format("yyyy-MM-DD") });

          const notification = {
            notification: {
              title: list.length==1?
                "매칭에 실패하였습니다":
                "매칭이 완료되었습니다",
              body: list.length==1?
                "매칭을 취소할지, 다시 신청할지 결정해주세요.":
                "내일부터 목표관리 탭과 후원관리 탭이 활성화됩니다.",
              click_action: 'FLUTTER_NOTIFICATION_CLICK',
            },
            data: {
              title: list.length==1?
                "매칭에 실패하였습니다":
                "매칭이 완료되었습니다",
              body: list.length==1?
                "매칭을 취소할지, 다시 신청할지 결정해주세요.":
                "내일부터 목표관리 탭과 후원관리 탭이 활성화됩니다.",
              click_action: 'FLUTTER_NOTIFICATION_CLICK',
              type: "0"
            }
          };
          fcm.sendToDevice(list[i]["1"], notification);
        }
      }
    }
    await admin.database().ref('/ready_queue').remove();
    res.json(snapshot.val());
  });
});

exports.notificateFeedback = functions.https.onCall(async (data, context) => {
  // Grab the text parameter.
  const to = data.to;
  const notification = {
    notification: {
      title: "평가가 완료되었습니다",
      body: "목표관리 탭에서 평가를 확인해주세요.",
      click_action: 'FLUTTER_NOTIFICATION_CLICK',
      type: "1"
    },
    data: {
      title: "평가가 완료되었습니다",
      body: "목표관리 탭에서 평가를 확인해주세요.",
      click_action: 'FLUTTER_NOTIFICATION_CLICK',
      type: "1"
    }
  };
  fcm.sendToDevice(to, notification);
});
