import {onRequest} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import {sendMessage} from "./hooks/use_messaging";
import * as admin from "firebase-admin";

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});

export const sendNotification = onRequest((request, response) => {
  logger.info("🎸🎸🎸 Messaging logs!", {structuredData: true});
  logger.info("🎸🎸🎸 request.body: " + request.body);
  const {tokens, title, message: body} = JSON.parse(request.body);

  logger.info("🎸🎸🎸 Tokens: " + tokens);
  sendMessage(tokens, title, body).then(() => {
    logger.info("🎸🎸🎸 Successfully sent message!");
    response.sendStatus(200);
  }).catch(() => {
    logger.error("🐞🐞🐞 Error sending");
    response.sendStatus(500);
  });
});
