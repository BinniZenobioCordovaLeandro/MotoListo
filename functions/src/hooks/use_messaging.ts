import {logger} from "firebase-functions/v2";
import * as admin from "firebase-admin";
import {
  BaseMessage,
} from "firebase-admin/lib/messaging/messaging-api";

export const sendMessage = (
  tokens: string[],
  title: string,
  message: string
) => {
  return new Promise((resolve, reject) => {
    const baseMessage: BaseMessage = {
      notification: {
        title,
        body: message,
      },
    };

    const onSuccess = (response: any) => {
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

    tokens.forEach((token) =>
      admin.messaging().send({
        token,
        ...baseMessage,
      })
        .then(onSuccess)
        .catch(onError)
    );
  });
};
