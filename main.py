import cv2

img = cv2.imread('img.png')

face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')

gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

faces = face_cascade.detectMultiScale(gray, 1.1, 4)

if len(faces) > 0:
    print(f'Обнаружено {len(faces)} лиц.')
else:
    print('Лица не обнаружены.')
