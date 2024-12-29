import {onRequest} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import {sendMessage} from "./hooks/use_messaging";
import * as admin from "firebase-admin";
import {onSchedule} from "firebase-functions/scheduler";
import {timeoutRequests15m} from "./hooks/use_requests";

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});

export const sendNotification = onRequest((request, response) => {
  logger.info("🎸🎸🎸 Messaging logs!", {structuredData: true});
  logger.info("🎸🎸🎸 request.body: ", request.body);
  const {tokens, title, message} = request.body;

  logger.info("🎸🎸🎸 Tokens: " + tokens);
  sendMessage(tokens, title, message).then(() => {
    logger.info("🎸🎸🎸 Successfully sent message!");
    response.sendStatus(200);
  }).catch(() => {
    logger.error("🐞🐞🐞 Error sending");
    response.sendStatus(500);
  });
});

export const scheduleEvery12h = onSchedule("every 12 hours",
  async () => {
    logger.info("🎸🎸🎸 Scheduled function every 15 minutes",
      {structuredData: true});
    await timeoutRequests15m();
  },
);
