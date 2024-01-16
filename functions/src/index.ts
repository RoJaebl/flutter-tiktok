import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const onVideoCreated = functions.firestore
  .document("videos/{videoId}")
  .onCreate(async (snapshot, context) => {
    const spawn = require("child-process-promise").spawn;
    const video = snapshot.data();
    await spawn("ffmpeg", [
      "-i",
      video.fileUrl,
      "-ss",
      "00:00:01.000", // 1초 시간대의 프레임을 가져온다.
      "-vframes",
      "1", // 가져온 프레임의 한개를 사용한다.
      "-vf",
      "scale=150:-1", // 스케일을 너비 150, 높이는 그에 맞추어 비유을 조정한다.
      `/tmp/${snapshot.id}.jpg`, // 해당 이름으로 파일을 저장한다.
    ]);

    const storage = admin.storage();
    const [file, _] = await storage.bucket().upload(`/tmp/${snapshot.id}.jpg`, {
      // 구글 클라우드 서버에 저장된 영상을 업로드 한다.
      destination: `thumbnails/${snapshot.id}.jpg`, // 업로드의 경로는 입력한다.
    });
    await file.makePublic(); // 업로드한 영상을 공개로 설정한다.
    await snapshot.ref.update({ thumbnailUrl: file.publicUrl() }); // 공개로 설정된 영상의 URL를 업데이트 한다.
    const db = admin.firestore();
    await db.collection("videos").doc(snapshot.id).update({ id: snapshot.id });
    await db
      .collection("users")
      .doc(video.creatorUid)
      .collection("videos")
      .doc(snapshot.id)
      .set({ thumbnailUrl: file.publicUrl(), videoId: snapshot.id });
  });

export const onLikedCreated = functions.firestore
  .document("likes/{likeId}")
  .onCreate(async (snapshot, context) => {
    const db = admin.firestore();
    const [videoId, userId] = snapshot.id.split("000");
    await db
      .collection("videos")
      .doc(videoId)
      .update({ likes: admin.firestore.FieldValue.increment(1) });

    const video = await (
      await db.collection("videos").doc(videoId).get()
    ).data();
    if (video) {
      const creatorUid = video.creatorUid;
      const user = (await db.collection("users").doc(creatorUid).get()).data();
      if (user) {
        const token = user.token;
        await admin.messaging().send({
          token: token,
          data: {
            screen: "123",
          },
          notification: {
            title: "someone liked you video",
            body: "Likes + 1 ! Congrats! ❤",
          },
        });
      }
    }
    const thumbnailUrl = (
      await db.collection("videos").doc(videoId).get()
    ).data()!.thumbnailUrl;

    const query = db
      .collection("users")
      .doc(userId)
      .collection("likes")
      .doc(videoId);

    await query.set({ thumbnailUrl: thumbnailUrl as String, videoId: videoId });
  });

export const onLikedRemoved = functions.firestore
  .document("likes/{likeId}")
  .onDelete(async (snapshot, context) => {
    const db = admin.firestore();
    const [videoId, userId] = snapshot.id.split("000");
    await db
      .collection("videos")
      .doc(videoId)
      .update({ likes: admin.firestore.FieldValue.increment(-1) });

    const query = db
      .collection("users")
      .doc(userId)
      .collection("likes")
      .doc(videoId);

    await query.delete();
  });
