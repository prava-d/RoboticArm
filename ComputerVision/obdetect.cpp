/**
	Trying out some object detection stuff.
**/

#include <opencv2/opencv.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>

#include <math.h>
#include <vector>
#include <fstream>
#include <iostream>
#include <unistd.h>

using namespace std;
using namespace cv;

bool detectGreen(cv::Mat src)
{
	cv::Mat buf;

	int greenUpper[] = {29, 86, 6};
	int greenLower[] = {64, 255, 255};

	// converts RBG to HSV
	cv::cvtColor(src, buf, cv::COLOR_BGR2HSV);
	if (blur)
	{
		cv::GaussianBlur(buf, buf, cv::Size(5,5), 0, 0);
	}

	// checks whether it is within range
	cv::Mat thresh;
	cv::inRange(buf, Scalar(greenLower[0], greenLower[1], greenLower[2]), Scalar(greenUpper[0], greenUpper[1], greenUpper[2]), thresh);

	// determines whether flag should be set or not
	int sumWhite;

	int whiteUpper[] = {0, 0, 255};
	int whiteLower[] = {0, 0, 0};

	int rows = thresh.rows;
	int cols = thresh.cols;

	int i;
	int j;
	for (i = 0; i < rows; i++)
	{
		for (j = 0; j < cols; j++)
		{
			Vec3b pixel = thresh.at<Vec3b>(i, j);

			if (pixel[0] > whiteLower[0] && pixel[0] < whiteUpper[0] &&
				pixel[1] > whiteLower[1] && pixel[1] < whiteUpper[1] &&
				pixel[2] > whiteLower[2] && pixel[2] < whiteUpper[2])
				sumWhite+=1;
		}
	}

	if (double (sumWhite/(rows*cols) >= 0.125))
		return 1;
	else
		return 0;
}

bool detectRed(cv::Mat src)
{
	cv::Mat buf;

	int redUpper[] = {189, 255, 255};
	int redLower[] = {169, 100, 100};

	// converts RBG to HSV
	cv::cvtColor(src, buf, cv::COLOR_BGR2HSV);
	if (blur)
	{
		cv::GaussianBlur(buf, buf, cv::Size(5,5), 0, 0);
	}

	// checks whether it is within range
	cv::Mat thresh;
	cv::inRange(buf, Scalar(redLower[0], redLower[1], redLower[2]), Scalar(redUpper[0], redUpper[1], redUpper[2]), thresh);

	// determines whether flag should be set or not
	int sumWhite;

	int whiteUpper[] = {0, 0, 255};
	int whiteLower[] = {0, 0, 0};

	int rows = thresh.rows;
	int cols = thresh.cols;

	int i;
	int j;
	for (i = 0; i < rows; i++)
	{
		for (j = 0; j < cols; j++)
		{
			Vec3b pixel = thresh.at<Vec3b>(i, j);

			if (pixel[0] > whiteLower[0] && pixel[0] < whiteUpper[0] &&
				pixel[1] > whiteLower[1] && pixel[1] < whiteUpper[1] &&
				pixel[2] > whiteLower[2] && pixel[2] < whiteUpper[2])
				sumWhite+=1;
		}
	}

	if (double (sumWhite/(rows*cols) >= 0.125))
		return 1;
	else
		return 0;
}

int main(int argc, char** argv)
{

	// some constants
	bool blur = 1;

	VideoCapture stream(0);

	if (!stream.isOpened()) {
		cout << "Can't open camera.";
	}

	cv::Mat cameraframe;

	while (true) {
		
		stream.read(cameraframe);
		imshow("cam", cameraframe);

		if (waitKey(30) >= 0)
			break;
	}

	bool startFlag;
	bool stopFlag;

	bool flag;


	stopFlag = detectRed(cameraframe);
	startFlag = detectGreen(cameraframe);

	if (startFlag && stopFlag)
		startFlag = 0;

	if (stopFlag)
		flag = 0;

	if (startFlag)
		flag = 1;

	// communicating with Arduino
	FILE *file;
    file = fopen("/dev/ttyUSB0","w");  //Opening device file
    fprintf(file,"%d",flag); //Writing to the file
    fprintf(file,"%c",','); //To separate digits
    sleep(1000);
    fclose(file);
}