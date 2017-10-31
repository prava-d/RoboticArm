/**
	Script to detect red and green colors, sets flag.
**/

#include <opencv2/opencv.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>

#include <math.h>
#include <vector>
#include <fstream>
#include <iostream>

using namespace std;
using namespace cv;

int captureVideo() {
	VideoCapture stream(0);

	if (!stream.isOpened()) {
		cout << "Can't open camera.";
	}

	while (true) {
		Mat cameraframe;
		stream.read(cameraframe);
		imshow("cam", cameraframe);

		if (waitKey(30) >= 0)
			break;
	}

	return 0;

}

int main(int argc, const char** argv) {

	// captureVideo();

	Ptr<BackgroundSubtractor> bg_model = createBackgroundSubtractorMOG2().dynamicCast<BackgroundSubtractor>();

	Mat img, foregroundMask, backgroundImage, foregroundImg;

	VideoCapture cap(0);

	for(;;){
		bool ok = cap.grab();

		if (ok == false) {
			std::cout << "Video Capture Fail" << std::endl;
		}
		else {
			cap.retrieve(img, CV_CAP_OPENNI_BGR_IMAGE);
			resize(img, img, Size(640, 480));

			if (foregroundMask.empty()) {
				foregroundMask.create(img.size(), img.type());
			}

			bg_model->apply(img, foregroundMask, true ? -1:0);

			GaussianBlur(foregroundMask, foregroundMask, Size(11,11), 3.5, 3.5);

			threshold(foregroundMask, foregroundMask, 10, 255, THRESH_BINARY);

			foregroundImg = Scalar::all(0);

			img.copyTo(foregroundImg, foregroundMask);

			bg_model->getBackgroundImage(backgroundImage);

			imshow("foreground mask", foregroundMask);
			imshow("foreground image", foregroundImg);

			int key6 = waitKey(4);

			if(!backgroundImage.empty()) {
				imshow("mean background image", backgroundImage);
				int key5 = waitKey(40);
			}
		}
	}
}