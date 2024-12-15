import {logger} from "firebase-functions/v2";
import * as admin from "firebase-admin";
import {
  BaseMessage,
  BatchResponse,
} from "firebase-admin/lib/messaging/messaging-api";

export const sendMessage = (
  token: string[],
  title: string,
  body: string
) => {
  return new Promise((resolve, reject) => {
    const content = {
      title,
      body,
    };

    const message: BaseMessage = {
      notification: content,
      android: {
        notification: content,
      },
    };

    const onSuccess = (response: BatchResponse) => {
      logger.info("🎸🎸🎸 Messaging logs!", response);
      if (response.failureCount > 0) {
        logger.error("🐛🐛🐛 Failed to send message to some tokens:", response);
        reject(response);
      } else if (response.successCount > 0) {
        logger.info("🎸🎸🎸 Successfully sent all messages",
          response.successCount);
        resolve(response);
      }
    };

    const onError = (error: any) => {
      logger.error("🐞🐞🐞 Error sending message:", error);
      reject(error);
    };

    admin.messaging().sendMulticast({...message, tokens: token})
      .then(onSuccess).catch(onError);
  });
};
