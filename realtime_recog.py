import threading

import cv2
from deepface import DeepFace

cap = cv2.VideoCapture('http://192.168.24.187/mjpeg')

cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)

counter = 0

reference_img = cv2.imread("img5.jpg")  # use your own image here

face_match = False
faceDataList = []

fps = int(cap.get(cv2.CAP_PROP_FPS))
save_interval = 1


def check_face(frame):
    global face_match
    global faceDataList
    try:
        result = DeepFace.verify(frame, reference_img.copy())
        if result['verified']:
            faceDataList = (list(result['facial_areas']['img1'].values()))
            print(faceDataList)
            face_match = True
        else:
            face_match = False
    except ValueError:
        face_match = False

frame_count = 0
while True:
    ret, frame = cap.read()

    if ret:
        frame_count += 1
        if frame_count % (fps * save_interval) == 0:
            frame_count = 0
            try:
                threading.Thread(target=check_face, args=(frame.copy(),)).start()
            except ValueError:
                pass
        if face_match:
            cv2.putText(frame, "MATCH!", (20, 450), cv2.FONT_HERSHEY_SIMPLEX, 2, (0, 255, 0), 3)
            x, y, w, h, r, l = faceDataList
            cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 0, 255), 2)
            cv2.circle(frame, r, radius=5, color=(0, 0, 255), thickness=-1)
            cv2.circle(frame, l, radius=5, color=(0, 0, 255), thickness=-1)
        else:
            cv2.putText(frame, "NO MATCH!", (20, 450), cv2.FONT_HERSHEY_SIMPLEX, 2, (0, 0, 255), 3)

        cv2.namedWindow('video',cv2.WINDOW_NORMAL)
        cv2.imshow('video', frame)

    key = cv2.waitKey(1)
    if key == ord('q'):
        break

cv2.destroyAllWindows()