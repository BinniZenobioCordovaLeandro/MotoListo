import {getFirestore} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";


export const timeoutRequests15m = async (oldMinutes = 15) => {
  const vehicles = getFirestore().collection("vehicles");
  const snapshot = await vehicles.where("status", "==", "requesting")
    .where("timestamp", "<", Date.now() - oldMinutes * 60 * 1000).get();
  if (snapshot.empty) {
    logger.info("No documents found!");
    return;
  }
  snapshot.forEach(async (doc) => {
    await doc.ref.update({status: "timeout"});
  });
  logger.info("Timeout requests completed");
  return;
};
